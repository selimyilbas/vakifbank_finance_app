import 'package:equatable/equatable.dart';
import '../../../domain/entities/currency.dart';

/// Base Currency State
/// 
/// Represents the state of currency operations in the application.
/// All specific currency states extend this abstract class.
abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

/// Initial Currency State
/// 
/// The default state before any currency operation occurs.
/// This is the starting state when the BLoC is created.
class CurrencyInitial extends CurrencyState {}

/// Currency Loading State
/// 
/// Indicates a currency operation is in progress.
/// Used to show loading indicators during:
/// - Fetching exchange rates from API
/// - Performing currency conversion calculations
/// - Handling API retries on failure
class CurrencyLoading extends CurrencyState {}

/// Currency Rates Loaded State
/// 
/// Indicates successful retrieval of exchange rates.
/// Contains current rates for all supported currencies.
/// 
/// Used by:
/// - Currency converter page to display live rates
/// - Exchange rates page for rate listing
/// - Conversion calculations
class CurrencyRatesLoaded extends CurrencyState {
  /// List of currencies with their current exchange rates
  /// Each currency includes code, rate, and last update time
  final List<Currency> currencies;
  
  /// The base currency used for these rates
  /// All rates are relative to this currency (e.g., 1 USD = X other currency)
  final String baseCurrency;

  /// Creates state with loaded currency data
  const CurrencyRatesLoaded({
    required this.currencies,
    required this.baseCurrency,
  });

  /// Props for state comparison
  @override
  List<Object> get props => [currencies, baseCurrency];
}

/// Currency Converted State
/// 
/// Indicates successful currency conversion.
/// Contains conversion details for display and transaction recording.
/// 
/// This state triggers:
/// - Display of conversion result dialog
/// - Creation of transaction record
/// - Update of UI with converted values
class CurrencyConverted extends CurrencyState {
  /// Final converted amount after applying bank fees
  /// This is what the customer receives
  final double result;
  
  /// Source currency code used in conversion
  final String from;
  
  /// Target currency code used in conversion
  final String to;
  
  /// Original amount before conversion
  final double amount;

  /// Creates state with conversion results
  const CurrencyConverted({
    required this.result,
    required this.from,
    required this.to,
    required this.amount,
  });

  /// Props for state comparison
  @override
  List<Object> get props => [result, from, to, amount];
}

/// Currency Error State
/// 
/// Indicates a currency operation failed.
/// Contains error message for user feedback.
/// 
/// Common scenarios:
/// - Network connectivity issues
/// - API rate limits exceeded
/// - Invalid currency codes
/// - API service unavailable
class CurrencyError extends CurrencyState {
  /// Human-readable error message for display
  final String message;

  /// Creates error state with message
  const CurrencyError(this.message);

  /// Props for state comparison
  @override
  List<Object> get props => [message];
}