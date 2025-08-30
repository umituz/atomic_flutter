import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

/// A small, customizable component used to display a count or short text label.
///
/// The [AtomicBadge] is typically used to indicate notifications, status,
/// or categories. It can be displayed standalone or positioned relative to
/// another widget ([child]).
///
/// Features:
/// - Display a numeric [count] or a text [label].
/// - Multiple variants ([AtomicBadgeVariant]) for different semantic meanings.
/// - Three sizes ([AtomicBadgeSize]) and three shapes ([AtomicBadgeShape]).
/// - Customizable maximum count display (e.g., "99+").
/// - Option to show zero count.
/// - Flexible positioning relative to a child widget.
///
/// Example usage:
/// ```dart
/// // Standalone badge
/// AtomicBadge(
///   count: 5,
///   variant: AtomicBadgeVariant.info,
/// )
///
/// // Badge with a child widget
/// Stack(
///   children: [
///     Icon(Icons.notifications, size: 30),
///     AtomicBadge(
///       count: 3,
///       variant: AtomicBadgeVariant.error,
///       position: AtomicBadgePosition.topEnd,
///       offset: Offset(0, 0), // Adjust as needed
///       child: SizedBox.shrink(), // Placeholder for the child
///     ),
///   ],
/// )
/// ```
class AtomicBadge extends StatelessWidget {
  /// Creates an [AtomicBadge].
  ///
  /// [count] is an optional numeric value to display. If provided, [label] is ignored.
  /// [label] is an optional text string to display.
  /// [variant] defines the visual style of the badge. Defaults to [AtomicBadgeVariant.primary].
  /// [size] defines the size of the badge. Defaults to [AtomicBadgeSize.medium].
  /// [shape] defines the shape of the badge. Defaults to [AtomicBadgeShape.rounded].
  /// [maxCount] specifies the maximum number to display before showing "maxCount+". Defaults to 99.
  /// [showZero] if true, the badge is shown even if [count] is 0. Defaults to false.
  /// [child] is an optional widget over which the badge will be positioned.
  /// [position] defines where the badge is placed relative to the [child]. Defaults to [AtomicBadgePosition.topEnd].
  /// [offset] allows fine-tuning the badge's position relative to the [position].
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

  /// An optional numeric value to display in the badge.
  /// If provided, [label] is ignored.
  final int? count;

  /// An optional text string to display in the badge.
  final String? label;

  /// The visual variant of the badge, determining its color scheme.
  final AtomicBadgeVariant variant;

  /// The size of the badge.
  final AtomicBadgeSize size;

  /// The shape of the badge.
  final AtomicBadgeShape shape;

  /// The maximum number to display before showing "maxCount+". Defaults to 99.
  final int maxCount;

  /// If true, the badge is shown even if [count] is 0. Defaults to false.
  final bool showZero;

  /// An optional widget over which the badge will be positioned.
  final Widget? child;

  /// Defines where the badge is placed relative to the [child].
  final AtomicBadgePosition position;

  /// Allows fine-tuning the badge's position relative to the [position].
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

/// Defines the visual variants for an [AtomicBadge].
enum AtomicBadgeVariant {
  /// Primary badge variant, typically for main emphasis.
  primary,

  /// Secondary badge variant, for less emphasis.
  secondary,

  /// Success badge variant, indicating a positive status.
  success,

  /// Warning badge variant, indicating a cautionary status.
  warning,

  /// Error badge variant, indicating a negative or critical status.
  error,

  /// Info badge variant, for general informational purposes.
  info,

  /// Neutral badge variant, for a subdued or general status.
  neutral,
}

/// Defines the size variants for an [AtomicBadge].
enum AtomicBadgeSize {
  /// A small badge.
  small,

  /// A medium-sized badge.
  medium,

  /// A large badge.
  large,
}

/// Defines the shape variants for an [AtomicBadge].
enum AtomicBadgeShape {
  /// A square badge with minimal rounding.
  square,

  /// A badge with rounded corners.
  rounded,

  /// A pill-shaped badge with fully rounded ends.
  pill,
}

/// Defines the positioning options for an [AtomicBadge] relative to its child.
enum AtomicBadgePosition {
  /// Positioned at the top-start (e.g., top-left in LTR).
  topStart,

  /// Positioned at the top-end (e.g., top-right in LTR).
  topEnd,

  /// Positioned at the bottom-start (e.g., bottom-left in LTR).
  bottomStart,

  /// Positioned at the bottom-end (e.g., bottom-right in LTR).
  bottomEnd,
}
