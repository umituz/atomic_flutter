import 'atomic_storage_interface.dart';

class AtomicMemoryStorage implements AtomicStorageInterface {
  AtomicMemoryStorage({Map<String, String>? initialData}) 
    : _storage = initialData ?? {};

  final Map<String, String> _storage;

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

  Map<String, String> get allData => Map.unmodifiable(_storage);

  int get size => _storage.length;
} 