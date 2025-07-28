import 'package:dartz/dartz.dart';
import '../entities/currency.dart';
import '../../core/errors/failures.dart';

/// Currency Repository Interface
/// 
/// Defines the contract for currency-related operations in the domain layer.
/// Handles fetching exchange rates and performing currency conversions.
abstract class CurrencyRepository {
  /// Fetches current exchange rates for a given base currency
  /// 
  /// [baseCurrency] - The base currency code (e.g., 'USD')
  /// 
  /// Returns Either<Failure, List<Currency>>:
  /// - Success: List of Currency entities with current rates
  /// - Failure: ServerFailure or NetworkFailure with error details
  Future<Either<Failure, List<Currency>>> getExchangeRates(String baseCurrency);

  /// Converts an amount from one currency to another
  /// 
  /// [from] - Source currency code
  /// [to] - Target currency code
  /// [amount] - Amount to convert
  /// 
  /// Returns Either<Failure, double>:
  /// - Success: Converted amount after applying bank fees
  /// - Failure: ServerFailure or NetworkFailure with error details
  /// 
  /// Note: The returned amount includes the bank's profit margin deduction
  Future<Either<Failure, double>> convertCurrency(
    String from,
    String to,
    double amount,
  );
}