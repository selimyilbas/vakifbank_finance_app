import 'package:equatable/equatable.dart';

// Transaction Entity
// 
// Represents a currency conversion transaction in the domain layer.
// Contains all information about a completed currency exchange,
// including the amounts, rates, and bank profit.
class Transaction extends Equatable {
  // Unique identifier for the transaction
  final String id;

  // ID of the user who performed the transaction
  final String userId;

  // Source currency code (e.g., 'USD')
  final String fromCurrency;

  // Target currency code (e.g., 'EUR')
  final String toCurrency;

  // Amount in the source currency
  final double fromAmount;

  // Converted amount in the target currency
  final double toAmount;

  // Exchange rate used for this transaction
  final double exchangeRate;

  // Bank profit from this transaction (in source currency)
  // Calculated as fromAmount * bankProfitMargin
  final double bankProfit;

  // Timestamp of when the transaction was created
  final DateTime createdAt;

  // Creates a new Transaction instance
  const Transaction({
    required this.id,
    required this.userId,
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.exchangeRate,
    required this.bankProfit,
    required this.createdAt,
  });

  // Equatable props for value comparison
  @override
  List<Object> get props => [
        id,
        userId,
        fromCurrency,
        toCurrency,
        fromAmount,
        toAmount,
        exchangeRate,
        bankProfit,
        createdAt,
      ];
}