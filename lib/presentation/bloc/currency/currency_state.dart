import 'package:equatable/equatable.dart';
import '../../../domain/entities/currency.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyRatesLoaded extends CurrencyState {
  final List<Currency> currencies;
  final String baseCurrency;

  const CurrencyRatesLoaded({
    required this.currencies,
    required this.baseCurrency,
  });

  @override
  List<Object> get props => [currencies, baseCurrency];
}

class CurrencyConverted extends CurrencyState {
  final double result;
  final String from;
  final String to;
  final double amount;

  const CurrencyConverted({
    required this.result,
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object> get props => [result, from, to, amount];
}

class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError(this.message);

  @override
  List<Object> get props => [message];
}