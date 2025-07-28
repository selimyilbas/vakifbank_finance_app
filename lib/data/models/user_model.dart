import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../domain/entities/user.dart';

/// User Model
/// 
/// Data layer representation of a User that handles serialization
/// between the domain entity and external data formats (JSON/Firestore).
/// 
/// Extends the User entity to maintain all domain properties while
/// adding serialization capabilities.

class UserModel extends User {
  /// Creates a UserModel instance
  /// 
  /// Inherits all properties from the User entity
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

  /// Factory constructor to create UserModel from JSON/Firestore data
  /// 
  /// [json] - Map containing user data from Firestore
  /// 
  /// Handles conversion of Firestore Timestamp to DateTime
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      // Convert Firestore Timestamp to DateTime
      createdAt: (json['createdAt'] as firestore.Timestamp).toDate(),
    );
  }

  /// Converts UserModel to JSON format for Firestore storage
  /// 
  /// Returns a Map suitable for Firestore document creation
  /// Converts DateTime to Firestore Timestamp for proper storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      // Convert DateTime to Firestore Timestamp
      'createdAt': firestore.Timestamp.fromDate(createdAt),
    };
  }

  /// Factory constructor to create UserModel from domain User entity
  /// 
  /// [user] - Domain layer User entity
  /// 
  /// Used when converting from domain to data layer
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