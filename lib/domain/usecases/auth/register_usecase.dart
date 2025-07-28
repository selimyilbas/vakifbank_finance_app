import 'package:dartz/dartz.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';


/// Register Use Case
/// 
/// Implements the business logic for user registration.
/// Handles creating new user accounts with specified roles.
class RegisterUseCase {
  /// Repository instance for authentication operations
  final AuthRepository repository;

  /// Creates a new RegisterUseCase instance
  RegisterUseCase(this.repository);

  /// Executes the registration use case
  /// 
  /// Named parameters for better readability and parameter safety
  /// 
  /// [email] - New user's email address
  /// [password] - New user's password (should be validated)
  /// [name] - Display name for the user
  /// [role] - User role ('customer' or 'admin')
  /// 
  /// Returns Either<Failure, User>:
  /// - Success: Newly created User entity
  /// - Failure: AuthFailure with error message
  Future<Either<Failure, User>> call({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
  // Delegate to repository for user creation
    return await repository.register(email, password, name, role);
  }
}