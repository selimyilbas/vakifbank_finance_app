import 'package:dartz/dartz.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/remote/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createTransaction(Transaction transaction) async {
    try {
      final transactionModel = TransactionModel.fromEntity(transaction);
      await remoteDataSource.createTransaction(transactionModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to create transaction: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions() async {
    try {
      final transactions = await remoteDataSource.getTransactions();
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get transactions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getUserTransactions(String userId) async {
    try {
      final transactions = await remoteDataSource.getUserTransactions(userId);
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get user transactions: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> calculateDailyProfit(DateTime date) async {
    try {
      final transactions = await remoteDataSource.getTransactions();
      
      final dailyTransactions = transactions.where((transaction) {
        return transaction.createdAt.year == date.year &&
            transaction.createdAt.month == date.month &&
            transaction.createdAt.day == date.day;
      }).toList();
      
      final totalProfit = dailyTransactions.fold(
        0.0,
        (sum, transaction) => sum + transaction.bankProfit,
      );
      
      return Right(totalProfit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to calculate daily profit: ${e.toString()}'));
    }
  }
}