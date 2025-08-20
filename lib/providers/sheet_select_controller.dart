import 'package:flutter/widgets.dart';
import 'package:atomic_flutter/models/select_list_item.dart';

class AtomicSheetSelectController<T> extends ChangeNotifier {
  AtomicSheetSelectController({
    List<AtomicSelectListItem<T>>? initialItems,
    AtomicSelectListItem<T>? initialSelectedItem,
    List<AtomicSelectListItem<T>>? initialSelectedItems,
    this.allowMultipleSelection = false,
  }) : _items = initialItems ?? [],
       _selectedItem = initialSelectedItem,
       _selectedItems = initialSelectedItems ?? [];

  List<AtomicSelectListItem<T>> _items;
  AtomicSelectListItem<T>? _selectedItem;
  List<AtomicSelectListItem<T>> _selectedItems;
  final bool allowMultipleSelection;

  List<AtomicSelectListItem<T>> get items => List.unmodifiable(_items);

  set items(List<AtomicSelectListItem<T>> items) {
    _items = List.from(items);
    _validateSelection();
    notifyListeners();
  }

  AtomicSelectListItem<T>? get selectedItem => _selectedItem;

  set selectedItem(AtomicSelectListItem<T>? item) {
    if (item != null && !_items.contains(item)) {
      throw ArgumentError('Selected item must be in the items list');
    }
    _selectedItem = item;
    
    if (item != null) {
      _selectedItems = [item];
    } else {
      _selectedItems.clear();
    }
    
    notifyListeners();
  }

  List<AtomicSelectListItem<T>> get selectedItems => List.unmodifiable(_selectedItems);

  set selectedItems(List<AtomicSelectListItem<T>> items) {
    for (final item in items) {
      if (!_items.contains(item)) {
        throw ArgumentError('All selected items must be in the items list');
      }
    }
    
    _selectedItems = List.from(items);
    
    _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
    
    notifyListeners();
  }

  void addItem(AtomicSelectListItem<T> item) {
    if (!_items.contains(item)) {
      _items.add(item);
      notifyListeners();
    }
  }

  void removeItem(AtomicSelectListItem<T> item) {
    if (_items.remove(item)) {
      if (_selectedItem == item) {
        _selectedItem = null;
      }
      _selectedItems.remove(item);
      notifyListeners();
    }
  }

  void selectItem(AtomicSelectListItem<T> item) {
    if (!_items.contains(item)) {
      throw ArgumentError('Item must be in the items list');
    }

    if (allowMultipleSelection) {
      if (!_selectedItems.contains(item)) {
        _selectedItems.add(item);
        _selectedItem = item; // Keep track of last selected
        notifyListeners();
      }
    } else {
      selectedItem = item;
    }
  }

  void deselectItem(AtomicSelectListItem<T> item) {
    if (_selectedItems.remove(item)) {
      if (_selectedItem == item) {
        _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
      }
      notifyListeners();
    }
  }

  void toggleItem(AtomicSelectListItem<T> item) {
    if (_selectedItems.contains(item)) {
      deselectItem(item);
    } else {
      selectItem(item);
    }
  }

  void clearSelection() {
    _selectedItem = null;
    _selectedItems.clear();
    notifyListeners();
  }

  bool isSelected(AtomicSelectListItem<T> item) {
    return _selectedItems.contains(item);
  }

  int get selectedCount => _selectedItems.length;

  bool get hasSelection => _selectedItems.isNotEmpty;

  List<T?> get selectedValues => _selectedItems.map((item) => item.value).toList();

  T? get selectedValue => _selectedItem?.value;

  void _validateSelection() {
    _selectedItems.removeWhere((item) => !_items.contains(item));
    
    if (_selectedItem != null && !_items.contains(_selectedItem!)) {
      _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
    }
  }

  void updateItems(List<AtomicSelectListItem<T>> newItems) {
    items = newItems;
  }

  List<AtomicSelectListItem<T>> filterItems(String searchText) {
    if (searchText.isEmpty) return items;
    
    return _items.where((item) =>
      item.text.toLowerCase().contains(searchText.toLowerCase()) ||
      (item.subText?.toLowerCase().contains(searchText.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  void dispose() {
    _items.clear();
    _selectedItems.clear();
    _selectedItem = null;
    super.dispose();
  }
}

class AtomicSheetSelectControllerDynamic extends AtomicSheetSelectController<dynamic> {
  AtomicSheetSelectControllerDynamic({
    super.initialItems,
    super.initialSelectedItem,
    super.initialSelectedItems,
    super.allowMultipleSelection = false,
  });
} 