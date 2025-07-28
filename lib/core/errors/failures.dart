import 'package:equatable/equatable.dart';

// Base Failure class for the Domain layer
// Following Clean Architecture principles, Failures are used in the domain layer
// to represent errors in a way that's independent of the data layer.
// All specific failure types extend this base class.


abstract class Failure extends Equatable {
// Error message describing what went wrong
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}
// Failure representing server-side errors
// Maps from ServerException in the data layer
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}
// Failure representing local cache errors
// Maps from CacheException in the data layer
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}
// Failure representing authentication errors
// Maps from AuthException in the data layer
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
// Failure representing network connectivity issues
// Maps from NetworkException in the data layer
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}