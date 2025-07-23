import 'package:dartz/dartz.dart';
import '../../domain/entities/currency.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/remote/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Currency>>> getExchangeRates(String baseCurrency) async {
    try {
      final currencies = await remoteDataSource.getExchangeRates(baseCurrency);
      return Right(currencies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get exchange rates: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, double>> convertCurrency(
    String from,
    String to,
    double amount,
  ) async {
    try {
      final rates = await remoteDataSource.getExchangeRates(from);
      final targetRate = rates.firstWhere((currency) => currency.code == to);
      
      // Apply bank profit margin
      final convertedAmount = amount * targetRate.rate;
      final amountWithProfit = convertedAmount * (1 - AppConstants.bankProfitMargin);
      
      return Right(amountWithProfit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to convert currency: ${e.toString()}'));
    }
  }
}