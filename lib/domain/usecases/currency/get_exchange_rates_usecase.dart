import 'package:dartz/dartz.dart';
import '../../entities/currency.dart';
import '../../repositories/currency_repository.dart';
import '../../../core/errors/failures.dart';

/// Get Exchange Rates Use Case
/// 
/// Implements the business logic for fetching current exchange rates.
/// Retrieves real-time currency data from external APIs.
class GetExchangeRatesUseCase {
  /// Repository instance for currency operations
  final CurrencyRepository repository;
  /// Creates a new GetExchangeRatesUseCase instance
  GetExchangeRatesUseCase(this.repository);

  /// Executes the get exchange rates use case
  /// 
  /// [baseCurrency] - The base currency for rate calculations
  /// 
  /// Returns Either<Failure, List<Currency>>:
  /// - Success: List of Currency entities with current rates
  /// - Failure: ServerFailure or NetworkFailure with error message
  /// 
  /// The returned rates are relative to the base currency.
  /// For example, if base is USD and EUR rate is 0.85,
  /// it means 1 USD = 0.85 EUR.
  Future<Either<Failure, List<Currency>>> call(String baseCurrency) async {
    // Validate base currency before proceeding
    // In a more complex app, this could include additional validation
    
    // Delegate to repository for API call
    return await repository.getExchangeRates(baseCurrency);
  }
}