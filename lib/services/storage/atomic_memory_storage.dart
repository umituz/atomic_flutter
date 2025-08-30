import 'atomic_storage_interface.dart';

/// A simple in-memory storage implementation of [AtomicStorageInterface].
///
/// This class provides a basic key-value storage mechanism that stores data
/// in memory. It is useful for temporary data storage or for testing purposes
/// where persistence across application restarts is not required.
///
/// Features:
/// - Stores data as key-value pairs in a [Map<String, String>].
/// - Implements [read], [write], [delete], [clear], [contains], and [getKeys] methods.
/// - Data is not persistent and will be lost when the application restarts.
///
/// Example usage:
/// ```dart
/// final memoryStorage = AtomicMemoryStorage();
///
/// // Write data
/// await memoryStorage.write('username', 'john_doe');
///
/// // Read data
/// final username = await memoryStorage.read('username');
/// print('Username: $username'); // Output: Username: john_doe
///
/// // Check if key exists
/// final hasEmail = await memoryStorage.contains('email');
/// print('Has email: $hasEmail'); // Output: Has email: false
///
/// // Delete data
/// await memoryStorage.delete('username');
///
/// // Get all keys
/// final keys = await memoryStorage.getKeys();
/// print('All keys: $keys'); // Output: All keys: []
/// ```
class AtomicMemoryStorage implements AtomicStorageInterface {
  /// The internal map used for storing key-value pairs.
  final Map<String, String> _storage;

  /// Creates an [AtomicMemoryStorage] instance.
  ///
  /// [initialData] is an optional map to pre-populate the storage.
  AtomicMemoryStorage({Map<String, String>? initialData})
      : _storage = initialData ?? {};

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
    return _storage.remove(key) != null;
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

  /// Returns an unmodifiable map of all data currently in storage.
  Map<String, String> get allData => Map.unmodifiable(_storage);

  /// Returns the number of key-value pairs in storage.
  int get size => _storage.length;
}
