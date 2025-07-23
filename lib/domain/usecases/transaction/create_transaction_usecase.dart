import 'package:dartz/dartz.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(Transaction transaction) async {
    return await repository.createTransaction(transaction);
  }
}