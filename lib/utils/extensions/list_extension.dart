extension AtomicListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  T? lastWhereOrNull(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }

  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  List<List<T>> chunk(int size) {
    if (size <= 0) throw ArgumentError('Chunk size must be positive');

    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  List<T> unique() {
    final seen = <T>{};
    return where((element) => seen.add(element)).toList();
  }

  Map<K, List<T>> groupBy<K>(K Function(T element) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  (List<T>, List<T>) partition(bool Function(T element) predicate) {
    final matches = <T>[];
    final nonMatches = <T>[];

    for (final element in this) {
      if (predicate(element)) {
        matches.add(element);
      } else {
        nonMatches.add(element);
      }
    }

    return (matches, nonMatches);
  }

  List<T> intersperse(T separator) {
    if (isEmpty) return [];

    final result = <T>[];
    for (var i = 0; i < length; i++) {
      if (i > 0) result.add(separator);
      result.add(this[i]);
    }
    return result;
  }

  List<T> rotate(int n) {
    if (isEmpty) return [];

    final normalizedN = n % length;
    if (normalizedN == 0) return List.from(this);

    return [...sublist(normalizedN), ...sublist(0, normalizedN)];
  }
}

extension AtomicListMapExtension on List<Map<dynamic, dynamic>> {
  List<T?> pluck<T>(String key) {
    return map((e) => e[key] as T?).toList();
  }

  List<T> pluckNotNull<T>(String key) {
    return map((e) => e[key] as T?)
        .where((value) => value != null)
        .cast<T>()
        .toList();
  }

  List<Map<String, dynamic>> pluckKeys(List<String> keys) {
    return map((map) {
      final result = <String, dynamic>{};
      for (final key in keys) {
        if (map.containsKey(key)) {
          result[key] = map[key];
        }
      }
      return result;
    }).toList();
  }

  Map<dynamic, dynamic>? findByKeyValue(String key, dynamic value) {
    try {
      return firstWhere((map) => map[key] == value);
    } catch (_) {
      return null;
    }
  }

  List<Map<dynamic, dynamic>> whereHasKeys(List<String> keys) {
    return where((map) => keys.every((key) => map.containsKey(key))).toList();
  }

  List<Map<dynamic, dynamic>> sortByKey(String key, {bool ascending = true}) {
    final sorted = List<Map<dynamic, dynamic>>.from(this);
    sorted.sort((a, b) {
      final aValue = a[key];
      final bValue = b[key];

      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return ascending ? -1 : 1;
      if (bValue == null) return ascending ? 1 : -1;

      final comparison = (aValue as Comparable).compareTo(bValue);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }
}

extension AtomicTypedListExtension<T> on List<T> {
  Map<K, V> toMap<K, V>({
    required K Function(T element) key,
    required V Function(T element) value,
  }) {
    final map = <K, V>{};
    for (final element in this) {
      map[key(element)] = value(element);
    }
    return map;
  }

  T? minBy<R extends Comparable>(R Function(T element) selector) {
    if (isEmpty) return null;

    return reduce((current, next) {
      return selector(current).compareTo(selector(next)) <= 0 ? current : next;
    });
  }

  T? maxBy<R extends Comparable>(R Function(T element) selector) {
    if (isEmpty) return null;

    return reduce((current, next) {
      return selector(current).compareTo(selector(next)) >= 0 ? current : next;
    });
  }
}
