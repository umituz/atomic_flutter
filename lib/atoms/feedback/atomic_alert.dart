import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/atoms/icons/atomic_icon.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

/// A customizable alert component for displaying important messages to the user.
///
/// The [AtomicAlert] widget provides a visually distinct way to convey
/// success, error, warning, or informational messages. It supports a title,
/// optional subtitle, leading icon, and a closable option.
///
/// Features:
/// - Multiple variants ([AtomicAlertVariant]) for different message types.
/// - Customizable text, subtitle, and icon.
/// - Optional close button with a callback.
/// - Customizable margin.
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// AtomicAlert.success(
///   text: 'Operation successful!',
///   subtitle: 'Your changes have been saved.',
///   closable: true,
///   onClose: () {
///     print('Success alert closed!');
///   },
/// )
///
/// AtomicAlert.error(
///   text: 'Error occurred!',
///   subtitle: 'Please check your internet connection and try again.',
/// )
/// ```
class AtomicAlert extends StatelessWidget {
  /// The main text content of the alert.
  final String text;

  /// An optional secondary text displayed below the main text.
  final String? subtitle;

  /// An optional leading icon for the alert.
  final IconData? icon;

  /// The visual variant of the alert, determining its color scheme.
  final AtomicAlertVariant variant;

  /// If true, a close button is displayed, allowing the user to dismiss the alert.
  final bool closable;

  /// The callback function executed when the close button is pressed.
  final VoidCallback? onClose;

  /// The external margin around the alert.
  final EdgeInsetsGeometry? margin;

  /// Creates an [AtomicAlert] with a custom variant.
  ///
  /// [text] is the main content of the alert.
  /// [subtitle] is an optional secondary text.
  /// [icon] is an optional leading icon.
  /// [variant] specifies the alert's visual style. Defaults to [AtomicAlertVariant.info].
  /// [closable] determines if a close button is shown. Defaults to false.
  /// [onClose] is the callback for the close button.
  /// [margin] is the external margin.
  const AtomicAlert({
    super.key,
    required this.text,
    this.subtitle,
    this.icon,
    this.variant = AtomicAlertVariant.info,
    this.closable = false,
    this.onClose,
    this.margin,
  });

  /// Creates a success-themed [AtomicAlert].
  ///
  /// Defaults to [Icons.check_circle_outline] as the icon.
  const AtomicAlert.success({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.check_circle_outline,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.success;

  /// Creates an error-themed [AtomicAlert].
  ///
  /// Defaults to [Icons.error_outline] as the icon.
  const AtomicAlert.error({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.error_outline,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.error;

  /// Creates a warning-themed [AtomicAlert].
  ///
  /// Defaults to [Icons.warning_outlined] as the icon.
  const AtomicAlert.warning({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.warning_outlined,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.warning;

  /// Creates an info-themed [AtomicAlert].
  ///
  /// Defaults to [Icons.info_outline] as the icon.
  const AtomicAlert.info({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.info_outline,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.info;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Container(
      margin: margin,
      padding: EdgeInsets.all(theme.spacing.md),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: AtomicBorders.md,
        border: Border.all(
          color: _getBorderColor(theme),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            AtomicIcon(
              icon: icon!,
              color: _getIconColor(theme),
              size: AtomicIconSize.medium,
            ),
            SizedBox(width: theme.spacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AtomicText.bodyMedium(
                  text,
                  style: TextStyle(
                    color: _getTextColor(theme),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: theme.spacing.xs),
                  AtomicText.bodySmall(
                    subtitle!,
                    style: TextStyle(
                      color: _getSubtitleColor(theme),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (closable) ...[
            SizedBox(width: theme.spacing.sm),
            InkWell(
              onTap: onClose ?? () => {},
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xxs),
                child: AtomicIcon(
                  icon: Icons.close,
                  color: _getIconColor(theme),
                  size: AtomicIconSize.small,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicAlertVariant.success:
        return theme.colors.success.withValues(alpha: 0.1);
      case AtomicAlertVariant.error:
        return theme.colors.error.withValues(alpha: 0.1);
      case AtomicAlertVariant.warning:
        return theme.colors.warning.withValues(alpha: 0.1);
      case AtomicAlertVariant.info:
        return theme.colors.info.withValues(alpha: 0.1);
    }
  }

  Color _getBorderColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicAlertVariant.success:
        return theme.colors.success.withValues(alpha: 0.3);
      case AtomicAlertVariant.error:
        return theme.colors.error.withValues(alpha: 0.3);
      case AtomicAlertVariant.warning:
        return theme.colors.warning.withValues(alpha: 0.3);
      case AtomicAlertVariant.info:
        return theme.colors.info.withValues(alpha: 0.3);
    }
  }

  Color _getIconColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicAlertVariant.success:
        return theme.colors.success;
      case AtomicAlertVariant.error:
        return theme.colors.error;
      case AtomicAlertVariant.warning:
        return theme.colors.warning;
      case AtomicAlertVariant.info:
        return theme.colors.info;
    }
  }

  Color _getTextColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicAlertVariant.success:
        return theme.colors.successDark;
      case AtomicAlertVariant.error:
        return theme.colors.errorDark;
      case AtomicAlertVariant.warning:
        return theme.colors.warningDark;
      case AtomicAlertVariant.info:
        return theme.colors.infoDark;
    }
  }

  Color _getSubtitleColor(AtomicThemeData theme) {
    return _getTextColor(theme).withValues(alpha: 0.8);
  }
}

/// Defines the visual variants for an [AtomicAlert].
enum AtomicAlertVariant {
  /// Indicates a successful operation.
  success,

  /// Indicates an error or failure.
  error,

  /// Indicates a warning or caution.
  warning,

  /// Provides general information.
  info,
}
