import 'package:flutter/widgets.dart';
import '../models/select_list_item.dart';

/// Atomic Sheet Select Controller
/// Manages selection state for sheet-based list selection components
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

  /// Get all items
  List<AtomicSelectListItem<T>> get items => List.unmodifiable(_items);

  /// Set items and notify listeners
  set items(List<AtomicSelectListItem<T>> items) {
    _items = List.from(items);
    _validateSelection();
    notifyListeners();
  }

  /// Get selected item (single selection mode)
  AtomicSelectListItem<T>? get selectedItem => _selectedItem;

  /// Set selected item (single selection mode)
  set selectedItem(AtomicSelectListItem<T>? item) {
    if (item != null && !_items.contains(item)) {
      throw ArgumentError('Selected item must be in the items list');
    }
    _selectedItem = item;
    
    // Update selected items list for consistency
    if (item != null) {
      _selectedItems = [item];
    } else {
      _selectedItems.clear();
    }
    
    notifyListeners();
  }

  /// Get selected items (multiple selection mode)
  List<AtomicSelectListItem<T>> get selectedItems => List.unmodifiable(_selectedItems);

  /// Set selected items (multiple selection mode)
  set selectedItems(List<AtomicSelectListItem<T>> items) {
    // Validate all items exist in the main list
    for (final item in items) {
      if (!_items.contains(item)) {
        throw ArgumentError('All selected items must be in the items list');
      }
    }
    
    _selectedItems = List.from(items);
    
    // Update single selection for consistency
    _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
    
    notifyListeners();
  }

  /// Add an item to the list
  void addItem(AtomicSelectListItem<T> item) {
    if (!_items.contains(item)) {
      _items.add(item);
      notifyListeners();
    }
  }

  /// Remove an item from the list
  void removeItem(AtomicSelectListItem<T> item) {
    if (_items.remove(item)) {
      // Clean up selection if removed item was selected
      if (_selectedItem == item) {
        _selectedItem = null;
      }
      _selectedItems.remove(item);
      notifyListeners();
    }
  }

  /// Select an item (handles both single and multiple selection)
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

  /// Deselect an item
  void deselectItem(AtomicSelectListItem<T> item) {
    if (_selectedItems.remove(item)) {
      if (_selectedItem == item) {
        _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
      }
      notifyListeners();
    }
  }

  /// Toggle item selection
  void toggleItem(AtomicSelectListItem<T> item) {
    if (_selectedItems.contains(item)) {
      deselectItem(item);
    } else {
      selectItem(item);
    }
  }

  /// Clear all selections
  void clearSelection() {
    _selectedItem = null;
    _selectedItems.clear();
    notifyListeners();
  }

  /// Check if an item is selected
  bool isSelected(AtomicSelectListItem<T> item) {
    return _selectedItems.contains(item);
  }

  /// Get number of selected items
  int get selectedCount => _selectedItems.length;

  /// Check if any item is selected
  bool get hasSelection => _selectedItems.isNotEmpty;

  /// Get selected values (extracts values from selected items)
  List<T?> get selectedValues => _selectedItems.map((item) => item.value).toList();

  /// Get selected value (single selection)
  T? get selectedValue => _selectedItem?.value;

  /// Validate current selection against items list
  void _validateSelection() {
    // Remove any selected items that are no longer in the items list
    _selectedItems.removeWhere((item) => !_items.contains(item));
    
    // Update selected item if it's no longer in the list
    if (_selectedItem != null && !_items.contains(_selectedItem!)) {
      _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
    }
  }

  /// Update items with new list
  void updateItems(List<AtomicSelectListItem<T>> newItems) {
    items = newItems;
  }

  /// Filter items based on search text
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

/// Non-generic version for backward compatibility
class AtomicSheetSelectControllerDynamic extends AtomicSheetSelectController<dynamic> {
  AtomicSheetSelectControllerDynamic({
    super.initialItems,
    super.initialSelectedItem,
    super.initialSelectedItems,
    super.allowMultipleSelection = false,
  });
} 