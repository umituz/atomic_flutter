/// Atomic Storage Interface
/// Abstract interface for key-value storage implementations
abstract class AtomicStorageInterface {
  /// Read a value from storage
  Future<String?> read(String key);

  /// Write a value to storage
  Future<bool> write(String key, String value);

  /// Delete a value from storage
  Future<bool> delete(String key);

  /// Clear all values from storage
  Future<bool> clear();

  /// Check if a key exists in storage
  Future<bool> contains(String key);

  /// Get all keys from storage
  Future<List<String>> getKeys();
}

/// Extension methods for typed storage operations
extension AtomicStorageTypedExtensions on AtomicStorageInterface {
  /// Read a typed value from storage
  Future<T?> readTyped<T>(String key, T Function(String) decoder) async {
    final value = await read(key);
    if (value == null) return null;
    
    try {
      return decoder(value);
    } catch (e) {
      return null;
    }
  }

  /// Write a typed value to storage
  Future<bool> writeTyped<T>(String key, T value, String Function(T) encoder) async {
    try {
      final encoded = encoder(value);
      return await write(key, encoded);
    } catch (e) {
      return false;
    }
  }
}

/// Memory-based storage implementation for testing
class AtomicMemoryStorage implements AtomicStorageInterface {
  final Map<String, String> _storage = {};

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<bool> write(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> delete(String key) async {
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }

  @override
  Future<bool> contains(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<List<String>> getKeys() async {
    return _storage.keys.toList();
  }
}

/// Example app-specific implementations:
/// 
/// ```dart
/// // SharedPreferences implementation
/// class SharedPrefsStorage implements AtomicStorageInterface {
///   @override
///   Future<String?> read(String key) async {
///     final prefs = await SharedPreferences.getInstance();
///     return prefs.getString(key);
///   }
///   // ... other methods
/// }
/// 
/// // Secure storage implementation
/// class SecureStorage implements AtomicStorageInterface {
///   final storage = FlutterSecureStorage();
///   
///   @override
///   Future<String?> read(String key) async {
///     return await storage.read(key: key);
///   }
///   // ... other methods
/// }
/// ``` 