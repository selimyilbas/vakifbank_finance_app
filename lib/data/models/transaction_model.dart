import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
// Using alias to avoid naming conflict with Firestore's Transaction class
import '../../domain/entities/transaction.dart' as domain;

/// Transaction Model
/// 
/// Data layer representation of Transaction that handles serialization
/// between the domain entity and Firestore documents.
/// 
/// Note: We use an alias for the domain Transaction to avoid conflicts
/// with Firestore's Transaction class used for database transactions.
class TransactionModel extends domain.Transaction {
   /// Creates a TransactionModel instance
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

  /// Factory constructor to create TransactionModel from Firestore data
  /// 
  /// [json] - Map containing transaction data from Firestore
  /// 
  /// Handles type conversions:
  /// - num to double for numeric values (Firestore can return int or double)
  /// - Timestamp to DateTime for date values
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      fromCurrency: json['fromCurrency'],
      toCurrency: json['toCurrency'],
      // Convert num to double safely
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      bankProfit: (json['bankProfit'] as num).toDouble(),
      // Convert Firestore Timestamp to DateTime
      createdAt: (json['createdAt'] as firestore.Timestamp).toDate(),
    );
  }

  /// Converts TransactionModel to JSON format for Firestore storage
  /// 
  /// Returns a Map suitable for Firestore document creation
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
      // Convert DateTime to Firestore Timestamp
      'createdAt': firestore.Timestamp.fromDate(createdAt),
    };
  }
  
  /// Factory constructor to create TransactionModel from domain entity
  /// 
  /// [transaction] - Domain layer Transaction entity
  /// 
  /// Used when converting from domain to data layer for storage
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