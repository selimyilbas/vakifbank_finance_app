import 'package:dartz/dartz.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';


/// Create Transaction Use Case
/// 
/// Implements the business logic for recording currency conversion transactions.
/// Each successful currency conversion creates a transaction record for
/// audit and reporting purposes.

class CreateTransactionUseCase {
  /// Repository instance for transaction operations
  
  final TransactionRepository repository;
  /// Creates a new CreateTransactionUseCase instance
  CreateTransactionUseCase(this.repository);

  /// Executes the create transaction use case
  /// 
  /// [transaction] - Complete transaction entity to be saved
  /// 
  /// Returns Either<Failure, void>:
  /// - Success: void (transaction saved successfully)
  /// - Failure: ServerFailure with error message
  /// 
  /// Transactions are immutable once created for audit integrity.

  Future<Either<Failure, void>> call(Transaction transaction) async {
    // Could add business validation here if needed
    // For example: validate minimum amounts, restricted currencies, etc.
    
    // Delegate to repository for persistence
    return await repository.createTransaction(transaction);
  }
}