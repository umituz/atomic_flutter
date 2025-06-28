import 'dart:convert';
import 'atomic_storage_interface.dart';

/// Atomic Secure Storage Example
/// Example implementation of secure storage for sensitive data like tokens
/// 
/// Note: This is just an example. For production use, implement with:
/// - flutter_secure_storage for secure key-value storage
/// - encrypted_shared_preferences for encrypted preferences
/// - hive with encryption for complex data
abstract class AtomicSecureStorageExample implements AtomicStorageInterface {
  /// Store authentication token
  Future<bool> storeAuthToken(String token) async {
    return await writeTyped<Map<String, dynamic>>(
      'auth_token',
      {
        'token': token,
        'timestamp': DateTime.now().toIso8601String(),
      },
      (data) => jsonEncode(data),
    );
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    final data = await readTyped<Map<String, dynamic>>(
      'auth_token',
      (str) => jsonDecode(str) as Map<String, dynamic>,
    );
    return data?['token'] as String?;
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    final data = await readTyped<Map<String, dynamic>>(
      'auth_token',
      (str) => jsonDecode(str) as Map<String, dynamic>,
    );
    
    if (data == null || data['timestamp'] == null) return true;
    
    final timestamp = DateTime.parse(data['timestamp'] as String);
    final expiryDuration = const Duration(hours: 24); // Example: 24 hour expiry
    
    return DateTime.now().isAfter(timestamp.add(expiryDuration));
  }

  /// Store user credentials (encrypted)
  Future<bool> storeCredentials({
    required String username,
    required String password,
  }) async {
    // In production, encrypt the password before storing
    return await writeTyped<Map<String, String>>(
      'user_credentials',
      {
        'username': username,
        'password': password, // Should be encrypted!
      },
      (data) => jsonEncode(data),
    );
  }

  /// Clear all secure data
  Future<bool> clearSecureData() async {
    final keys = await getKeys();
    final secureKeys = keys.where((key) => 
      key.startsWith('auth_') || 
      key.startsWith('user_') ||
      key.contains('token') ||
      key.contains('credential')
    );
    
    for (final key in secureKeys) {
      await delete(key);
    }
    
    return true;
  }
}

/// Example token model for reference
class AtomicTokenModel {
  const AtomicTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token needs refresh (5 minutes before expiry)
  bool get needsRefresh => DateTime.now().isAfter(
    expiresAt.subtract(const Duration(minutes: 5))
  );

  /// Create from JSON
  factory AtomicTokenModel.fromJson(Map<String, dynamic> json) {
    return AtomicTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }
}

/// Token storage mixin for services
mixin AtomicTokenStorageMixin {
  AtomicStorageInterface get storage;

  /// Store token
  Future<bool> storeToken(AtomicTokenModel token) async {
    return await storage.writeTyped<AtomicTokenModel>(
      'app_token',
      token,
      (t) => jsonEncode(t.toJson()),
    );
  }

  /// Get token
  Future<AtomicTokenModel?> getToken() async {
    return await storage.readTyped<AtomicTokenModel>(
      'app_token',
      (str) => AtomicTokenModel.fromJson(
        jsonDecode(str) as Map<String, dynamic>,
      ),
    );
  }

  /// Clear token
  Future<bool> clearToken() async {
    return await storage.delete('app_token');
  }

  /// Get valid token (refresh if needed)
  Future<AtomicTokenModel?> getValidToken({
    Future<AtomicTokenModel?> Function(String refreshToken)? onRefresh,
  }) async {
    final token = await getToken();
    if (token == null) return null;
    
    if (!token.isExpired) return token;
    
    // Try to refresh if refresh token is available
    if (token.refreshToken != null && onRefresh != null) {
      final newToken = await onRefresh(token.refreshToken!);
      if (newToken != null) {
        await storeToken(newToken);
        return newToken;
      }
    }
    
    // Token is expired and can't be refreshed
    await clearToken();
    return null;
  }
} 