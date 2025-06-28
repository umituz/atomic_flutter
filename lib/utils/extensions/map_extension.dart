/// Map Extension for Atomic Flutter
/// Provides additional functionality for Map operations

extension AtomicMapExtension on Map<dynamic, dynamic> {
  /// Safely gets a value from the map with optional transformation and default value
  /// 
  /// Parameters:
  /// - [key]: The key to look up in the map
  /// - [transform]: Optional function to transform the value
  /// - [defaultValue]: Default value to use if key doesn't exist or value is null
  /// 
  /// Example:
  /// ```dart
  /// final map = {'name': 'John', 'age': 25};
  /// final name = map.getOrDefault('name', defaultValue: 'Unknown');
  /// final age = map.getWithTransform('age', transform: (v) => '$v years old');
  /// ```
  T? getOrDefault<T>(
    dynamic key, {
    T? defaultValue,
  }) {
    if (containsKey(key) && this[key] != null) {
      return this[key] as T;
    }
    return defaultValue;
  }

  /// Gets a value with transformation
  R? getWithTransform<T, R>(
    dynamic key, {
    R Function(T value)? transform,
    T? defaultValue,
  }) {
    final value = getOrDefault<T>(key, defaultValue: defaultValue);
    if (value != null && transform != null) {
      return transform(value);
    }
    return value as R?;
  }

  /// Legacy method for backward compatibility
  /// Use getWithTransform instead for new code
  dynamic containsCheck(
    String key, [
    Function(dynamic item)? callback,
    dynamic defaultValue,
  ]) {
    if (containsKey(key)) {
      final value = this[key];
      
      if (value == null && defaultValue != null) {
        return callback?.call(defaultValue) ?? defaultValue;
      }
      
      if (value == null) {
        return null;
      }
      
      if (callback == null) {
        return value;
      }
      
      return callback(value);
    } else if (defaultValue != null) {
      return callback?.call(defaultValue) ?? defaultValue;
    }
    
    return null;
  }

  /// Safely gets a String value from the map
  String? getString(dynamic key, {String? defaultValue}) {
    return getOrDefault<String>(key, defaultValue: defaultValue);
  }

  /// Safely gets an int value from the map
  int? getInt(dynamic key, {int? defaultValue}) {
    final value = this[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Safely gets a double value from the map
  double? getDouble(dynamic key, {double? defaultValue}) {
    final value = this[key];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Safely gets a bool value from the map
  bool getBool(dynamic key, {bool defaultValue = false}) {
    final value = this[key];
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final lowered = value.toLowerCase();
      return ['true', '1', 'yes', 'on'].contains(lowered);
    }
    return defaultValue;
  }

  /// Safely gets a List from the map
  List<T>? getList<T>(dynamic key, {List<T>? defaultValue}) {
    final value = this[key];
    if (value is List) {
      return value.cast<T>();
    }
    return defaultValue;
  }

  /// Safely gets a Map from the map
  Map<K, V>? getMap<K, V>(dynamic key, {Map<K, V>? defaultValue}) {
    final value = this[key];
    if (value is Map) {
      return value.cast<K, V>();
    }
    return defaultValue;
  }

  /// Removes multiple keys from the map
  void removeKeys(List<dynamic> keys) {
    for (final key in keys) {
      remove(key);
    }
  }

  /// Creates a new map with only the specified keys
  Map<K, V> pick<K, V>(List<K> keys) {
    final result = <K, V>{};
    for (final key in keys) {
      if (containsKey(key)) {
        result[key] = this[key] as V;
      }
    }
    return result;
  }

  /// Creates a new map excluding the specified keys
  Map<K, V> omit<K, V>(List<K> keys) {
    final result = Map<K, V>.from(this as Map<K, V>);
    for (final key in keys) {
      result.remove(key);
    }
    return result;
  }

  /// Checks if the map has all the specified keys
  bool hasKeys(List<dynamic> keys) {
    return keys.every((key) => containsKey(key));
  }

  /// Checks if the map has any of the specified keys
  bool hasAnyKey(List<dynamic> keys) {
    return keys.any((key) => containsKey(key));
  }
}

/// Extension for typed maps
extension AtomicTypedMapExtension<K, V> on Map<K, V> {
  /// Merges another map into this one, with optional value transformer
  Map<K, V> merge(
    Map<K, V> other, {
    V Function(V existing, V incoming)? resolver,
  }) {
    final result = Map<K, V>.from(this);
    
    other.forEach((key, value) {
      if (result.containsKey(key) && resolver != null) {
        result[key] = resolver(result[key] as V, value);
      } else {
        result[key] = value;
      }
    });
    
    return result;
  }
} 