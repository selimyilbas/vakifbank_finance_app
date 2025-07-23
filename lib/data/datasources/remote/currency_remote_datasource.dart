import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/currency_model.dart';

abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyModel>> getExchangeRates(String baseCurrency);
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;

  CurrencyRemoteDataSourceImpl(this.client);

  @override
  Future<List<CurrencyModel>> getExchangeRates(String baseCurrency) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.currencyApiBaseUrl}/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        return rates.entries
            .map((entry) => CurrencyModel.fromJson(entry.key, entry.value.toDouble()))
            .toList();
      } else {
        // Try alternative API
        final altResponse = await client.get(
          Uri.parse('${ApiConstants.alternativeApiUrl}?from=$baseCurrency'),
        );

        if (altResponse.statusCode == 200) {
          final data = json.decode(altResponse.body);
          final rates = data['rates'] as Map<String, dynamic>;
          
          return rates.entries
              .map((entry) => CurrencyModel.fromJson(entry.key, entry.value.toDouble()))
              .toList();
        } else {
          throw ServerException('Failed to fetch exchange rates');
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
}