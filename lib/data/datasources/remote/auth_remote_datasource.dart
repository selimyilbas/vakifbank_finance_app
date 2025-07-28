import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

/// Authentication Remote Data Source Interface
/// 
/// Defines the contract for authentication operations with Firebase
abstract class AuthRemoteDataSource {
  /// Authenticates user with Firebase Auth
  Future<UserModel> login(String email, String password);
  
  /// Creates new user account in Firebase Auth and Firestore
  Future<UserModel> register(String email, String password, String name, String role);
  
  /// Signs out current user from Firebase Auth
  Future<void> logout();
  
  /// Gets current authenticated user from Firebase
  Future<UserModel?> getCurrentUser();
}

/// Authentication Remote Data Source Implementation
/// 
/// Handles all authentication operations with Firebase Auth and Firestore.
/// Manages both authentication (Firebase Auth) and user data (Firestore).
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Firebase Auth instance for authentication operations
  final firebase_auth.FirebaseAuth firebaseAuth;
  
  /// Firestore instance for user data storage
  /// Using direct instance instead of dependency injection for simplicity
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates new AuthRemoteDataSourceImpl instance
  AuthRemoteDataSourceImpl(this.firebaseAuth);

  /// Authenticates user with email and password
  /// 
  /// Process:
  /// 1. Sign in with Firebase Auth
  /// 2. Retrieve user data from Firestore
  /// 3. Return complete user model
  /// 
  /// Throws:
  /// - AuthException: For authentication failures
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Attempt Firebase Auth sign in
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify successful authentication
      if (credential.user == null) {
        throw AuthException('Login failed');
      }

      // Retrieve user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      // Verify user document exists
      if (!userDoc.exists) {
        throw AuthException('User data not found');
      }

      // Convert Firestore document to UserModel
      return UserModel.fromJson(userDoc.data()!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      throw AuthException(e.message ?? 'Authentication error');
    } catch (e) {
      // Handle any other errors
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  /// Registers new user account
  /// 
  /// Process:
  /// 1. Create Firebase Auth account
  /// 2. Create user document in Firestore
  /// 3. Return new user model
  /// 
  /// Throws:
  /// - AuthException: For registration failures
  @override
  Future<UserModel> register(String email, String password, String name, String role) async {
    try {
      // Create Firebase Auth account
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify account creation
      if (credential.user == null) {
        throw AuthException('Registration failed');
      }

      // Create user model with provided data
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific errors
      throw AuthException(e.message ?? 'Registration error');
    } catch (e) {
      // Handle any other errors
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  /// Signs out current user
  /// 
  /// Throws:
  /// - AuthException: For logout failures
  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  /// Gets currently authenticated user
  /// 
  /// Returns null if no authenticated user exists
  /// 
  /// Throws:
  /// - AuthException: For data retrieval failures
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Get current Firebase Auth user
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        return null;
      }

      // Retrieve user data from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      // Return null if user document doesn't exist
      if (!userDoc.exists) {
        return null;
      }

      // Convert to UserModel
      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }
}