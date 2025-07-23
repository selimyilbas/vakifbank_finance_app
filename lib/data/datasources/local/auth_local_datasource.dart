import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String userKey = 'CACHED_USER';

  AuthLocalDataSourceImpl(this.sharedPreferences);

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
      final jsonString = json.encode(userMap);
      await sharedPreferences.setString(userKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(userKey);
      if (jsonString == null) {
        return null;
      }
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      // Convert ISO string back to DateTime
      return UserModel(
        id: jsonMap['id'],
        email: jsonMap['email'],
        name: jsonMap['name'],
        role: jsonMap['role'],
        createdAt: DateTime.parse(jsonMap['createdAt']),
      );
    } catch (e) {
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(userKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}