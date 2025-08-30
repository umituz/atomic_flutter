/// An abstract interface for key-value storage operations.
///
/// This interface defines the contract for any storage mechanism used within
/// the Atomic Flutter Kit, ensuring consistent methods for reading, writing,
/// deleting, and managing data.
///
/// Implementations can vary from in-memory storage to persistent storage
/// solutions like shared preferences or secure storage.
///
/// Features:
/// - Asynchronous operations for non-blocking I/O.
/// - Basic CRUD operations: [read], [write], [delete].
/// - Utility methods: [clear], [contains], [getKeys].
/// - Extension methods for typed data handling ([readTyped], [writeTyped]).
///
/// Example usage (assuming a concrete implementation):
/// ```dart
/// class MyStorage implements AtomicStorageInterface {
///   // ... implementation details ...
///   @override
///   Future<String?> read(String key) async { /* ... */ }
///   @override
///   Future<bool> write(String key, String value) async { /* ... */ }
///   // ... other methods ...
/// }
///
/// final storage = MyStorage();
/// await storage.write('myKey', 'myValue');
/// final value = await storage.read('myKey');
/// ```
abstract class AtomicStorageInterface {
  /// Reads a string value associated with the given [key].
  ///
  /// Returns the value as a [String], or null if the key does not exist.
  Future<String?> read(String key);

  /// Writes a [value] string associated with the given [key].
  ///
  /// Returns true if the write operation was successful, false otherwise.
  Future<bool> write(String key, String value);

  /// Deletes the value associated with the given [key].
  ///
  /// Returns true if the key was found and deleted, false otherwise.
  Future<bool> delete(String key);

  /// Clears all key-value pairs from the storage.
  ///
  /// Returns true if the clear operation was successful, false otherwise.
  Future<bool> clear();

  /// Checks if the storage contains a value for the given [key].
  ///
  /// Returns true if the key exists, false otherwise.
  Future<bool> contains(String key);

  /// Retrieves a list of all keys currently in storage.
  Future<List<String>> getKeys();
}

/// Extension methods on [AtomicStorageInterface] for handling typed data.
///
/// These extensions provide convenience methods to store and retrieve data
/// that needs to be encoded to and decoded from a string format (e.g., JSON).
extension AtomicStorageTypedExtensions on AtomicStorageInterface {
  /// Reads a typed value associated with the given [key].
  ///
  /// [decoder] is a function that converts the stored string into type [T].
  /// Returns the parsed value of type [T], or null if the key does not exist
  /// or decoding fails.
  Future<T?> readTyped<T>(String key, T Function(String) decoder) async {
    final value = await read(key);
    if (value == null) return null;

    try {
      return decoder(value);
    } catch (e) {
      // Log error if decoding fails
      return null;
    }
  }

  /// Writes a typed [value] associated with the given [key].
  ///
  /// [encoder] is a function that converts the value of type [T] into a string for storage.
  /// Returns true if the write operation was successful, false otherwise.
  Future<bool> writeTyped<T>(
      String key, T value, String Function(T) encoder) async {
    try {
      final encoded = encoder(value);
      return await write(key, encoded);
    } catch (e) {
      // Log error if encoding fails
      return false;
    }
  }
}
