import '../../domain/entities/currency.dart';

class CurrencyModel extends Currency {

/// Currency Model
/// 
/// Data layer representation of Currency that handles conversion
/// from API responses to domain entities.
/// 
/// Unlike UserModel, this doesn't need toJson as we don't store
/// currencies in our database - we fetch them from external APIs.
  const CurrencyModel({
    /// Creates a CurrencyModel instance
    required String code,
    required double rate,
    required DateTime lastUpdated,
  }) : super(
          code: code,
          rate: rate,
          lastUpdated: lastUpdated,
        );
        
  /// Factory constructor to create CurrencyModel from API response
  /// 
  /// [code] - Currency code from the API response key
  /// [rate] - Exchange rate value from the API response
  /// 
  /// Sets lastUpdated to current time as most free APIs
  /// don't provide timestamp information
  factory CurrencyModel.fromJson(String code, double rate) {
    return CurrencyModel(
      code: code,
      rate: rate,
      lastUpdated: DateTime.now(),
    );
  }
}