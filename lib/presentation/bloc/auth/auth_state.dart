import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

/// Base Authentication State
/// 
/// Represents the authentication status of the application.
/// All specific auth states extend this abstract class.
/// Uses Equatable for efficient state comparison in BLoC.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial Authentication State
/// 
/// The default state before any authentication check occurs.
/// This is the starting state when the BLoC is created.
class AuthInitial extends AuthState {}

/// Authentication Loading State
/// 
/// Indicates an authentication operation is in progress.
/// Used to show loading indicators during:
/// - Login attempts
/// - Registration process
/// - Session verification
/// - Logout operations
class AuthLoading extends AuthState {}

/// Authenticated State
/// 
/// Indicates successful authentication with an active user session.
/// Contains the authenticated user's information for use throughout the app.
class AuthAuthenticated extends AuthState {
  /// The currently authenticated user entity
  /// Contains user ID, email, name, role, and creation date
  final User user;

  /// Creates an authenticated state with user information
  const AuthAuthenticated(this.user);

  /// Props for state comparison
  /// Allows BLoC to detect when user information changes
  @override
  List<Object> get props => [user];
}

/// Unauthenticated State
/// 
/// Indicates no active user session exists.
/// User must login to access protected features.
/// This state triggers navigation to the login screen.
class AuthUnauthenticated extends AuthState {}

/// Authentication Error State
/// 
/// Indicates an authentication operation failed.
/// Contains error message for user feedback.
/// Common scenarios:
/// - Invalid credentials
/// - Network errors
/// - Firebase authentication errors
/// - Account already exists (registration)
class AuthError extends AuthState {
  /// Human-readable error message to display to the user
  final String message;

  /// Creates an error state with descriptive message
  const AuthError(this.message);

  /// Props for state comparison
  @override
  List<Object> get props => [message];
}