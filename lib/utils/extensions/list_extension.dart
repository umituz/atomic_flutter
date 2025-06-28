/// List Extension for Atomic Flutter
/// Provides additional functionality for List operations

extension AtomicListExtension<T> on List<T> {
  /// Returns the first element that satisfies the test, or null if none found
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  /// Returns the last element that satisfies the test, or null if none found
  T? lastWhereOrNull(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }

  /// Safely gets element at index, returns null if out of bounds
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Chunks the list into smaller lists of specified size
  List<List<T>> chunk(int size) {
    if (size <= 0) throw ArgumentError('Chunk size must be positive');
    
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  /// Removes duplicates from the list while preserving order
  List<T> unique() {
    final seen = <T>{};
    return where((element) => seen.add(element)).toList();
  }

  /// Groups elements by a key function
  Map<K, List<T>> groupBy<K>(K Function(T element) keyFunction) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Separates the list into two lists based on a predicate
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

  /// Inserts separator between each element
  List<T> intersperse(T separator) {
    if (isEmpty) return [];
    
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      if (i > 0) result.add(separator);
      result.add(this[i]);
    }
    return result;
  }

  /// Rotates the list by n positions
  List<T> rotate(int n) {
    if (isEmpty) return [];
    
    final normalizedN = n % length;
    if (normalizedN == 0) return List.from(this);
    
    return [...sublist(normalizedN), ...sublist(0, normalizedN)];
  }
}

/// Extension specifically for List<Map>
extension AtomicListMapExtension on List<Map<dynamic, dynamic>> {
  /// Plucks values for a specific key from a list of maps
  /// 
  /// Example:
  /// ```dart
  /// final users = [
  ///   {'name': 'John', 'age': 25},
  ///   {'name': 'Jane', 'age': 30},
  /// ];
  /// final names = users.pluck('name'); // ['John', 'Jane']
  /// ```
  List<T?> pluck<T>(String key) {
    return map((e) => e[key] as T?).toList();
  }

  /// Plucks values for a specific key, filtering out nulls
  List<T> pluckNotNull<T>(String key) {
    return map((e) => e[key] as T?)
        .where((value) => value != null)
        .cast<T>()
        .toList();
  }

  /// Plucks multiple keys from maps
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

  /// Finds the first map containing the specified key-value pair
  Map<dynamic, dynamic>? findByKeyValue(String key, dynamic value) {
    try {
      return firstWhere((map) => map[key] == value);
    } catch (_) {
      return null;
    }
  }

  /// Filters maps that contain all specified keys
  List<Map<dynamic, dynamic>> whereHasKeys(List<String> keys) {
    return where((map) => keys.every((key) => map.containsKey(key))).toList();
  }

  /// Sorts maps by a specific key
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

/// Extension for typed lists
extension AtomicTypedListExtension<T> on List<T> {
  /// Converts list to a map using key and value extractors
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

  /// Finds the minimum element according to a comparator
  T? minBy<R extends Comparable>(R Function(T element) selector) {
    if (isEmpty) return null;
    
    return reduce((current, next) {
      return selector(current).compareTo(selector(next)) <= 0 ? current : next;
    });
  }

  /// Finds the maximum element according to a comparator
  T? maxBy<R extends Comparable>(R Function(T element) selector) {
    if (isEmpty) return null;
    
    return reduce((current, next) {
      return selector(current).compareTo(selector(next)) >= 0 ? current : next;
    });
  }
} 