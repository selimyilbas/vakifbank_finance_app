import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

/// Authentication Local Data Source Interface
/// 
/// Defines the contract for local user data caching
abstract class AuthLocalDataSource {
  /// Caches user data locally
  Future<void> cacheUser(UserModel user);
  
  /// Retrieves cached user data
  Future<UserModel?> getCachedUser();
  
  /// Clears cached user data
  Future<void> clearCache();
}

/// Authentication Local Data Source Implementation
/// 
/// Manages local caching of user data using SharedPreferences.
/// Used for maintaining user session and offline capabilities.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// SharedPreferences instance for local storage
  final SharedPreferences sharedPreferences;
  
  /// Key used to store user data in SharedPreferences
  static const String userKey = 'CACHED_USER';

  /// Creates new AuthLocalDataSourceImpl instance
  AuthLocalDataSourceImpl(this.sharedPreferences);

  /// Caches user data in local storage
  /// 
  /// [user] - UserModel to cache
  /// 
  /// Converts UserModel to JSON string for storage
  /// DateTime is converted to ISO string for JSON compatibility
  /// 
  /// Throws:
  /// - CacheException: For storage failures
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      // Convert DateTime to ISO string for JSON encoding
      final userMap = {
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'role': user.role,
        'createdAt': user.createdAt.toIso8601String(),
      };
      
      // Encode to JSON string
      final jsonString = json.encode(userMap);
      
      // Save to SharedPreferences
      await sharedPreferences.setString(userKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  /// Retrieves cached user data from local storage
  /// 
  /// Returns null if no cached user exists
  /// 
  /// Throws:
  /// - CacheException: For retrieval failures
  @override
  Future<UserModel?> getCachedUser() async {
    try {
      // Get JSON string from SharedPreferences
      final jsonString = sharedPreferences.getString(userKey);
      if (jsonString == null) {
        return null;
      }
      
      // Decode JSON string
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      
      // Convert ISO string back to DateTime
      return UserModel(
        id: jsonMap['id'] as String,
        email: jsonMap['email'] as String,
        name: jsonMap['name'] as String,
        role: jsonMap['role'] as String,
        createdAt: DateTime.parse(jsonMap['createdAt'] as String),
      );
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  /// Clears cached user data
  /// 
  /// Called during logout to ensure clean session state
  /// 
  /// Throws:
  /// - CacheException: For deletion failures
  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(userKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}