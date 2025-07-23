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
    switch (code) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return code;
    }
  }
}