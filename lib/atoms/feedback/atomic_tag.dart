import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../display/atomic_text.dart';

/// Atomic Tag Component
/// Small label/tag component for categorization
class AtomicTag extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final AtomicTagSize size;
  final AtomicTagVariant variant;
  final EdgeInsetsGeometry? margin;

  const AtomicTag({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.onTap,
    this.onRemove,
    this.size = AtomicTagSize.medium,
    this.variant = AtomicTagVariant.outlined,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    Widget tag = Container(
      margin: margin,
      padding: _getPadding(theme),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: AtomicBorders.chip,
        border: Border.all(
          color: _getBorderColor(theme),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: _getIconSize(),
              color: _getTextColor(theme),
            ),
            SizedBox(width: theme.spacing.xxs),
          ],
          _buildLabel(theme),
          if (onRemove != null) ...[
            SizedBox(width: theme.spacing.xxs),
            InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(10),
              child: Icon(
                Icons.close,
                size: _getIconSize(),
                color: _getTextColor(theme),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AtomicBorders.chip,
        child: tag,
      );
    }

    return tag;
  }

  Widget _buildLabel(AtomicThemeData theme) {
    final textStyle = _getTextStyle(theme);
    
    switch (size) {
      case AtomicTagSize.small:
        return AtomicText.labelSmall(
          label,
          style: textStyle,
        );
      case AtomicTagSize.medium:
        return AtomicText.labelMedium(
          label,
          style: textStyle,
        );
      case AtomicTagSize.large:
        return AtomicText.labelLarge(
          label,
          style: textStyle,
        );
    }
  }

  EdgeInsets _getPadding(AtomicThemeData theme) {
    switch (size) {
      case AtomicTagSize.small:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.xs,
          vertical: theme.spacing.xxs,
        );
      case AtomicTagSize.medium:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        );
      case AtomicTagSize.large:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case AtomicTagSize.small:
        return 12;
      case AtomicTagSize.medium:
        return 14;
      case AtomicTagSize.large:
        return 16;
    }
  }

  Color _getBackgroundColor(AtomicThemeData theme) {
    if (backgroundColor != null) return backgroundColor!;
    
    switch (variant) {
      case AtomicTagVariant.filled:
        return theme.colors.primary;
      case AtomicTagVariant.outlined:
        return Colors.transparent;
      case AtomicTagVariant.subtle:
        return theme.colors.primary.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor(AtomicThemeData theme) {
    if (borderColor != null) return borderColor!;
    
    switch (variant) {
      case AtomicTagVariant.filled:
        return theme.colors.primary;
      case AtomicTagVariant.outlined:
        return theme.colors.primary;
      case AtomicTagVariant.subtle:
        return Colors.transparent;
    }
  }

  Color _getTextColor(AtomicThemeData theme) {
    if (color != null) return color!;
    
    switch (variant) {
      case AtomicTagVariant.filled:
        return theme.colors.textInverse;
      case AtomicTagVariant.outlined:
        return theme.colors.primary;
      case AtomicTagVariant.subtle:
        return theme.colors.primary;
    }
  }

  TextStyle _getTextStyle(AtomicThemeData theme) {
    return TextStyle(
      color: _getTextColor(theme),
      fontWeight: FontWeight.w500,
    );
  }
}

/// Tag size options
enum AtomicTagSize {
  small,
  medium,
  large,
}

/// Tag variant options
enum AtomicTagVariant {
  filled,
  outlined,
  subtle,
} 