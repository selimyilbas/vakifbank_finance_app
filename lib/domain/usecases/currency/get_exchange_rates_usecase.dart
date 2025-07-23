import 'package:dartz/dartz.dart';
import '../../entities/currency.dart';
import '../../repositories/currency_repository.dart';
import '../../../core/errors/failures.dart';

class GetExchangeRatesUseCase {
  final CurrencyRepository repository;

  GetExchangeRatesUseCase(this.repository);

  Future<Either<Failure, List<Currency>>> call(String baseCurrency) async {
    return await repository.getExchangeRates(baseCurrency);
  }
}