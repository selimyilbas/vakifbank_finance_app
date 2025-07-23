import 'package:dartz/dartz.dart';
import '../../repositories/currency_repository.dart';
import '../../../core/errors/failures.dart';

class ConvertCurrencyUseCase {
  final CurrencyRepository repository;

  ConvertCurrencyUseCase(this.repository);

  Future<Either<Failure, double>> call({
    required String from,
    required String to,
    required double amount,
  }) async {
    return await repository.convertCurrency(from, to, amount);
  }
}