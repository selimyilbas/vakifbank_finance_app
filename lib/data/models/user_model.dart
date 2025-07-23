import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    required String name,
    required String role,
    required DateTime createdAt,
  }) : super(
          id: id,
          email: email,
          name: name,
          role: role,
          createdAt: createdAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      createdAt: (json['createdAt'] as firestore.Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      createdAt: user.createdAt,
    );
  }
}