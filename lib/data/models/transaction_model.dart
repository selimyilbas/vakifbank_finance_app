import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../domain/entities/transaction.dart' as domain;

class TransactionModel extends domain.Transaction {
  const TransactionModel({
    required String id,
    required String userId,
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
    required double toAmount,
    required double exchangeRate,
    required double bankProfit,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          fromAmount: fromAmount,
          toAmount: toAmount,
          exchangeRate: exchangeRate,
          bankProfit: bankProfit,
          createdAt: createdAt,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      bankProfit: (json['bankProfit'] as num).toDouble(),
      createdAt: (json['createdAt'] as firestore.Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'fromAmount': fromAmount,
      'toAmount': toAmount,
      'exchangeRate': exchangeRate,
      'bankProfit': bankProfit,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
    };
  }

  factory TransactionModel.fromEntity(domain.Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      fromCurrency: transaction.fromCurrency,
      toCurrency: transaction.toCurrency,
      fromAmount: transaction.fromAmount,
      toAmount: transaction.toAmount,
      exchangeRate: transaction.exchangeRate,
      bankProfit: transaction.bankProfit,
      createdAt: transaction.createdAt,
    );
  }
}