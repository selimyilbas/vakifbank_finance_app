import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';


/// Authentication Repository Interface
/// 
/// Defines the contract for authentication operations in the domain layer.
/// This is an abstract class that will be implemented in the data layer.
/// 
/// Uses the Either type from dartz package for functional error handling:
/// - Left: Contains a Failure object in case of error
/// - Right: Contains the success value
abstract class AuthRepository {
  /// Authenticates a user with email and password
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns Either<Failure, User>:
  /// - Success: User entity with authenticated user's data
  /// - Failure: AuthFailure with error details
  Future<Either<Failure, User>> login(String email, String password);

  /// Registers a new user account
  /// 
  /// [email] - New user's email address
  /// [password] - New user's password
  /// [name] - Display name for the user
  /// [role] - User role ('customer' or 'admin')
  /// 
  /// Returns Either<Failure, User>:
  /// - Success: User entity with new user's data
  /// - Failure: AuthFailure with error details
  Future<Either<Failure, User>> register(String email, String password, String name, String role);
  
  /// Signs out the current user
  /// 
  /// Returns Either<Failure, void>:
  /// - Success: void (operation completed)
  /// - Failure: AuthFailure with error details
  Future<Either<Failure, void>> logout();

  /// Retrieves the currently authenticated user 
   
  /// Returns Either<Failure, User?>:
  /// - Success: User entity if authenticated, null if not
  /// - Failure: AuthFailure with error details
  Future<Either<Failure, User?>> getCurrentUser();
}