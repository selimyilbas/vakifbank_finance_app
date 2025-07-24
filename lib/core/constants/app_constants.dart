class AppConstants {
  static const String appName = 'Vakıfbank Finance';
  static const double bankProfitMargin = 0.002; // 0.2% profit margin
  
  // Top 30 most traded currencies
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'TRY', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'HKD',
    'NZD', 'SEK', 'KRW', 'SGD', 'NOK', 'MXN', 'INR', 'RUB', 'ZAR', 'BRL',
    'AED', 'SAR', 'PLN', 'THB', 'IDR', 'HUF', 'CZK', 'ILS', 'CLP', 'PHP'
  ];
  
  // User roles
  static const String customerRole = 'customer';
  static const String adminRole = 'admin';
}