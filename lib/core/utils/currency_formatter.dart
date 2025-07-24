import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String _getCurrencySymbol(String code) {
    final symbols = {
      'USD': '\$', 'EUR': '€', 'TRY': '₺', 'GBP': '£', 'JPY': '¥',
      'CHF': 'CHF', 'CAD': 'C\$', 'AUD': 'A\$', 'CNY': '¥', 'HKD': 'HK\$',
      'NZD': 'NZ\$', 'SEK': 'kr', 'KRW': '₩', 'SGD': 'S\$', 'NOK': 'kr',
      'MXN': 'Mex\$', 'INR': '₹', 'RUB': '₽', 'ZAR': 'R', 'BRL': 'R\$',
      'AED': 'د.إ', 'SAR': 'ر.س', 'PLN': 'zł', 'THB': '฿', 'IDR': 'Rp',
      'HUF': 'Ft', 'CZK': 'Kč', 'ILS': '₪', 'CLP': 'CLP\$', 'PHP': '₱'
    };
    return symbols[code] ?? code;
  }
}