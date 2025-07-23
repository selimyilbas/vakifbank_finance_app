import 'package:dartz/dartz.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<Failure, List<Transaction>>> call({String? userId}) async {
    if (userId != null) {
      return await repository.getUserTransactions(userId);
    }
    return await repository.getTransactions();
  }
}