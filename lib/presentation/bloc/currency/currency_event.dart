import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class GetExchangeRatesRequested extends CurrencyEvent {
  final String baseCurrency;

  const GetExchangeRatesRequested(this.baseCurrency);

  @override
  List<Object> get props => [baseCurrency];
}

class ConvertCurrencyRequested extends CurrencyEvent {
  final String from;
  final String to;
  final double amount;

  const ConvertCurrencyRequested({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object> get props => [from, to, amount];
}