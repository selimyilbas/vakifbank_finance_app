import 'package:equatable/equatable.dart';

/// Base Currency Event
/// 
/// All currency-related events extend this abstract class.
/// Events represent user actions that trigger currency operations.
abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

/// Get Exchange Rates Request Event
/// 
/// Triggered when user wants to view current exchange rates.
/// Fetches real-time currency data from external API.
/// 
/// Use cases:
/// - Initial load on currency converter page
/// - Refresh action by user
/// - Base currency change
class GetExchangeRatesRequested extends CurrencyEvent {
  /// Base currency for rate calculations (e.g., 'USD', 'EUR')
  /// All returned rates will be relative to this currency
  final String baseCurrency;

  /// Creates event with specified base currency
  const GetExchangeRatesRequested(this.baseCurrency);

  /// Props for event comparison
  @override
  List<Object> get props => [baseCurrency];
}

/// Convert Currency Request Event
/// 
/// Triggered when user performs a currency conversion.
/// Calculates converted amount including bank fees.
/// 
/// Process:
/// 1. Fetch current exchange rate
/// 2. Apply bank profit margin (0.2%)
/// 3. Return final converted amount
/// 4. Create transaction record for history
class ConvertCurrencyRequested extends CurrencyEvent {
  /// Source currency code (ISO 4217)
  final String from;
  
  /// Target currency code (ISO 4217)
  final String to;
  
  /// Amount to convert in source currency
  final double amount;

  /// Creates conversion event with required parameters
  const ConvertCurrencyRequested({
    required this.from,
    required this.to,
    required this.amount,
  });

  /// Props for event comparison
  @override
  List<Object> get props => [from, to, amount];
}