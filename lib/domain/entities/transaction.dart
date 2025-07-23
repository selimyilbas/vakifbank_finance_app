import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String userId;
  final String fromCurrency;
  final String toCurrency;
  final double fromAmount;
  final double toAmount;
  final double exchangeRate;
  final double bankProfit;
  final DateTime createdAt;

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