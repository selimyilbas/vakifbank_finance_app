import '../../domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({
    required String code,
    required double rate,
    required DateTime lastUpdated,
  }) : super(
          code: code,
          rate: rate,
          lastUpdated: lastUpdated,
        );

  factory CurrencyModel.fromJson(String code, double rate) {
    return CurrencyModel(
      code: code,
      rate: rate,
      lastUpdated: DateTime.now(),
    );
  }
}