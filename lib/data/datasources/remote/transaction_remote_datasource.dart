import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/transaction_model.dart';

/// Transaction Remote Data Source Interface
/// 
/// Defines the contract for transaction operations with Firestore
abstract class TransactionRemoteDataSource {
  /// Saves a transaction to Firestore
  Future<void> createTransaction(TransactionModel transaction);
  
  /// Retrieves all transactions from Firestore
  Future<List<TransactionModel>> getTransactions();
  
  /// Retrieves transactions for specific user
  Future<List<TransactionModel>> getUserTransactions(String userId);
}

/// Transaction Remote Data Source Implementation
/// 
/// Handles all transaction-related operations with Firestore.
/// Transactions are immutable once created for audit integrity.
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  /// Firestore instance for database operations
  final FirebaseFirestore firestore;

  /// Creates new TransactionRemoteDataSourceImpl instance
  TransactionRemoteDataSourceImpl(this.firestore);

  /// Creates new transaction document in Firestore
  /// 
  /// [transaction] - Transaction model to save
  /// 
  /// Uses transaction ID as document ID for easy retrieval
  /// 
  /// Throws:
  /// - ServerException: For database operation failures
  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      // Save transaction with ID as document ID
      await firestore.collection('transactions').doc(transaction.id).set(
            transaction.toJson(),
          );
    } catch (e) {
      throw ServerException('Failed to create transaction: ${e.toString()}');
    }
  }

  /// Retrieves all transactions ordered by date
  /// 
  /// Returns transactions in descending order (newest first)
  /// This method is typically restricted to admin users
  /// 
  /// Throws:
  /// - ServerException: For query failures
  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      // Query all transactions, newest first
      final snapshot = await firestore
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .get();

      // Convert documents to TransactionModel list
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get transactions: ${e.toString()}');
    }
  }

  /// Retrieves transactions for specific user
  /// 
  /// [userId] - ID of user whose transactions to retrieve
  /// 
  /// Returns user's transactions in descending order
  /// Requires compound index on userId and createdAt fields
  /// 
  /// Throws:
  /// - ServerException: For query failures
  @override
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    try {
      // Query user's transactions, newest first
      final snapshot = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      // Convert documents to TransactionModel list
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get user transactions: ${e.toString()}');
    }
  }
}