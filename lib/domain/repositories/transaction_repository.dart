import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../../core/errors/failures.dart';

/// Transaction Repository Interface
/// 
/// Defines the contract for transaction-related operations in the domain layer.
/// Handles creating transactions and retrieving transaction history.
abstract class TransactionRepository {
  /// Creates a new transaction record
  /// 
  /// [transaction] - Transaction entity to be saved
  /// 
  /// Returns Either<Failure, void>:
  /// - Success: void (transaction saved successfully)
  /// - Failure: ServerFailure with error details
  
  Future<Either<Failure, void>> createTransaction(Transaction transaction);

  /// Retrieves all transactions (admin only)
  /// 
  /// Returns Either<Failure, List<Transaction>>:
  /// - Success: List of all transactions in the system
  /// - Failure: ServerFailure with error details
  Future<Either<Failure, List<Transaction>>> getTransactions();

   /// Retrieves transactions for a specific user
  /// 
  /// [userId] - ID of the user whose transactions to retrieve
  /// 
  /// Returns Either<Failure, List<Transaction>>:
  /// - Success: List of user's transactions
  /// - Failure: ServerFailure with error details
  Future<Either<Failure, List<Transaction>>> getUserTransactions(String userId);

  /// Calculates total bank profit for a specific date
  /// 
  /// [date] - Date for which to calculate profit
  /// 
  /// Returns Either<Failure, double>:
  /// - Success: Total profit amount for the date
  /// - Failure: ServerFailure with error details
  Future<Either<Failure, double>> calculateDailyProfit(DateTime date);
}