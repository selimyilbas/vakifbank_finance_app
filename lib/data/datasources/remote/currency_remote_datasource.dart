import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/currency_model.dart';

/// Currency Remote Data Source Interface
/// 
/// Defines the contract for fetching currency data from external APIs
abstract class CurrencyRemoteDataSource {
  /// Fetches exchange rates from external API
  Future<List<CurrencyModel>> getExchangeRates(String baseCurrency);
}

/// Currency Remote Data Source Implementation
/// 
/// Handles API calls to external currency exchange services.
/// Implements fallback mechanism for API reliability.
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  /// HTTP client for making API requests
  final http.Client client;

  /// Creates new CurrencyRemoteDataSourceImpl instance
  CurrencyRemoteDataSourceImpl(this.client);

  /// Fetches current exchange rates for given base currency
  /// 
  /// [baseCurrency] - Base currency for rate calculations
  /// 
  /// Implements fallback strategy:
  /// 1. Try primary API (exchangerate-api.com)
  /// 2. If fails, try alternative API (frankfurter.app)
  /// 
  /// Throws:
  /// - ServerException: For API failures
  /// - NetworkException: For network connectivity issues
  @override
  Future<List<CurrencyModel>> getExchangeRates(String baseCurrency) async {
    try {
      // Attempt primary API
      final response = await client.get(
        Uri.parse('${ApiConstants.currencyApiBaseUrl}/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        // Parse successful response
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        // Convert rate entries to CurrencyModel list
        return rates.entries
            .map((entry) => CurrencyModel.fromJson(
                  entry.key, 
                  entry.value.toDouble()
                ))
            .toList();
      } else {
        // Primary API failed, try alternative
        final altResponse = await client.get(
          Uri.parse('${ApiConstants.alternativeApiUrl}?from=$baseCurrency'),
        );

        if (altResponse.statusCode == 200) {
          // Parse alternative API response
          final data = json.decode(altResponse.body);
          final rates = data['rates'] as Map<String, dynamic>;
          
          // Convert to CurrencyModel list
          return rates.entries
              .map((entry) => CurrencyModel.fromJson(
                    entry.key, 
                    entry.value.toDouble()
                  ))
              .toList();
        } else {
          // Both APIs failed
          throw ServerException('Failed to fetch exchange rates');
        }
      }
    } catch (e) {
      // Distinguish between server and network errors
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
}