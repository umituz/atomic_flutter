import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

/// A customizable tag component for displaying short, interactive labels.
///
/// The [AtomicTag] is a compact element used to categorize, filter, or
/// provide quick information. It supports an optional icon, tap and remove
/// actions, and various visual styles and sizes.
///
/// Features:
/// - Display a text [label] and an optional [icon].
/// - Optional tap ([onTap]) and remove ([onRemove]) callbacks.
/// - Multiple variants ([AtomicTagVariant]) for different visual emphasis.
/// - Three sizes ([AtomicTagSize]).
/// - Customizable background, border, and text colors.
///
/// Example usage:
/// ```dart
/// // Basic tag
/// AtomicTag(
///   label: 'Category',
///   onTap: () {
///     print('Tag tapped!');
///   },
/// )
///
/// // Removable tag with icon
/// AtomicTag(
///   label: 'Filter Applied',
///   icon: Icons.filter_list,
///   variant: AtomicTagVariant.filled,
///   onRemove: () {
///     print('Tag removed!');
///   },
/// )
/// ```
class AtomicTag extends StatelessWidget {
  /// Creates an [AtomicTag].
  ///
  /// [label] is the text displayed on the tag.
  /// [color] is the color of the tag's text.
  /// [backgroundColor] is the background color of the tag.
  /// [borderColor] is the border color of the tag.
  /// [icon] is an optional leading icon for the tag.
  /// [onTap] is the callback function executed when the tag is tapped.
  /// [onRemove] is the callback function executed when the remove icon is tapped.
  /// [size] defines the size of the tag. Defaults to [AtomicTagSize.medium].
  /// [variant] defines the visual style of the tag. Defaults to [AtomicTagVariant.outlined].
  /// [margin] is the external margin around the tag.
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

  /// The text displayed on the tag.
  final String label;

  /// The color of the tag's text.
  final Color? color;

  /// The background color of the tag.
  final Color? backgroundColor;

  /// The border color of the tag.
  final Color? borderColor;

  /// An optional leading icon for the tag.
  final IconData? icon;

  /// The callback function executed when the tag is tapped.
  final VoidCallback? onTap;

  /// The callback function executed when the remove icon is tapped.
  final VoidCallback? onRemove;

  /// The size of the tag. Defaults to [AtomicTagSize.medium].
  final AtomicTagSize size;

  /// The visual variant of the tag. Defaults to [AtomicTagVariant.outlined].
  final AtomicTagVariant variant;

  /// The external margin around the tag.
  final EdgeInsetsGeometry? margin;

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

/// Defines the predefined sizes for an [AtomicTag].
enum AtomicTagSize {
  /// A small tag.
  small,

  /// A medium-sized tag.
  medium,

  /// A large tag.
  large,
}

/// Defines the visual variants for an [AtomicTag].
enum AtomicTagVariant {
  /// A tag with a solid background color.
  filled,

  /// A tag with a transparent background and a border.
  outlined,

  /// A tag with a subtle background tint.
  subtle,
}
