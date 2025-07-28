import 'package:dartz/dartz.dart';
import '../../repositories/currency_repository.dart';
import '../../../core/errors/failures.dart';

/// Convert Currency Use Case
/// 
/// Implements the business logic for currency conversion.
/// Handles the conversion calculation including bank fees.
class ConvertCurrencyUseCase {
  /// Repository instance for currency operations
  final CurrencyRepository repository;

  /// Creates a new ConvertCurrencyUseCase instance
  ConvertCurrencyUseCase(this.repository);

  /// Executes the currency conversion use case
  /// 
  /// Uses named parameters for clarity and type safety
  /// 
  /// [from] - Source currency code (e.g., 'USD')
  /// [to] - Target currency code (e.g., 'EUR')
  /// [amount] - Amount to convert in source currency
  /// 
  /// Returns Either<Failure, double>:
  /// - Success: Converted amount after bank fees
  /// - Failure: ServerFailure or NetworkFailure with error message
  /// 
  /// The conversion includes the bank's profit margin,
  /// so the returned amount is what the customer receives.
  Future<Either<Failure, double>> call({
    required String from,
    required String to,
    required double amount,
  }) async {

    // Validate amount is positive
    if (amount <= 0) {
      return const Left(ServerFailure('Amount must be positive'));
    }
    
     // Delegate to repository for conversion with fees
    return await repository.convertCurrency(from, to, amount);
  }
}