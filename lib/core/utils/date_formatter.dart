import 'package:intl/intl.dart';

// Date and Time Formatting Utility Class
 
// Provides consistent date/time formatting throughout the application.
// Uses Turkish date format (dd/MM/yyyy) 

class DateFormatter {

// Formats a DateTime object to a full date and time string
   
// [dateTime] - The DateTime object to format
 
// Returns formatted string in 'dd/MM/yyyy HH:mm' format
// Example: 24/07/2025 14:30
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  
// Formats a DateTime object to a date-only string
// 
// [date] - The DateTime object to format
// 
// Returns formatted string in 'dd/MM/yyyy' format
// Example: 24/07/2025

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
// Formats a DateTime object to a time-only string
// 
// [time] - The DateTime object to format
// 
// Returns formatted string in 'HH:mm:ss' format
// Example: 14:30:45
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }
}