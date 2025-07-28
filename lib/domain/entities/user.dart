import 'package:equatable/equatable.dart';

/// User Entity
/// 
/// Represents a user in the domain layer of the application.
/// This is a pure Dart class with no dependencies on external packages
/// or frameworks, following Clean Architecture principles.
/// 
/// The entity contains core user information needed for authentication
/// and authorization throughout the application.

class User extends Equatable {

  /// Unique identifier for the user (Firebase Auth UID)
  final String id;

  /// User's email address used for authentication
  final String email;

  /// Display name of the user
  final String name;

  /// User's role in the system ('customer' or 'admin')
  /// Determines access levels and available features
  final String role;

  /// Timestamp of when the user account was created
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  
/// Equatable props for value comparison
  /// 
  /// Enables User instances to be compared by value rather than reference
  /// Useful for state management and testing
  @override
  List<Object> get props => [id, email, name, role, createdAt];
}