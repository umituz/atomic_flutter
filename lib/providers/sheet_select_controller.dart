import 'package:flutter/widgets.dart';
import 'package:atomic_flutter_kit/models/select_list_item.dart';

/// A ChangeNotifier that manages the selection state of a list of [AtomicSelectListItem]s.
///
/// This controller is designed to be used with selection widgets (e.g., dropdowns,
/// radio groups, multi-select lists) to provide a centralized way to manage
/// the available items and their selection status. It supports both single
/// and multiple selection modes.
///
/// Features:
/// - Manages a list of [AtomicSelectListItem]s.
/// - Supports single selection ([selectedItem]) and multiple selection ([selectedItems]).
/// - Provides methods to add, remove, select, deselect, and toggle items.
/// - Notifies listeners of changes in items or selection.
/// - Includes utility getters for selected count, presence of selection, and selected values.
/// - Can filter items based on search text.
///
/// Example usage:
/// ```dart
/// class MySelectionWidget extends StatefulWidget {
///   @override
///   _MySelectionWidgetState createState() => _MySelectionWidgetState();
/// }
///
/// class _MySelectionWidgetState extends State<MySelectionWidget> {
///   late AtomicSheetSelectController<String> _controller;
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = AtomicSheetSelectController<String>(
///       initialItems: [
///         AtomicSelectListItem(value: 'apple', label: 'Apple'),
///         AtomicSelectListItem(value: 'banana', label: 'Banana'),
///         AtomicSelectListItem(value: 'orange', label: 'Orange'),
///       ],
///       allowMultipleSelection: true,
///     );
///     _controller.addListener(_onSelectionChanged);
///   }
///
///   void _onSelectionChanged() {
///     print('Selected items: ${_controller.selectedValues}');
///   }
///
///   @override
///   void dispose() {
///     _controller.removeListener(_onSelectionChanged);
///     _controller.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         // Example of using items with a custom UI
///         ..._controller.items.map((item) => CheckboxListTile(
///           title: Text(item.label),
///           value: _controller.isSelected(item),
///           onChanged: (bool? newValue) {
///             _controller.toggleItem(item);
///           },
///         )).toList(),
///         ElevatedButton(
///           onPressed: () => _controller.clearSelection(),
///           child: Text('Clear Selection'),
///         ),
///       ],
///     );
///   }
/// }
/// ```
class AtomicSheetSelectController<T> extends ChangeNotifier {
  /// Creates an [AtomicSheetSelectController].
  ///
  /// [initialItems] is the initial list of items managed by the controller.
  /// [initialSelectedItem] is the initially selected item for single selection mode.
  /// [initialSelectedItems] is the initially selected items for multiple selection mode.
  /// [allowMultipleSelection] if true, enables multiple item selection. Defaults to false.
  AtomicSheetSelectController({
    List<AtomicSelectListItem<T>>? initialItems,
    AtomicSelectListItem<T>? initialSelectedItem,
    List<AtomicSelectListItem<T>>? initialSelectedItems,
    this.allowMultipleSelection = false,
  })  : _items = initialItems ?? [],
        _selectedItem = initialSelectedItem,
        _selectedItems = initialSelectedItems ?? [];

  List<AtomicSelectListItem<T>> _items;
  AtomicSelectListItem<T>? _selectedItem;
  List<AtomicSelectListItem<T>> _selectedItems;

  /// If true, allows multiple items to be selected simultaneously. Defaults to false.
  final bool allowMultipleSelection;

  /// The unmodifiable list of all items managed by the controller.
  List<AtomicSelectListItem<T>> get items => List.unmodifiable(_items);

  /// Sets the list of items managed by the controller.
  ///
  /// Notifies listeners after updating.
  set items(List<AtomicSelectListItem<T>> items) {
    _items = List.from(items);
    _validateSelection();
    notifyListeners();
  }

  /// The currently selected single item.
  ///
  /// Returns null if no item is selected or if multiple items are selected
  /// in multiple selection mode (in which case it returns the first selected item).
  AtomicSelectListItem<T>? get selectedItem => _selectedItem;

  /// Sets the currently selected single item.
  ///
  /// If [allowMultipleSelection] is false, this will deselect all other items.
  /// If the item is not in the [items] list, an [ArgumentError] is thrown.
  /// Notifies listeners after updating.
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

  /// The unmodifiable list of currently selected items.
  List<AtomicSelectListItem<T>> get selectedItems =>
      List.unmodifiable(_selectedItems);

  /// Sets the list of currently selected items.
  ///
  /// All items in the provided list must exist in the provided list of [items],
  /// otherwise an [ArgumentError] is thrown.
  /// Notifies listeners after updating.
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

  /// Adds a new item to the list of managed items.
  ///
  /// Notifies listeners if the item was successfully added.
  void addItem(AtomicSelectListItem<T> item) {
    if (!_items.contains(item)) {
      _items.add(item);
      notifyListeners();
    }
  }

  /// Removes an item from the list of managed items.
  ///
  /// If the removed item was selected, its selection is cleared.
  /// Notifies listeners if the item was successfully removed.
  void removeItem(AtomicSelectListItem<T> item) {
    if (_items.remove(item)) {
      if (_selectedItem == item) {
        _selectedItem = null;
      }
      _selectedItems.remove(item);
      notifyListeners();
    }
  }

  /// Selects a given item.
  ///
  /// If [allowMultipleSelection] is false, this will deselect all other items.
  /// If the item is not in the [items] list, an [ArgumentError] is thrown.
  /// Notifies listeners after selection.
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

  /// Deselects a given item.
  ///
  /// Notifies listeners after deselection.
  void deselectItem(AtomicSelectListItem<T> item) {
    if (_selectedItems.remove(item)) {
      if (_selectedItem == item) {
        _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
      }
      notifyListeners();
    }
  }

  /// Toggles the selection state of a given item.
  ///
  /// If the item is currently selected, it will be deselected.
  /// If it's not selected, it will be selected.
  /// Notifies listeners after toggling.
  void toggleItem(AtomicSelectListItem<T> item) {
    if (_selectedItems.contains(item)) {
      deselectItem(item);
    } else {
      selectItem(item);
    }
  }

  /// Clears all selected items.
  ///
  /// Notifies listeners after clearing.
  void clearSelection() {
    _selectedItem = null;
    _selectedItems.clear();
    notifyListeners();
  }

  /// Checks if a given item is currently selected.
  bool isSelected(AtomicSelectListItem<T> item) {
    return _selectedItems.contains(item);
  }

  /// The number of currently selected items.
  int get selectedCount => _selectedItems.length;

  /// True if at least one item is selected, false otherwise.
  bool get hasSelection => _selectedItems.isNotEmpty;

  /// An unmodifiable list of the values of all currently selected items.
  List<T?> get selectedValues =>
      _selectedItems.map((item) => item.value).toList();

  /// The value of the currently selected single item.
  ///
  /// Returns null if no item is selected or if multiple items are selected
  /// (in which case it returns the value of the first selected item).
  T? get selectedValue => _selectedItem?.value;

  void _validateSelection() {
    _selectedItems.removeWhere((item) => !_items.contains(item));

    if (_selectedItem != null && !_items.contains(_selectedItem!)) {
      _selectedItem = _selectedItems.isNotEmpty ? _selectedItems.first : null;
    }
  }

  /// Updates the list of items managed by the controller.
  ///
  /// This is a convenience method that calls the `items` setter.
  void updateItems(List<AtomicSelectListItem<T>> newItems) {
    items = newItems;
  }

  /// Filters the current list of items based on a search text.
  ///
  /// Returns a new list containing only the items whose label or subtitle
  /// contains the [searchText] (case-insensitive).
  List<AtomicSelectListItem<T>> filterItems(String searchText) {
    if (searchText.isEmpty) return items;

    return _items
        .where((item) =>
            item.label.toLowerCase().contains(searchText.toLowerCase()) ||
            (item.subText?.toLowerCase().contains(searchText.toLowerCase()) ??
                false))
        .toList();
  }

  @override
  void dispose() {
    _items.clear();
    _selectedItems.clear();
    _selectedItem = null;
    super.dispose();
  }
}

/// A specialized [AtomicSheetSelectController] for dynamic values.
///
/// This class is a convenience class for when the type of the value is dynamic.
class AtomicSheetSelectControllerDynamic
    extends AtomicSheetSelectController<dynamic> {
  /// Creates an [AtomicSheetSelectControllerDynamic].
  ///
  /// [initialItems] is the initial list of items.
  /// [initialSelectedItem] is the initially selected item.
  /// [initialSelectedItems] is the initially selected items.
  /// [allowMultipleSelection] if true, enables multiple item selection.
  AtomicSheetSelectControllerDynamic({
    super.initialItems,
    super.initialSelectedItem,
    super.initialSelectedItems,
    super.allowMultipleSelection = false,
  });
}
