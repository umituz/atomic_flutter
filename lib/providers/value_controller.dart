import 'package:flutter/foundation.dart';

/// Atomic Value Controller
/// Generic value notifier with enhanced listener management and conditional notifications
class AtomicValueController<T> extends ValueNotifier<T?> {
  AtomicValueController([super.initialValue]);

  final List<VoidCallback> _customListeners = [];
  final List<ValueChanged<T?>> _valueListeners = [];

  /// Add a custom listener that gets called on any change
  /// Returns the index of the listener for removal
  int addCustomListener(VoidCallback listener) {
    _customListeners.add(listener);
    return _customListeners.length - 1;
  }

  /// Add a value listener that receives the new value
  /// Returns the index of the listener for removal
  int addValueListener(ValueChanged<T?> listener) {
    _valueListeners.add(listener);
    return _valueListeners.length - 1;
  }

  /// Remove a custom listener by index
  void removeCustomListenerAt(int index) {
    if (index >= 0 && index < _customListeners.length) {
      _customListeners.removeAt(index);
    }
  }

  /// Remove a value listener by index
  void removeValueListenerAt(int index) {
    if (index >= 0 && index < _valueListeners.length) {
      _valueListeners.removeAt(index);
    }
  }

  /// Remove all custom listeners
  void removeAllCustomListeners() {
    _customListeners.clear();
  }

  /// Remove all value listeners
  void removeAllValueListeners() {
    _valueListeners.clear();
  }

  /// Remove all listeners (custom, value, and inherited)
  void removeAllListeners() {
    _customListeners.clear();
    _valueListeners.clear();
  }

  /// Notify listeners only if the condition is met
  void notifyListenersWhere(bool Function(T? value) condition) {
    if (condition(value)) {
      notifyListeners();
    }
  }

  /// Notify listeners only if the value is not null
  void notifyListenersIfNotNull() {
    if (value != null) {
      notifyListeners();
    }
  }

  /// Update value and optionally skip notification
  void updateValue(T? newValue, {bool notify = true}) {
    if (notify) {
      value = newValue;
    } else {
      // Update without notification
      super.value = newValue;
    }
  }

  /// Update value only if it's different from current value
  void updateValueIfChanged(T? newValue) {
    if (value != newValue) {
      value = newValue;
    }
  }

  /// Reset value to null
  void reset() {
    value = null;
  }

  /// Check if value is null
  bool get isNull => value == null;

  /// Check if value is not null
  bool get isNotNull => value != null;

  /// Get value or default
  T getValueOrDefault(T defaultValue) {
    return value ?? defaultValue;
  }

  /// Transform the current value
  void transform(T? Function(T? current) transformer) {
    value = transformer(value);
  }

  @override
  set value(T? newValue) {
    super.value = newValue;
    _notifyCustomListeners();
    _notifyValueListeners(newValue);
  }

  /// Notify all custom listeners
  void _notifyCustomListeners() {
    for (final listener in _customListeners) {
      try {
        listener();
      } catch (e) {
        if (kDebugMode) {
          print('Error in custom listener: $e');
        }
      }
    }
  }

  /// Notify all value listeners
  void _notifyValueListeners(T? newValue) {
    for (final listener in _valueListeners) {
      try {
        listener(newValue);
      } catch (e) {
        if (kDebugMode) {
          print('Error in value listener: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _customListeners.clear();
    _valueListeners.clear();
    super.dispose();
  }

  /// Create a copy of this controller with the same value
  AtomicValueController<T> copy() {
    return AtomicValueController<T>(value);
  }

  /// Create a controller that mirrors this one
  AtomicValueController<T> mirror() {
    final mirror = AtomicValueController<T>(value);
    addValueListener((newValue) => mirror.value = newValue);
    return mirror;
  }
}

/// Specialized controller for List values with additional helpers
class AtomicListValueController<T> extends AtomicValueController<List<T>> {
  AtomicListValueController([List<T>? initialValue]) : super(initialValue ?? []);

  /// Get the list or empty list if null
  List<T> get list => value ?? [];

  /// Add an item to the list
  void addItem(T item) {
    final currentList = List<T>.from(list);
    currentList.add(item);
    value = currentList;
  }

  /// Add multiple items to the list
  void addItems(Iterable<T> items) {
    final currentList = List<T>.from(list);
    currentList.addAll(items);
    value = currentList;
  }

  /// Remove an item from the list
  bool removeItem(T item) {
    final currentList = List<T>.from(list);
    final removed = currentList.remove(item);
    if (removed) {
      value = currentList;
    }
    return removed;
  }

  /// Remove item at index
  T? removeAt(int index) {
    if (index < 0 || index >= list.length) return null;
    
    final currentList = List<T>.from(list);
    final removed = currentList.removeAt(index);
    value = currentList;
    return removed;
  }

  /// Clear the list
  void clear() {
    value = [];
  }

  /// Check if list is empty
  bool get isEmpty => list.isEmpty;

  /// Check if list is not empty
  bool get isNotEmpty => list.isNotEmpty;

  /// Get list length
  int get length => list.length;

  /// Filter the list
  void filter(bool Function(T) predicate) {
    final filtered = list.where(predicate).toList();
    value = filtered;
  }

  /// Sort the list
  void sort([int Function(T, T)? compare]) {
    final sorted = List<T>.from(list);
    sorted.sort(compare);
    value = sorted;
  }

  /// Update item at index
  void updateAt(int index, T item) {
    if (index >= 0 && index < list.length) {
      final currentList = List<T>.from(list);
      currentList[index] = item;
      value = currentList;
    }
  }

  /// Insert item at index
  void insertAt(int index, T item) {
    final currentList = List<T>.from(list);
    currentList.insert(index, item);
    value = currentList;
  }
}

/// Extension for special operations on List controllers
extension AtomicListValueControllerExtensions<T> on AtomicListValueController<T> {
  /// Clone the controller with the same list
  AtomicListValueController<T> clone() {
    return AtomicListValueController<T>(List.from(list));
  }

  /// Create a filtered view of the list (read-only)
  List<T> filteredView(bool Function(T) predicate) {
    return list.where(predicate).toList();
  }

  /// Get unique items in the list
  void makeUnique() {
    value = list.toSet().toList();
  }
} 