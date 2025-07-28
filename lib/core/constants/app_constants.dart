// Application-wide Constants 
// This class contains all application-level constants including app configuration,
// supported currencies, user roles, and business logic constants.
// Centralizing these values ensures consistency across the application.


class AppConstants {

  // Application display name
  static const String appName = 'Vakıfbank Finance';

  // Bank profit margin for currency conversions
  // Set to 0.2% (0.002) as per business requirements
  // This margin is applied to all currency conversions as bank revenue
  static const double bankProfitMargin = 0.002; // 0.2% profit margin
  
  
  // List of supported currencies in the application
  // Includes top 30 most traded currencies globally
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'TRY', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'HKD',
    'NZD', 'SEK', 'KRW', 'SGD', 'NOK', 'MXN', 'INR', 'RUB', 'ZAR', 'BRL',
    'AED', 'SAR', 'PLN', 'THB', 'IDR', 'HUF', 'CZK', 'ILS', 'CLP', 'PHP'
  ];
  
   // User role constants for role-based access control

   // Customer role: Regular users who can convert currencies
  static const String customerRole = 'customer';

   // Admin role: Bank administrators who can view all transactions and reports
  static const String adminRole = 'admin';
}