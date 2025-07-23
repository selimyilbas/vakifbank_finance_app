import 'package:equatable/equatable.dart';
import '../../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionCreated extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class DailyProfitCalculated extends TransactionState {
  final double profit;
  final DateTime date;

  const DailyProfitCalculated({
    required this.profit,
    required this.date,
  });

  @override
  List<Object> get props => [profit, date];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}