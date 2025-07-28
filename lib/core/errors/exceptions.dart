// Exception Classes 
// These exceptions are used throughout the data layer to handle specific error cases.
// Each exception type represents a different category of error that can occur.



// Exception thrown when server-related errors occur
// Examples: API failures, Firestore errors, network timeouts
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

// Exception thrown when local cache operations fail
// Examples: SharedPreferences errors, local storage issues
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

// Exception thrown for authentication-related errors
// Examples: Invalid credentials, expired sessions, unauthorized access
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

// Exception thrown for network connectivity issues
// Examples: No internet connection, DNS failures, connection timeouts
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}