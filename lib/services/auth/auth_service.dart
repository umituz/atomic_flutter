import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../config/api_config.dart';
import '../../models/auth/auth_result.dart';
import 'token_storage_service.dart';

/// 🔐 Centralized Authentication Service
/// 
/// Handles all authentication operations with the backend API.
/// Used across all Flutter applications for consistent auth integration.
class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._internal();
  
  AuthService._internal();

  final _tokenStorage = TokenStorageService.instance;
  late final String _baseUrl;

  /// Initialize service with API base URL
  void initialize(String baseUrl) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
  }

  /// User Login
  Future<AuthResult> login(String email, String password) async {
    try {
      debugPrint('🔐 AuthService.login: Starting login for $email');
      
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiConfig.loginEndpoint}'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('🔐 AuthService.login: Response status: ${response.statusCode}');
      debugPrint('🔐 AuthService.login: Response body: ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final result = AuthResult.fromJson(data);
      
      debugPrint('🔐 AuthService.login: AuthResult isSuccess: ${result.isSuccess}');
      debugPrint('🔐 AuthService.login: AuthResult token: ${result.token != null ? "[token present]" : "[no token]"}');
      debugPrint('🔐 AuthService.login: AuthResult user: ${result.user != null ? "[user present]" : "[no user]"}');
      debugPrint('🔐 AuthService.login: AuthResult message: ${result.message}');

      if (result.isSuccess && result.token != null) {
        debugPrint('🔐 AuthService.login: Saving token to storage');
        await _tokenStorage.saveToken(result.token!);
        debugPrint('🔐 AuthService.login: Token saved successfully');
      }

      return result;
    } catch (e) {
      debugPrint('🔐 AuthService.login: Error occurred: $e');
      return AuthResult.error(message: 'Network error occurred');
    }
  }

  /// User Registration
  Future<AuthResult> register({
    required String email,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${ApiConfig.registerEndpoint}'),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'name': name,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final result = AuthResult.fromJson(data);

      if (result.isSuccess && result.token != null) {
        await _tokenStorage.saveToken(result.token!);
      }

      return result;
    } catch (e) {
      return AuthResult.error(message: 'Network error occurred');
    }
  }

  /// User Logout
  Future<AuthResult> logout() async {
    try {
      final authHeader = await _tokenStorage.getAuthHeader();
      
      if (authHeader != null) {
        await http.post(
          Uri.parse('$_baseUrl${ApiConfig.logoutEndpoint}'),
          headers: {
            ...ApiConfig.defaultHeaders,
            'Authorization': authHeader,
          },
        );
      }

      await _tokenStorage.clearAll();
      return AuthResult.success(message: 'Logged out successfully');
    } catch (e) {
      await _tokenStorage.clearAll();
      return AuthResult.success(message: 'Logged out successfully');
    }
  }

  /// Get Current User
  Future<AuthResult> getCurrentUser() async {
    try {
      final authHeader = await _tokenStorage.getAuthHeader();
      
      if (authHeader == null) {
        return AuthResult.error(message: 'No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl${ApiConfig.userProfileEndpoint}'),
        headers: {
          ...ApiConfig.defaultHeaders,
          'Authorization': authHeader,
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResult.fromJson(data);
    } catch (e) {
      return AuthResult.error(message: 'Failed to get user data');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.hasValidToken();
  }

  /// Get stored authentication header
  Future<String?> getAuthHeader() async {
    return await _tokenStorage.getAuthHeader();
  }
}