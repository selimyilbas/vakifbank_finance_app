import 'package:dartz/dartz.dart';
import '../entities/currency.dart';
import '../../core/errors/failures.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, List<Currency>>> getExchangeRates(String baseCurrency);
  Future<Either<Failure, double>> convertCurrency(
    String from,
    String to,
    double amount,
  );
}