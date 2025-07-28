import 'package:equatable/equatable.dart';

/// Base Authentication Event
/// 
/// All authentication-related events extend this abstract class.
/// Events represent user actions or system triggers that cause state changes.
/// Using Equatable for value equality comparison in tests and debugging.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Login Request Event
/// 
/// Triggered when a user attempts to login with credentials.
/// Contains the necessary information for authentication.
class LoginRequested extends AuthEvent {
  /// User's email address for authentication
  final String email;
  
  /// User's password (will be securely transmitted to Firebase)
  final String password;

  /// Creates a login request event with required credentials
  const LoginRequested({
    required this.email,
    required this.password,
  });

  /// Props for Equatable comparison
  /// Enables the BLoC to determine if two events are identical
  @override
  List<Object> get props => [email, password];
}

/// Registration Request Event
/// 
/// Triggered when a new user attempts to create an account.
/// Contains all required information for user registration.
class RegisterRequested extends AuthEvent {
  /// New user's email address (must be unique in the system)
  final String email;
  
  /// New user's password (must meet security requirements)
  final String password;
  
  /// Display name for the user profile
  final String name;
  
  /// User role determining access levels ('customer' or 'admin')
  /// Note: In current implementation, only 'customer' role is allowed through UI
  final String role;

  /// Creates a registration request event with user details
  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  /// Props for Equatable comparison
  @override
  List<Object> get props => [email, password, name, role];
}

/// Logout Request Event
/// 
/// Triggered when user initiates logout action.
/// No parameters needed as it operates on the current authenticated session.
class LogoutRequested extends AuthEvent {}

/// Authentication Check Request Event
/// 
/// Triggered on app startup to verify if a user session exists.
/// Used to restore user session and navigate to appropriate screen.
/// Checks both Firebase Auth state and cached user data.
class AuthCheckRequested extends AuthEvent {}