import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../icons/atomic_icon.dart';
import '../display/atomic_text.dart';

/// Atomic Alert Component
/// Notification/alert component with multiple variants
class AtomicAlert extends StatelessWidget {
  final String text;
  final String? subtitle;
  final IconData? icon;
  final AtomicAlertVariant variant;
  final bool closable;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? margin;

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

  // Variant constructors
  const AtomicAlert.success({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.check_circle_outline,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.success;

  const AtomicAlert.error({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.error_outline,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.error;

  const AtomicAlert.warning({
    super.key,
    required this.text,
    this.subtitle,
    this.icon = Icons.warning_outlined,
    this.closable = false,
    this.onClose,
    this.margin,
  }) : variant = AtomicAlertVariant.warning;

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

/// Alert variant options
enum AtomicAlertVariant {
  success,
  error,
  warning,
  info,
} 