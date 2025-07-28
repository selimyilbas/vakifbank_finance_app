import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

/// Get Current User Use Case
/// 
/// Implements the business logic for retrieving the currently
/// authenticated user's information.
/// Used for session management and authorization checks.
class GetCurrentUserUseCase {
  /// Repository instance for authentication operations
  final AuthRepository repository;

  /// Creates a new GetCurrentUserUseCase instance
  GetCurrentUserUseCase(this.repository);

  /// Executes the get current user use case
  /// 
  /// Returns Either<Failure, User?>:
  /// - Success: User entity if authenticated, null if not
  /// - Failure: AuthFailure with error message
  /// 
  /// This is typically called on app startup to check if
  /// there's an existing authenticated session.
  Future<Either<Failure, User?>> call() async {
    // Delegate to repository for current user retrieval
    return await repository.getCurrentUser();
  }
}