import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String code;
  final double rate;
  final DateTime lastUpdated;

  const Currency({
    required this.code,
    required this.rate,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [code, rate, lastUpdated];
}