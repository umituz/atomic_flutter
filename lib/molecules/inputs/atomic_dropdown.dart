import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/overlays/atomic_bottom_sheet.dart';

/// A customizable dropdown component for selecting an item from a list.
///
/// The [AtomicDropdown] provides a user-friendly way to select a single item
/// from a predefined list. It supports various customization options, including
/// a hint, label, helper/error texts, and an optional search filter.
/// The dropdown options are presented in a bottom sheet for better user experience
/// on mobile devices.
///
/// Features:
/// - Supports generic type [T] for the item's value.
/// - Customizable hint, label, helper text, and error text.
/// - Optional search filter for large lists.
/// - Customizable appearance (dense, expanded, custom decoration).
/// - Integrates with [AtomicBottomSheet] for displaying options.
/// - Enabled/disabled states.
///
/// Example usage:
/// ```dart
/// T? _selectedFruit;
/// AtomicDropdown<String>(
///   value: _selectedFruit,
///   onChanged: (newValue) {
///     setState(() {
///       _selectedFruit = newValue;
///     });
///   },
///   label: 'Select a Fruit',
///   hint: 'Choose your favorite fruit',
///   items: const [
///     AtomicDropdownItem(value: 'apple', label: 'Apple'),
///     AtomicDropdownItem(value: 'banana', label: 'Banana'),
///     AtomicDropdownItem(value: 'orange', label: 'Orange'),
///   ],
///   enableFilter: true,
///   filterHint: 'Search fruits...',
/// )
/// ```
class AtomicDropdown<T> extends StatefulWidget {
  /// Creates an [AtomicDropdown] widget.
  ///
  /// [items] is the list of selectable items.
  /// [onChanged] is the callback function executed when the selected value changes.
  /// [value] is the currently selected value.
  /// [hint] is the text displayed when no item is selected.
  /// [label] is the text label for the dropdown.
  /// [helperText] is an optional helper text displayed below the dropdown.
  /// [errorText] is an optional error text displayed below the dropdown.
  /// [enabled] controls whether the dropdown is interactive. Defaults to true.
  /// [dense] if true, the dropdown will have less vertical padding. Defaults to false.
  /// [isExpanded] if true, the dropdown will take up the full width. Defaults to false.
  /// [icon] is an optional custom icon for the dropdown.
  /// [iconSize] is the size of the dropdown icon. Defaults to 24.
  /// [isDense] if true, the dropdown will have less vertical padding. Defaults to false.
  /// [menuMaxHeight] is the maximum height of the dropdown menu.
  /// [enableFilter] if true, a search filter will be available in the bottom sheet. Defaults to false.
  /// [filterHint] is the hint text for the search filter. Defaults to 'Search...'.
  /// [itemBuilder] is a builder function for customizing the appearance of each item in the dropdown list.
  /// [selectedItemBuilder] is a builder function for customizing the appearance of the selected item in the dropdown.
  /// [dropdownDecoration] is an optional decoration for the dropdown container.
  /// [margin] is the external margin around the dropdown.
  /// [alignment] aligns the selected item's text within the dropdown. Defaults to [AlignmentDirectional.centerStart].
  const AtomicDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.dense = false,
    this.isExpanded = false,
    this.icon,
    this.iconSize = 24,
    this.isDense = false,
    this.menuMaxHeight,
    this.enableFilter = false,
    this.filterHint = 'Search...',
    this.itemBuilder,
    this.selectedItemBuilder,
    this.dropdownDecoration,
    this.margin,
    this.alignment = AlignmentDirectional.centerStart,
  });

  /// The list of selectable items for the dropdown.
  final List<AtomicDropdownItem<T>> items;

  /// The callback function executed when the selected value changes.
  final ValueChanged<T?>? onChanged;

  /// The currently selected value.
  final T? value;

  /// The text displayed when no item is selected.
  final String? hint;

  /// The text label for the dropdown.
  final String? label;

  /// An optional helper text displayed below the dropdown.
  final String? helperText;

  /// An optional error text displayed below the dropdown.
  final String? errorText;

  /// Controls whether the dropdown is interactive. Defaults to true.
  final bool enabled;

  /// If true, the dropdown will have less vertical padding. Defaults to false.
  final bool dense;

  /// If true, the dropdown will take up the full width. Defaults to false.
  final bool isExpanded;

  /// An optional custom icon for the dropdown.
  final Widget? icon;

  /// The size of the dropdown icon. Defaults to 24.
  final double iconSize;

  /// If true, the dropdown will have less vertical padding. Defaults to false.
  final bool isDense;

  /// The maximum height of the dropdown menu.
  final double? menuMaxHeight;

  /// If true, a search filter will be available in the bottom sheet. Defaults to false.
  final bool enableFilter;

  /// The hint text for the search filter. Defaults to 'Search...'.
  final String filterHint;

  /// A builder function for customizing the appearance of each item in the dropdown list.
  final Widget Function(AtomicDropdownItem<T> item)? itemBuilder;

  /// A builder function for customizing the appearance of the selected item in the dropdown.
  final Widget Function(T value)? selectedItemBuilder;

  /// An optional decoration for the dropdown container.
  final BoxDecoration? dropdownDecoration;

  /// The external margin around the dropdown.
  final EdgeInsetsGeometry? margin;

  /// Aligns the selected item's text within the dropdown. Defaults to [AlignmentDirectional.centerStart].
  final AlignmentGeometry alignment;

  @override
  State<AtomicDropdown<T>> createState() => _AtomicDropdownState<T>();
}

class _AtomicDropdownState<T> extends State<AtomicDropdown<T>> {
  final GlobalKey _dropdownKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _filterController = TextEditingController();
  List<AtomicDropdownItem<T>> _filteredItems = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _filterController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _filterController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    if (!mounted) return;

    final query = _filterController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        return item.label.toLowerCase().contains(query) ||
            (item.subtitle?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _showDropdownBottomSheet() {
    setState(() => _isOpen = true);

    _filterController.clear();
    _filteredItems = widget.items;

    AtomicBottomSheet.show<T>(
      context: context,
      title: widget.label ?? 'Select Option',
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      maxHeight: 0.7,
      child: _buildDropdownContent(),
    ).then((selectedValue) {
      setState(() => _isOpen = false);
      if (selectedValue != null && widget.onChanged != null) {
        widget.onChanged!(selectedValue);
      }
    });
  }

  Widget _buildDropdownContent() {
    final theme = AtomicTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableFilter) ...[
          Padding(
            padding: EdgeInsets.all(theme.spacing.md),
            child: TextField(
              controller: _filterController,
              decoration: InputDecoration(
                hintText: widget.filterHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AtomicBorders.radiusMd),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.md,
                  vertical: theme.spacing.sm,
                ),
              ),
            ),
          ),
        ],
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              final isSelected = widget.value == item.value;

              return ListTile(
                leading: item.leading,
                title: AtomicText.bodyMedium(
                  item.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? theme.colors.primary
                        : theme.colors.textPrimary,
                  ),
                ),
                subtitle: item.subtitle != null
                    ? AtomicText.bodySmall(
                        item.subtitle!,
                        style: TextStyle(
                          color: theme.colors.textSecondary,
                        ),
                      )
                    : null,
                trailing: item.trailing ??
                    (isSelected
                        ? Icon(
                            Icons.check,
                            color: theme.colors.primary,
                            size: 20,
                          )
                        : null),
                enabled: item.enabled,
                onTap: item.enabled
                    ? () {
                        Navigator.of(context).pop(item.value);
                      }
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final hasError = widget.errorText != null;
    final isEnabled = widget.enabled && widget.onChanged != null;

    final selectedItem =
        widget.items.where((item) => item.value == widget.value).firstOrNull;

    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            AtomicText.bodyMedium(
              widget.label!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: hasError ? theme.colors.error : theme.colors.textPrimary,
              ),
            ),
            SizedBox(height: theme.spacing.xs),
          ],
          GestureDetector(
            onTap: isEnabled ? _showDropdownBottomSheet : null,
            child: Container(
              key: _dropdownKey,
              decoration: widget.dropdownDecoration ??
                  BoxDecoration(
                    border: Border.all(
                      color: hasError
                          ? theme.colors.error
                          : _isOpen
                              ? theme.colors.primary
                              : theme.colors.gray300,
                      width: _isOpen ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(AtomicBorders.radiusMd),
                    color:
                        isEnabled ? theme.colors.surface : theme.colors.gray50,
                  ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.md,
                  vertical:
                      widget.isDense ? theme.spacing.sm : theme.spacing.md,
                ),
                child: Row(
                  children: [
                    if (selectedItem?.leading != null) ...[
                      selectedItem!.leading!,
                      SizedBox(width: theme.spacing.sm),
                    ],
                    Expanded(
                      child: selectedItem != null
                          ? (widget.selectedItemBuilder
                                  ?.call(selectedItem.value) ??
                              AtomicText.bodyMedium(
                                selectedItem.label,
                                style: TextStyle(
                                  color: isEnabled
                                      ? theme.colors.textPrimary
                                      : theme.colors.textSecondary,
                                ),
                              ))
                          : AtomicText.bodyMedium(
                              widget.hint ?? 'Select an option',
                              style: TextStyle(
                                color: theme.colors.textSecondary,
                              ),
                            ),
                    ),
                    SizedBox(width: theme.spacing.sm),
                    widget.icon ??
                        AnimatedRotation(
                          turns: _isOpen ? 0.5 : 0,
                          duration: AtomicAnimations.fast,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: widget.iconSize,
                            color: isEnabled
                                ? theme.colors.textSecondary
                                : theme.colors.gray400,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.helperText != null || hasError) ...[
            SizedBox(height: theme.spacing.xs),
            AtomicText.bodySmall(
              hasError ? widget.errorText! : widget.helperText!,
              style: TextStyle(
                color:
                    hasError ? theme.colors.error : theme.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AtomicDropdownItem<T> {
  const AtomicDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
}

class AtomicDropdownHelper {
  static AtomicDropdown<String> simple({
    required List<String> options,
    required ValueChanged<String?> onChanged,
    String? value,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    bool enabled = true,
  }) {
    return AtomicDropdown<String>(
      items: options
          .map((option) => AtomicDropdownItem(
                value: option,
                label: option,
              ))
          .toList(),
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
    );
  }

  static AtomicDropdown<T> withIcons<T>({
    required List<AtomicDropdownItem<T>> items,
    required ValueChanged<T?> onChanged,
    T? value,
    String? label,
    String? hint,
  }) {
    return AtomicDropdown<T>(
      items: items,
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
    );
  }

  static AtomicDropdown<T> searchable<T>({
    required List<AtomicDropdownItem<T>> items,
    required ValueChanged<T?> onChanged,
    T? value,
    String? label,
    String? hint,
    String filterHint = 'Search...',
  }) {
    return AtomicDropdown<T>(
      items: items,
      value: value,
      onChanged: onChanged,
      label: label,
      hint: hint,
      enableFilter: true,
      filterHint: filterHint,
    );
  }
}
