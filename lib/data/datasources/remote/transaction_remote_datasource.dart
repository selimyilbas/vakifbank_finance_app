import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> createTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<List<TransactionModel>> getUserTransactions(String userId);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      await firestore.collection('transactions').doc(transaction.id).set(
            transaction.toJson(),
          );
    } catch (e) {
      throw ServerException('Failed to create transaction: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final snapshot = await firestore
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get transactions: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    try {
      final snapshot = await firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get user transactions: ${e.toString()}');
    }
  }
}