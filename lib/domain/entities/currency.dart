import 'package:equatable/equatable.dart';

// Currency Entity
 
// Represents currency exchange rate information in the domain layer.
// Contains the essential data needed for currency conversion calculations.
class Currency extends Equatable {
  // ISO 4217 currency code (e.g., 'USD', 'EUR', 'TRY')
  final String code;

  // Exchange rate relative to the base currency
  // For example, if base is USD and this is EUR, rate might be 0.85
  final double rate;

  // Timestamp of when this exchange rate was last updated
  // Used to show data freshness to users
  final DateTime lastUpdated;

  // Creates a new Currency instance
  const Currency({
    required this.code,
    required this.rate,
    required this.lastUpdated,
  });

  // Equatable props for value comparison
  @override
  List<Object> get props => [code, rate, lastUpdated];
}