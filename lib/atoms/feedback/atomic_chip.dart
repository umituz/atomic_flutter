import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/typography/atomic_typography.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';

/// A customizable chip component for displaying interactive information or selections.
///
/// The [AtomicChip] is a compact element that can represent an attribute,
/// text, entity, or action. It supports an optional icon, tap and delete actions,
/// and various visual styles and sizes.
///
/// Features:
/// - Display a text [label] and an optional [icon].
/// - Optional tap ([onTap]) and delete ([onDeleted]) callbacks.
/// - Support for selected state.
/// - Multiple variants ([AtomicChipVariant]) for different visual emphasis.
/// - Three sizes ([AtomicChipSize]).
/// - Customizable background, border, and text colors.
///
/// Example usage:
/// ```dart
/// // Basic chip
/// AtomicChip(
///   label: 'Filter 1',
///   onTap: () {
///     print('Chip tapped!');
///   },
/// )
///
/// // Selected chip with icon
/// AtomicChip(
///   label: 'Selected Item',
///   icon: Icons.check,
///   selected: true,
///   variant: AtomicChipVariant.filled,
/// )
///
/// // Deletable chip
/// AtomicChip(
///   label: 'Removable Tag',
///   onDeleted: () {
///     print('Chip deleted!');
///   },
/// )
/// ```
class AtomicChip extends StatelessWidget {
  /// Creates an [AtomicChip].
  ///
  /// [label] is the text displayed on the chip.
  /// [icon] is an optional leading icon for the chip.
  /// [onTap] is the callback function executed when the chip is tapped.
  /// [onDeleted] is the callback function executed when the delete icon is tapped.
  /// [selected] indicates whether the chip is currently selected. Defaults to false.
  /// [variant] defines the visual style of the chip. Defaults to [AtomicChipVariant.outlined].
  /// [size] defines the size of the chip. Defaults to [AtomicChipSize.medium].
  /// [backgroundColor] is an optional background color for the chip.
  /// [borderColor] is an optional border color for the chip.
  /// [textColor] is an optional text color for the chip.
  const AtomicChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDeleted,
    this.selected = false,
    this.variant = AtomicChipVariant.outlined,
    this.size = AtomicChipSize.medium,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  /// The text displayed on the chip.
  final String label;

  /// An optional leading icon for the chip.
  final IconData? icon;

  /// The callback function executed when the chip is tapped.
  final VoidCallback? onTap;

  /// The callback function executed when the delete icon is tapped.
  final VoidCallback? onDeleted;

  /// Indicates whether the chip is currently selected. Defaults to false.
  final bool selected;

  /// The visual variant of the chip. Defaults to [AtomicChipVariant.outlined].
  final AtomicChipVariant variant;

  /// The size of the chip. Defaults to [AtomicChipSize.medium].
  final AtomicChipSize size;

  /// An optional background color for the chip.
  final Color? backgroundColor;

  /// An optional border color for the chip.
  final Color? borderColor;

  /// An optional text color for the chip.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isClickable = onTap != null;

    Widget chip = Container(
      height: _getHeight(),
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: _getBorder(),
        borderRadius: AtomicBorders.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: _getIconSize(),
              color: _getTextColor(),
            ),
            const SizedBox(width: AtomicSpacing.xxs),
          ],
          Text(
            label,
            style: _getTextStyle(),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: AtomicSpacing.xxs),
            GestureDetector(
              onTap: onDeleted,
              child: Icon(
                Icons.close,
                size: _getIconSize(),
                color: _getTextColor(),
              ),
            ),
          ],
        ],
      ),
    );

    if (isClickable) {
      return GestureDetector(
        onTap: onTap,
        child: chip,
      );
    }

    return chip;
  }

  double _getHeight() {
    switch (size) {
      case AtomicChipSize.small:
        return 24;
      case AtomicChipSize.medium:
        return 32;
      case AtomicChipSize.large:
        return 40;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AtomicChipSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AtomicSpacing.xs,
          vertical: AtomicSpacing.xxs,
        );
      case AtomicChipSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AtomicSpacing.sm,
          vertical: AtomicSpacing.xs,
        );
      case AtomicChipSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AtomicSpacing.md,
          vertical: AtomicSpacing.sm,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case AtomicChipSize.small:
        return 12;
      case AtomicChipSize.medium:
        return 16;
      case AtomicChipSize.large:
        return 20;
    }
  }

  TextStyle _getTextStyle() {
    final TextStyle baseStyle;
    switch (size) {
      case AtomicChipSize.small:
        baseStyle = AtomicTypography.bodySmall;
      case AtomicChipSize.medium:
        baseStyle = AtomicTypography.bodyMedium;
      case AtomicChipSize.large:
        baseStyle = AtomicTypography.bodyLarge;
    }

    return baseStyle.copyWith(
      color: _getTextColor(),
      fontWeight: AtomicTypography.medium,
    );
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case AtomicChipVariant.filled:
        return selected ? AtomicColors.primary : AtomicColors.gray200;
      case AtomicChipVariant.outlined:
        return selected
            ? AtomicColors.primary.withValues(alpha: 0.1)
            : Colors.transparent;
      case AtomicChipVariant.subtle:
        return selected
            ? AtomicColors.primary.withValues(alpha: 0.1)
            : AtomicColors.gray100;
    }
  }

  Color _getTextColor() {
    if (textColor != null) return textColor!;

    switch (variant) {
      case AtomicChipVariant.filled:
        return selected ? AtomicColors.textInverse : AtomicColors.textPrimary;
      case AtomicChipVariant.outlined:
      case AtomicChipVariant.subtle:
        return selected ? AtomicColors.primary : AtomicColors.textPrimary;
    }
  }

  Border? _getBorder() {
    if (variant == AtomicChipVariant.outlined) {
      return Border.all(
        color: borderColor ??
            (selected ? AtomicColors.primary : AtomicColors.gray300),
        width: AtomicBorders.widthThin,
      );
    }
    return null;
  }
}

/// Defines the visual variants for an [AtomicChip].
enum AtomicChipVariant {
  /// A chip with a solid background color.
  filled,

  /// A chip with a transparent background and a border.
  outlined,

  /// A chip with a subtle background tint.
  subtle,
}

/// Defines the size variants for an [AtomicChip].
enum AtomicChipSize {
  /// A small chip.
  small,

  /// A medium-sized chip.
  medium,

  /// A large chip.
  large,
}
