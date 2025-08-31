import 'package:shared_preferences/shared_preferences.dart';

/// 🔐 Centralized Token Storage Service
/// 
/// Handles secure storage and retrieval of authentication tokens.
/// Used across all Flutter applications for consistent token management.
class TokenStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _tokenTypeKey = 'token_type';
  
  static TokenStorageService? _instance;
  static TokenStorageService get instance => _instance ??= TokenStorageService._internal();
  
  TokenStorageService._internal();

  /// Save authentication token to secure storage
  Future<void> saveToken(String token, {String tokenType = 'Bearer'}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_tokenTypeKey, tokenType);
  }

  /// Get authentication token from secure storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get token type from secure storage
  Future<String?> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenTypeKey) ?? 'Bearer';
  }

  /// Get full authorization header value
  Future<String?> getAuthHeader() async {
    final token = await getToken();
    final tokenType = await getTokenType();
    
    if (token == null) return null;
    return '$tokenType $token';
  }

  /// Check if user has a valid token
  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear authentication token from storage
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenTypeKey);
  }

  /// Clear all authentication data
  Future<void> clearAll() async {
    await clearToken();
  }
}