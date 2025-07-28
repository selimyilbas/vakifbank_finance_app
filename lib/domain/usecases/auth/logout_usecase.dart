import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

/// Logout Use Case
/// 
/// Implements the business logic for user logout.
/// Handles signing out the current user and clearing session data.
class LogoutUseCase {
  /// Repository instance for authentication operations
  final AuthRepository repository;
  
  /// Creates a new LogoutUseCase instance 
  LogoutUseCase(this.repository);

  /// Executes the logout use case
  /// 
  /// No parameters needed as it operates on the current session
  /// 
  /// Returns Either<Failure, void>:
  /// - Success: void (logout completed)
  /// - Failure: AuthFailure with error message
  Future<Either<Failure, void>> call() async {
    // Delegate to repository for logout operation
    return await repository.logout();
  }
}