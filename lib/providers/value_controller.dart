import 'package:flutter/foundation.dart';

class AtomicValueController<T> extends ValueNotifier<T?> {
  AtomicValueController([super.initialValue]);

  final List<VoidCallback> _customListeners = [];
  final List<ValueChanged<T?>> _valueListeners = [];

  int addCustomListener(VoidCallback listener) {
    _customListeners.add(listener);
    return _customListeners.length - 1;
  }

  int addValueListener(ValueChanged<T?> listener) {
    _valueListeners.add(listener);
    return _valueListeners.length - 1;
  }

  void removeCustomListenerAt(int index) {
    if (index >= 0 && index < _customListeners.length) {
      _customListeners.removeAt(index);
    }
  }

  void removeValueListenerAt(int index) {
    if (index >= 0 && index < _valueListeners.length) {
      _valueListeners.removeAt(index);
    }
  }

  void removeAllCustomListeners() {
    _customListeners.clear();
  }

  void removeAllValueListeners() {
    _valueListeners.clear();
  }

  void removeAllListeners() {
    _customListeners.clear();
    _valueListeners.clear();
  }

  void notifyListenersWhere(bool Function(T? value) condition) {
    if (condition(value)) {
      notifyListeners();
    }
  }

  void notifyListenersIfNotNull() {
    if (value != null) {
      notifyListeners();
    }
  }

  void updateValue(T? newValue, {bool notify = true}) {
    if (notify) {
      value = newValue;
    } else {
      super.value = newValue;
    }
  }

  void updateValueIfChanged(T? newValue) {
    if (value != newValue) {
      value = newValue;
    }
  }

  void reset() {
    value = null;
  }

  bool get isNull => value == null;

  bool get isNotNull => value != null;

  T getValueOrDefault(T defaultValue) {
    return value ?? defaultValue;
  }

  void transform(T? Function(T? current) transformer) {
    value = transformer(value);
  }

  @override
  set value(T? newValue) {
    super.value = newValue;
    _notifyCustomListeners();
    _notifyValueListeners(newValue);
  }

  void _notifyCustomListeners() {
    for (final listener in _customListeners) {
      try {
        listener();
      } catch (e) {
        debugPrint('Error in custom listener: $e');
      }
    }
  }

  void _notifyValueListeners(T? newValue) {
    for (final listener in _valueListeners) {
      try {
        listener(newValue);
      } catch (e) {
        debugPrint('Error in value listener: $e');
      }
    }
  }

  @override
  void dispose() {
    _customListeners.clear();
    _valueListeners.clear();
    super.dispose();
  }

  AtomicValueController<T> copy() {
    return AtomicValueController<T>(value);
  }

  AtomicValueController<T> mirror() {
    final mirror = AtomicValueController<T>(value);
    addValueListener((newValue) => mirror.value = newValue);
    return mirror;
  }
}

class AtomicListValueController<T> extends AtomicValueController<List<T>> {
  AtomicListValueController([List<T>? initialValue]) : super(initialValue ?? []);

  List<T> get list => value ?? [];

  void addItem(T item) {
    final currentList = List<T>.from(list);
    currentList.add(item);
    value = currentList;
  }

  void addItems(Iterable<T> items) {
    final currentList = List<T>.from(list);
    currentList.addAll(items);
    value = currentList;
  }

  bool removeItem(T item) {
    final currentList = List<T>.from(list);
    final removed = currentList.remove(item);
    if (removed) {
      value = currentList;
    }
    return removed;
  }

  T? removeAt(int index) {
    if (index < 0 || index >= list.length) return null;
    
    final currentList = List<T>.from(list);
    final removed = currentList.removeAt(index);
    value = currentList;
    return removed;
  }

  void clear() {
    value = [];
  }

  bool get isEmpty => list.isEmpty;

  bool get isNotEmpty => list.isNotEmpty;

  int get length => list.length;

  void filter(bool Function(T) predicate) {
    final filtered = list.where(predicate).toList();
    value = filtered;
  }

  void sort([int Function(T, T)? compare]) {
    final sorted = List<T>.from(list);
    sorted.sort(compare);
    value = sorted;
  }

  void updateAt(int index, T item) {
    if (index >= 0 && index < list.length) {
      final currentList = List<T>.from(list);
      currentList[index] = item;
      value = currentList;
    }
  }

  void insertAt(int index, T item) {
    final currentList = List<T>.from(list);
    currentList.insert(index, item);
    value = currentList;
  }
}

extension AtomicListValueControllerExtensions<T> on AtomicListValueController<T> {
  AtomicListValueController<T> clone() {
    return AtomicListValueController<T>(List.from(list));
  }

  List<T> filteredView(bool Function(T) predicate) {
    return list.where(predicate).toList();
  }

  void makeUnique() {
    value = list.toSet().toList();
  }
} 