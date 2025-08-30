import 'dart:convert';
import 'atomic_storage_interface.dart';

/// An abstract class demonstrating common secure storage operations for authentication.
///
/// This class extends [AtomicStorageInterface] and provides example methods
/// for storing and retrieving authentication tokens and user credentials.
/// It highlights typical patterns for handling sensitive data, including
/// token expiration checks.
///
/// **Important**: This is an example. In a real application, sensitive data
/// like passwords should *never* be stored directly. Always use strong
/// encryption and secure practices.
///
/// Features:
/// - Methods for storing and retrieving authentication tokens with expiration.
/// - Example method for storing user credentials (for demonstration only).
/// - Method for clearing secure data based on key patterns.
/// - Leverages `jsonEncode` and `jsonDecode` for structured data.
///
/// Example usage (assuming a concrete implementation of [AtomicStorageInterface]):
/// ```dart
/// class MySecureStorage extends AtomicSecureStorageExample {
///   final AtomicStorageInterface _actualStorage;
///
///   MySecureStorage(this._actualStorage);
///
///   @override
///   Future<bool> clear() => _actualStorage.clear();
///
///   @override
///   Future<bool> contains(String key) => _actualStorage.contains(key);
///
///   @override
///   Future<bool> delete(String key) => _actualStorage.delete(key);
///
///   @override
///   Future<List<String>> getKeys() => _actualStorage.getKeys();
///
///   @override
///   Future<String?> read(String key) => _actualStorage.read(key);
///
///   @override
///   Future<bool> write(String key, String value) => _actualStorage.write(key, value);
/// }
///
/// final secureStorage = MySecureStorage(AtomicMemoryStorage()); // Using memory storage for example
///
/// // Store an auth token
/// await secureStorage.storeAuthToken('some_jwt_token');
///
/// // Get auth token
/// final token = await secureStorage.getAuthToken();
/// print('Retrieved token: $token');
///
/// // Check if token is expired
/// final expired = await secureStorage.isTokenExpired();
/// print('Token expired: $expired');
/// ```
abstract class AtomicSecureStorageExample implements AtomicStorageInterface {
  /// Stores an authentication token along with a timestamp.
  ///
  /// [token] is the authentication token string.
  /// Returns true if the operation was successful.
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

  /// Retrieves the authentication token.
  ///
  /// Returns the token string, or null if not found or cannot be parsed.
  Future<String?> getAuthToken() async {
    final data = await readTyped<Map<String, dynamic>>(
      'auth_token',
      (str) => jsonDecode(str) as Map<String, dynamic>,
    );
    return data?['token'] as String?;
  }

  /// Checks if the stored authentication token is expired.
  ///
  /// This example assumes a 24-hour expiry based on the stored timestamp.
  /// Returns true if the token is expired or not found, false otherwise.
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

  /// Stores user credentials (username and password).
  ///
  /// **Warning**: Storing passwords directly is insecure. This method is for
  /// demonstration purposes only. In a real application, passwords should be
  /// handled securely (e.g., by not storing them, or by using strong encryption).
  ///
  /// [username] is the user's username.
  /// [password] is the user's password.
  /// Returns true if the operation was successful.
  Future<bool> storeCredentials({
    required String username,
    required String password,
  }) async {
    return await writeTyped<Map<String, String>>(
      'user_credentials',
      {
        'username': username,
        'password': password, // Should be encrypted!
      },
      (data) => jsonEncode(data),
    );
  }

  /// Clears secure data based on common key patterns.
  ///
  /// This method iterates through all stored keys and deletes those that
  /// match patterns typically associated with authentication or user credentials.
  /// Returns true if the operation was successful.
  Future<bool> clearSecureData() async {
    final keys = await getKeys();
    final secureKeys = keys.where((key) =>
        key.startsWith('auth_') ||
        key.startsWith('user_') ||
        key.contains('token') ||
        key.contains('credential'));

    for (final key in secureKeys) {
      await delete(key);
    }

    return true;
  }
}

/// A model representing an authentication token.
class AtomicTokenModel {
  /// The access token string.
  final String accessToken;

  /// The refresh token string.
  final String? refreshToken;

  /// The expiration timestamp of the access token.
  final DateTime expiresAt;

  /// The type of token (e.g., 'Bearer'). Defaults to 'Bearer'.
  final String tokenType;

  /// Creates an [AtomicTokenModel].
  ///
  /// [accessToken] is the main token.
  /// [refreshToken] is used to obtain new access tokens.
  /// [expiresAt] is the token's expiration time.
  /// [tokenType] is the type of token.
  const AtomicTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  /// True if the access token has expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// True if the access token is nearing expiration and needs to be refreshed.
  ///
  /// This checks if the current time is after 5 minutes before the expiration time.
  bool get needsRefresh =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));

  /// Creates an [AtomicTokenModel] from a JSON map.
  factory AtomicTokenModel.fromJson(Map<String, dynamic> json) {
    return AtomicTokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }

  /// Converts this [AtomicTokenModel] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }
}

/// A mixin providing common methods for storing and managing [AtomicTokenModel]s.
///
/// This mixin requires an [AtomicStorageInterface] implementation to function.
/// It simplifies token persistence, retrieval, and validation, including
/// automatic token refresh logic.
///
/// Example usage:
/// ```dart
/// class AuthRepository with AtomicTokenStorageMixin {
///   @override
///   final AtomicStorageInterface storage;
///
///   AuthRepository(this.storage);
///
///   Future<AtomicTokenModel?> login(String username, String password) async {
///     // Simulate login API call
///     await Future.delayed(Duration(seconds: 1));
///     final token = AtomicTokenModel(
///       accessToken: 'new_access_token',
///       refreshToken: 'new_refresh_token',
///       expiresAt: DateTime.now().add(Duration(hours: 1)),
///     );
///     await storeToken(token);
///     return token;
///   }
///
///   Future<AtomicTokenModel?> _refreshApiToken(String refreshToken) async {
///     // Simulate refresh token API call
///     await Future.delayed(Duration(seconds: 1));
///     return AtomicTokenModel(
///       accessToken: 'refreshed_access_token',
///       refreshToken: 'new_refreshed_token',
///       expiresAt: DateTime.now().add(Duration(hours: 1)),
///     );
///   }
///
///   Future<String?> getAccessToken() async {
///     final token = await getValidToken(onRefresh: _refreshApiToken);
///     return token?.accessToken;
///   }
/// }
/// ```
mixin AtomicTokenStorageMixin {
  /// The storage interface used for token persistence.
  AtomicStorageInterface get storage;

  /// Stores an [AtomicTokenModel] in the storage.
  Future<bool> storeToken(AtomicTokenModel token) async {
    return await storage.writeTyped<AtomicTokenModel>(
      'app_token',
      token,
      (t) => jsonEncode(t.toJson()),
    );
  }

  /// Retrieves an [AtomicTokenModel] from the storage.
  Future<AtomicTokenModel?> getToken() async {
    return await storage.readTyped<AtomicTokenModel>(
      'app_token',
      (str) => AtomicTokenModel.fromJson(
        jsonDecode(str) as Map<String, dynamic>,
      ),
    );
  }

  /// Clears the stored token from the storage.
  Future<bool> clearToken() async {
    return await storage.delete('app_token');
  }

  /// Retrieves a valid access token, refreshing it if necessary.
  ///
  /// [onRefresh] is an optional callback function to refresh the token if it's expired.
  /// Returns the valid [AtomicTokenModel] or null if no valid token can be obtained.
  Future<AtomicTokenModel?> getValidToken({
    Future<AtomicTokenModel?> Function(String refreshToken)? onRefresh,
  }) async {
    final token = await getToken();
    if (token == null) return null;

    if (!token.isExpired) return token;

    if (token.refreshToken != null && onRefresh != null) {
      final newToken = await onRefresh(token.refreshToken!);
      if (newToken != null) {
        await storeToken(newToken);
        return newToken;
      }
    }

    await clearToken();
    return null;
  }
}
