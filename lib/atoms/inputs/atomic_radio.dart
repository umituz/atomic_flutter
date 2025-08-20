import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/animations/atomic_animations.dart';

class AtomicRadio<T> extends StatelessWidget {
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

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final AtomicRadioSize size;
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

class AtomicRadioGroup<T> extends StatelessWidget {
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

  final T? value;
  final List<AtomicRadioItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Axis direction;
  final double? spacing;
  final double? runSpacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final AtomicRadioSize size;
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
        children: items.map((item) => AtomicRadio<T>(
          value: item.value,
          groupValue: value,
          onChanged: item.enabled && enabled ? onChanged : null,
          label: item.label,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          size: size,
          enabled: item.enabled && enabled,
        )).toList(),
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

class AtomicRadioItem<T> {
  const AtomicRadioItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

enum AtomicRadioSize {
  small,
  medium,
  large,
}
