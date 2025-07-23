import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../../core/errors/failures.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> createTransaction(Transaction transaction);
  Future<Either<Failure, List<Transaction>>> getTransactions();
  Future<Either<Failure, List<Transaction>>> getUserTransactions(String userId);
  Future<Either<Failure, double>> calculateDailyProfit(DateTime date);
}