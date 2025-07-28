import 'package:intl/intl.dart';

// Currency Formatting Utility Class
// 
// Provides consistent currency formatting throughout the application.
// Handles currency symbols and decimal places for all supported currencies.

class CurrencyFormatter {

// Formats a numeric amount with the appropriate currency symbol
// 
// [amount] - The numeric value to format
// [currencyCode] - The ISO 4217 currency code ('USD', 'EUR')
// 
// Returns a formatted string with currency symbol and proper decimal places
// Example: format(1234.56, 'USD') returns '$1,234.56'
  static String format(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Maps currency codes to their respective symbols
  /// 
  /// [code] - The ISO 4217 currency code
  /// 
  /// Returns the currency symbol or the code itself if symbol not found
  /// Covers all 30 supported currencies in the application
 static String _getCurrencySymbol(String code) {
    final symbols = {
      'USD': '\$',      // US Dollar
      'EUR': '€',       // Euro
      'TRY': '₺',       // Turkish Lira
      'GBP': '£',       // British Pound
      'JPY': '¥',       // Japanese Yen
      'CHF': 'CHF',     // Swiss Franc
      'CAD': 'C\$',     // Canadian Dollar
      'AUD': 'A\$',     // Australian Dollar
      'CNY': '¥',       // Chinese Yuan
      'HKD': 'HK\$',    // Hong Kong Dollar
      'NZD': 'NZ\$',    // New Zealand Dollar
      'SEK': 'kr',      // Swedish Krona
      'KRW': '₩',       // South Korean Won
      'SGD': 'S\$',     // Singapore Dollar
      'NOK': 'kr',      // Norwegian Krone
      'MXN': 'Mex\$',   // Mexican Peso
      'INR': '₹',       // Indian Rupee
      'RUB': '₽',       // Russian Ruble
      'ZAR': 'R',       // South African Rand
      'BRL': 'R\$',     // Brazilian Real
      'AED': 'د.إ',     // UAE Dirham
      'SAR': 'ر.س',     // Saudi Riyal
      'PLN': 'zł',      // Polish Zloty
      'THB': '฿',       // Thai Baht
      'IDR': 'Rp',      // Indonesian Rupiah
      'HUF': 'Ft',      // Hungarian Forint
      'CZK': 'Kč',      // Czech Koruna
      'ILS': '₪',       // Israeli Shekel
      'CLP': 'CLP\$',   // Chilean Peso
      'PHP': '₱'        // Philippine Peso
    };
    return symbols[code] ?? code;
  }
}