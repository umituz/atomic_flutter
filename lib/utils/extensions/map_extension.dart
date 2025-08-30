extension AtomicMapExtension on Map<dynamic, dynamic> {
  T? getOrDefault<T>(
    dynamic key, {
    T? defaultValue,
  }) {
    if (containsKey(key) && this[key] != null) {
      return this[key] as T;
    }
    return defaultValue;
  }

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

  String? getString(dynamic key, {String? defaultValue}) {
    return getOrDefault<String>(key, defaultValue: defaultValue);
  }

  int? getInt(dynamic key, {int? defaultValue}) {
    final value = this[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  double? getDouble(dynamic key, {double? defaultValue}) {
    final value = this[key];
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? defaultValue;
    if (value is int) return value.toDouble();
    return defaultValue;
  }

  bool? getBool(dynamic key, {bool? defaultValue}) {
    final value = this[key];
    if (value is bool) return value;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    if (value is int) return value != 0;
    return defaultValue;
  }

  List<T>? getList<T>(dynamic key, {List<T>? defaultValue}) {
    final value = this[key];
    if (value is List) {
      return value.cast<T>();
    }
    return defaultValue;
  }

  Map<K, V>? getMap<K, V>(dynamic key, {Map<K, V>? defaultValue}) {
    final value = this[key];
    if (value is Map) {
      return value.cast<K, V>();
    }
    return defaultValue;
  }

  Map<K, V> where<K, V>(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (key is K && value is V && test(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }

  Map<K, R> mapValues<K, V, R>(R Function(V value) transform) {
    final result = <K, R>{};
    forEach((key, value) {
      if (key is K && value is V) {
        result[key] = transform(value);
      }
    });
    return result;
  }

  void removeKeys(List<dynamic> keys) {
    for (final key in keys) {
      remove(key);
    }
  }

  Map<K, V> pick<K, V>(List<K> keys) {
    final result = <K, V>{};
    for (final key in keys) {
      if (containsKey(key)) {
        result[key] = this[key] as V;
      }
    }
    return result;
  }

  Map<K, V> omit<K, V>(List<K> keys) {
    final result = Map<K, V>.from(this as Map<K, V>);
    for (final key in keys) {
      result.remove(key);
    }
    return result;
  }

  bool hasKeys(List<dynamic> keys) {
    return keys.every((key) => containsKey(key));
  }

  bool hasAnyKey(List<dynamic> keys) {
    return keys.any((key) => containsKey(key));
  }
}

extension AtomicTypedMapExtension<K, V> on Map<K, V> {
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
