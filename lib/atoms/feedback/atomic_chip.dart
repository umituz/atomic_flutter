import 'package:flutter/material.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/spacing/atomic_spacing.dart';
import '../../tokens/typography/atomic_typography.dart';
import '../../tokens/borders/atomic_borders.dart';

/// Atomic Chip Component
/// Tag-like component for labels, categories, and selections
class AtomicChip extends StatelessWidget {
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

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final bool selected;
  final AtomicChipVariant variant;
  final AtomicChipSize size;
  final Color? backgroundColor;
  final Color? borderColor;
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
        return selected ? AtomicColors.primary.withValues(alpha: 0.1) : Colors.transparent;
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
        color: borderColor ?? (selected ? AtomicColors.primary : AtomicColors.gray300),
        width: AtomicBorders.widthThin,
      );
    }
    return null;
  }
}

/// Chip variant options
enum AtomicChipVariant {
  filled,
  outlined,
  subtle,
}

/// Chip size options
enum AtomicChipSize {
  small,
  medium,
  large,
} 