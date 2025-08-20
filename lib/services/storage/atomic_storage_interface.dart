abstract class AtomicStorageInterface {
  Future<String?> read(String key);

  Future<bool> write(String key, String value);

  Future<bool> delete(String key);

  Future<bool> clear();

  Future<bool> contains(String key);

  Future<List<String>> getKeys();
}

extension AtomicStorageTypedExtensions on AtomicStorageInterface {
  Future<T?> readTyped<T>(String key, T Function(String) decoder) async {
    final value = await read(key);
    if (value == null) return null;
    
    try {
      return decoder(value);
    } catch (e) {
      return null;
    }
  }

  Future<bool> writeTyped<T>(String key, T value, String Function(T) encoder) async {
    try {
      final encoded = encoder(value);
      return await write(key, encoded);
    } catch (e) {
      return false;
    }
  }
}

