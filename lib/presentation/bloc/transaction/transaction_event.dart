import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class CreateTransactionRequested extends TransactionEvent {
  final Transaction transaction;

  const CreateTransactionRequested(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class GetTransactionsRequested extends TransactionEvent {
  final String? userId;

  const GetTransactionsRequested({this.userId});

  @override
  List<Object?> get props => [userId];
}

class CalculateDailyProfitRequested extends TransactionEvent {
  final DateTime date;

  const CalculateDailyProfitRequested(this.date);

  @override
  List<Object> get props => [date];
}