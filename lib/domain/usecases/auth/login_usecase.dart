import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

/// Login Use Case
/// 
/// Implements the business logic for user authentication.
/// This use case follows the Single Responsibility Principle by handling
/// only the login functionality.
/// 
/// Use cases encapsulate and orchestrate the flow of data to and from
/// the entities, and direct those entities to use their business rules
/// to achieve the goals of the use case.
class LoginUseCase {
  /// Repository instance for authentication operations
  final AuthRepository repository;

  /// Creates a new LoginUseCase instance
  /// 
  /// [repository] - The authentication repository to use
  LoginUseCase(this.repository);

  /// Executes the login use case
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns Either<Failure, User>:
  /// - Success: Authenticated User entity
  /// - Failure: AuthFailure with error message
  /// 
  /// This method orchestrates the login process by delegating
  /// to the repository layer while maintaining business logic
  /// in the domain layer.
  Future<Either<Failure, User>> call(String email, String password) async {
    // Delegate to repository for actual authentication
    return await repository.login(email, password);
  }
}