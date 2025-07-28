import 'package:dartz/dartz.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';

/// Get Transactions Use Case
/// 
/// Implements the business logic for retrieving transaction history.
/// Supports both admin (all transactions) and customer (own transactions) views.

class GetTransactionsUseCase {
  /// Repository instance for transaction operations
  final TransactionRepository repository;

  /// Creates a new GetTransactionsUseCase instance
  GetTransactionsUseCase(this.repository);

   /// Executes the get transactions use case
  /// 
  /// [userId] - Optional user ID to filter transactions
  ///           If null, returns all transactions (admin only)
  ///           If provided, returns only that user's transactions
  /// 
  /// Returns Either<Failure, List<Transaction>>:
  /// - Success: List of Transaction entities
  /// - Failure: ServerFailure with error message
  /// 
  /// Note: Access control should be enforced at the repository
  /// or data source level based on the current user's role.
  Future<Either<Failure, List<Transaction>>> call({String? userId}) async {
    if (userId != null) {
      // Get specific user's transactions
      return await repository.getUserTransactions(userId);
    }
    // Get all transactions (admin functionality)
    return await repository.getTransactions();
  }
}