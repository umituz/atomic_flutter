import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/themes/atomic_theme_data.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';

class AtomicBadge extends StatelessWidget {
  const AtomicBadge({
    super.key,
    this.count,
    this.label,
    this.variant = AtomicBadgeVariant.primary,
    this.size = AtomicBadgeSize.medium,
    this.shape = AtomicBadgeShape.rounded,
    this.maxCount = 99,
    this.showZero = false,
    this.child,
    this.position = AtomicBadgePosition.topEnd,
    this.offset = Offset.zero,
  });

  final int? count;
  final String? label;
  final AtomicBadgeVariant variant;
  final AtomicBadgeSize size;
  final AtomicBadgeShape shape;
  final int maxCount;
  final bool showZero;
  final Widget? child;
  final AtomicBadgePosition position;
  final Offset offset;

  bool get _showBadge {
    if (count != null) {
      return count! > 0 || showZero;
    }
    return label != null && label!.isNotEmpty;
  }

  String get _displayText {
    if (label != null) return label!;
    if (count == null) return '';
    if (count! > maxCount) return '$maxCount+';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    if (!_showBadge) {
      return child ?? const SizedBox.shrink();
    }

    final badge = AnimatedContainer(
      duration: AtomicAnimations.fast,
      padding: _getPadding(theme),
      constraints: BoxConstraints(
        minWidth: _getMinWidth(),
        minHeight: _getMinHeight(),
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: _getBorderRadius(),
        border: _getBorder(theme),
      ),
      child: Center(
        child: Text(
          _displayText,
          style: _getTextStyle(theme),
          textAlign: TextAlign.center,
        ),
      ),
    );

    if (child == null) {
      return badge;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: position == AtomicBadgePosition.topStart || 
               position == AtomicBadgePosition.topEnd 
               ? offset.dy 
               : null,
          bottom: position == AtomicBadgePosition.bottomStart || 
                  position == AtomicBadgePosition.bottomEnd 
                  ? offset.dy 
                  : null,
          left: position == AtomicBadgePosition.topStart || 
                position == AtomicBadgePosition.bottomStart 
                ? offset.dx 
                : null,
          right: position == AtomicBadgePosition.topEnd || 
                 position == AtomicBadgePosition.bottomEnd 
                 ? offset.dx 
                 : null,
          child: badge,
        ),
      ],
    );
  }

  EdgeInsets _getPadding(AtomicThemeData theme) {
    switch (size) {
      case AtomicBadgeSize.small:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.xxs,
          vertical: theme.spacing.xxs / 2,
        );
      case AtomicBadgeSize.medium:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.xs,
          vertical: theme.spacing.xxs,
        );
      case AtomicBadgeSize.large:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        );
    }
  }

  double _getMinWidth() {
    switch (size) {
      case AtomicBadgeSize.small:
        return 16;
      case AtomicBadgeSize.medium:
        return 20;
      case AtomicBadgeSize.large:
        return 24;
    }
  }

  double _getMinHeight() {
    switch (size) {
      case AtomicBadgeSize.small:
        return 16;
      case AtomicBadgeSize.medium:
        return 20;
      case AtomicBadgeSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle(AtomicThemeData theme) {
    final TextStyle baseStyle;
    switch (size) {
      case AtomicBadgeSize.small:
        baseStyle = theme.typography.labelSmall;
      case AtomicBadgeSize.medium:
        baseStyle = theme.typography.labelMedium;
      case AtomicBadgeSize.large:
        baseStyle = theme.typography.labelLarge;
    }

    return baseStyle.copyWith(
      color: _getTextColor(theme),
      fontWeight: FontWeight.w600,
      height: 1,
    );
  }

  Color _getBackgroundColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicBadgeVariant.primary:
        return theme.colors.primary;
      case AtomicBadgeVariant.secondary:
        return theme.colors.secondary;
      case AtomicBadgeVariant.success:
        return theme.colors.success;
      case AtomicBadgeVariant.warning:
        return theme.colors.warning;
      case AtomicBadgeVariant.error:
        return theme.colors.error;
      case AtomicBadgeVariant.info:
        return theme.colors.info;
      case AtomicBadgeVariant.neutral:
        return theme.colors.gray600;
    }
  }

  Color _getTextColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicBadgeVariant.warning:
        return theme.colors.gray900;
      default:
        return theme.colors.textInverse;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (shape) {
      case AtomicBadgeShape.square:
        return AtomicBorders.xs;
      case AtomicBadgeShape.rounded:
        return AtomicBorders.sm;
      case AtomicBadgeShape.pill:
        return AtomicBorders.full;
    }
  }

  Border? _getBorder(AtomicThemeData theme) {
    return null;
  }
}

enum AtomicBadgeVariant {
  primary,
  secondary,
  success,
  warning,
  error,
  info,
  neutral,
}

enum AtomicBadgeSize {
  small,
  medium,
  large,
}

enum AtomicBadgeShape {
  square,
  rounded,
  pill,
}

enum AtomicBadgePosition {
  topStart,
  topEnd,
  bottomStart,
  bottomEnd,
}
