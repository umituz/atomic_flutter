import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

/// A customizable radio button component.
///
/// The [AtomicRadio] widget allows users to select a single option from a set.
/// It supports an optional label, customizable colors, and different sizes.
/// It is typically used within an [AtomicRadioGroup] for managing selection.
///
/// Features:
/// - Supports generic type [T] for the value.
/// - Customizable active and inactive colors.
/// - Three predefined sizes ([AtomicRadioSize]).
/// - Optional text label.
/// - Enabled/disabled states.
///
/// Example usage:
/// ```dart
/// T? _selectedOption;
/// AtomicRadio<T>(
///   value: 'option1',
///   groupValue: _selectedOption,
///   onChanged: (T? newValue) {
///     setState(() {
///       _selectedOption = newValue;
///     });
///   },
///   label: 'Option 1',
/// )
/// ```
class AtomicRadio<T> extends StatelessWidget {
  /// Creates an [AtomicRadio] widget.
  ///
  /// [value] is the value represented by this radio button.
  /// [groupValue] is the currently selected value in the group.
  /// [onChanged] is the callback function executed when the radio button is selected.
  /// [label] is an optional text label displayed next to the radio button.
  /// [activeColor] is the color of the radio button when it is selected.
  /// [inactiveColor] is the color of the radio button when it is not selected.
  /// [size] defines the overall size of the radio button. Defaults to [AtomicRadioSize.medium].
  /// [enabled] if true, the radio button is interactive. Defaults to true.
  const AtomicRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.size = AtomicRadioSize.medium,
    this.enabled = true,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value in the group.
  final T? groupValue;

  /// The callback function executed when the radio button is selected.
  final ValueChanged<T?>? onChanged;

  /// An optional text label displayed next to the radio button.
  final String? label;

  /// The color of the radio button when it is selected.
  final Color? activeColor;

  /// The color of the radio button when it is not selected.
  final Color? inactiveColor;

  /// The overall size of the radio button. Defaults to [AtomicRadioSize.medium].
  final AtomicRadioSize size;

  /// If true, the radio button is interactive. Defaults to true.
  final bool enabled;

  bool get _isSelected => value == groupValue;

  void _handleTap() {
    if (enabled && onChanged != null) {
      onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final radioSize = _getSize();

    Widget radio = GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: AtomicAnimations.fast,
        width: radioSize,
        height: radioSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _getBorderColor(theme),
            width: 2,
          ),
        ),
        child: AnimatedContainer(
          duration: AtomicAnimations.fast,
          margin: EdgeInsets.all(_isSelected ? 3 : radioSize / 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isSelected
                ? (activeColor ?? theme.colors.primary)
                : Colors.transparent,
          ),
        ),
      ),
    );

    if (label != null) {
      return InkWell(
        onTap: _handleTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.xs,
            vertical: theme.spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              radio,
              SizedBox(width: theme.spacing.sm),
              Flexible(
                child: Text(
                  label!,
                  style: theme.typography.bodyMedium.copyWith(
                    color: enabled
                        ? theme.colors.textPrimary
                        : theme.colors.textDisabled,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return radio;
  }

  double _getSize() {
    switch (size) {
      case AtomicRadioSize.small:
        return 16;
      case AtomicRadioSize.medium:
        return 20;
      case AtomicRadioSize.large:
        return 24;
    }
  }

  Color _getBorderColor(AtomicThemeData theme) {
    if (!enabled) {
      return theme.colors.gray300;
    }

    if (_isSelected) {
      return activeColor ?? theme.colors.primary;
    } else {
      return inactiveColor ?? theme.colors.gray400;
    }
  }
}

/// A widget that groups multiple [AtomicRadio] buttons, managing their selection state.
///
/// The [AtomicRadioGroup] ensures that only one radio button within the group
/// can be selected at a time. It supports both horizontal and vertical layouts,
/// and allows for customization of spacing and colors.
///
/// Features:
/// - Manages the selection state for a group of radio buttons.
/// - Supports horizontal ([Axis.horizontal]) and vertical ([Axis.vertical]) layouts.
/// - Customizable spacing between radio buttons.
/// - Customizable active and inactive colors for the radio buttons.
/// - Enabled/disabled states for the entire group or individual items.
///
/// Example usage:
/// ```dart
/// T? _selectedGroupOption = 'optionB';
/// AtomicRadioGroup<T>(
///   value: _selectedGroupOption,
///   onChanged: (T? newValue) {
///     setState(() {
///       _selectedGroupOption = newValue;
///     });
///   },
///   items: const [
///     AtomicRadioItem(value: 'optionA', label: 'Group Option A'),
///     AtomicRadioItem(value: 'optionB', label: 'Group Option B'),
///     AtomicRadioItem(value: 'optionC', label: 'Group Option C', enabled: false),
///   ],
///   direction: Axis.vertical,
///   spacing: 10,
/// )
/// ```
class AtomicRadioGroup<T> extends StatelessWidget {
  /// Creates an [AtomicRadioGroup] widget.
  ///
  /// [value] is the currently selected value in the group.
  /// [items] is a list of [AtomicRadioItem]s to display in the group.
  /// [onChanged] is the callback function executed when a radio button's value changes.
  /// [direction] specifies the layout direction (horizontal or vertical). Defaults to [Axis.vertical].
  /// [spacing] is the main axis spacing between radio buttons.
  /// [runSpacing] is the cross axis spacing between radio buttons (only for horizontal Wrap).
  /// [activeColor] is the color of the selected radio button.
  /// [inactiveColor] is the color of unselected radio buttons.
  /// [size] defines the size of the radio buttons within the group. Defaults to [AtomicRadioSize.medium].
  /// [enabled] if true, the entire group is interactive. Defaults to true.
  const AtomicRadioGroup({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.direction = Axis.vertical,
    this.spacing,
    this.runSpacing,
    this.activeColor,
    this.inactiveColor,
    this.size = AtomicRadioSize.medium,
    this.enabled = true,
  });

  /// The currently selected value in the group.
  final T? value;

  /// A list of [AtomicRadioItem]s to display in the group.
  final List<AtomicRadioItem<T>> items;

  /// The callback function executed when a radio button's value changes.
  final ValueChanged<T?>? onChanged;

  /// The layout direction of the radio buttons (horizontal or vertical). Defaults to [Axis.vertical].
  final Axis direction;

  /// The main axis spacing between radio buttons.
  final double? spacing;

  /// The cross axis spacing between radio buttons (only for horizontal Wrap).
  final double? runSpacing;

  /// The color of the selected radio button.
  final Color? activeColor;

  /// The color of unselected radio buttons.
  final Color? inactiveColor;

  /// The size of the radio buttons within the group. Defaults to [AtomicRadioSize.medium].
  final AtomicRadioSize size;

  /// If true, the entire group is interactive. Defaults to true.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final effectiveSpacing = spacing ?? theme.spacing.sm;
    final effectiveRunSpacing = runSpacing ?? theme.spacing.sm;

    if (direction == Axis.horizontal) {
      return Wrap(
        spacing: effectiveSpacing,
        runSpacing: effectiveRunSpacing,
        children: items
            .map((item) => AtomicRadio<T>(
                  value: item.value,
                  groupValue: value,
                  onChanged: item.enabled && enabled ? onChanged : null,
                  label: item.label,
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  size: size,
                  enabled: item.enabled && enabled,
                ))
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        final index = items.indexOf(item);
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < items.length - 1 ? effectiveSpacing : 0,
          ),
          child: AtomicRadio<T>(
            value: item.value,
            groupValue: value,
            onChanged: item.enabled && enabled ? onChanged : null,
            label: item.label,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            size: size,
            enabled: item.enabled && enabled,
          ),
        );
      }).toList(),
    );
  }
}

/// A model representing a single item within an [AtomicRadioGroup].
class AtomicRadioItem<T> {
  /// The value associated with this radio item.
  final T value;

  /// The label displayed for this radio item.
  final String label;

  /// If true, this radio item is interactive. Defaults to true.
  final bool enabled;

  /// Creates an [AtomicRadioItem].
  ///
  /// [value] is the unique value for this item.
  /// [label] is the text displayed for this item.
  /// [enabled] controls if this specific item is interactive. Defaults to true.
  const AtomicRadioItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

/// Defines the predefined sizes for an [AtomicRadio] button.
enum AtomicRadioSize {
  /// A small radio button.
  small,

  /// A medium-sized radio button.
  medium,

  /// A large radio button.
  large,
}
