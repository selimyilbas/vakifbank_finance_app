import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name, String role);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Login failed');
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException('User data not found');
      }

      return UserModel.fromJson(userDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication error');
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register(String email, String password, String name, String role) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Registration failed');
      }

      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration error');
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return null;
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }
}