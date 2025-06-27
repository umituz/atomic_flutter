import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/spacing/atomic_spacing.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/animations/atomic_animations.dart';
import '../buttons/atomic_button.dart';
import '../overlays/atomic_divider.dart';

/// Atomic Bottom Sheet Component
/// Modern bottom sheet with smooth animations
class AtomicBottomSheet {
  /// Show a bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    Widget? titleWidget,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = true,
    double? height,
    double maxHeight = 0.9,
    Color? backgroundColor,
    EdgeInsets? padding,
    bool isScrollControlled = true,
    bool showCloseButton = false,
    VoidCallback? onClose,
  }) {
    final theme = AtomicTheme.of(context);
    
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: AtomicColors.gray900.withValues(alpha: 0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AtomicBorders.radiusXl),
        ),
      ),
      builder: (context) => _AtomicBottomSheetContent(
        title: title,
        titleWidget: titleWidget,
        height: height,
        maxHeight: maxHeight,
        backgroundColor: backgroundColor,
        padding: padding,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        onClose: onClose,
        child: child,
      ),
    );
  }

  /// Show action sheet with list of options
  static Future<T?> showActions<T>({
    required BuildContext context,
    required List<AtomicBottomSheetAction<T>> actions,
    String? title,
    String? message,
    String? cancelLabel,
    bool showCancelButton = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return show<T>(
      context: context,
      title: title,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AtomicSpacing.lg,
                vertical: AtomicSpacing.sm,
              ),
              child: Text(
                message,
                style: AtomicTheme.of(context).typography.bodyMedium.copyWith(
                  color: AtomicTheme.of(context).colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const AtomicDivider(),
          ],
          ...actions.map((action) => _ActionItem(action: action)),
          if (showCancelButton) ...[
            const AtomicDivider(),
            _ActionItem(
              action: AtomicBottomSheetAction(
                label: cancelLabel ?? 'Cancel',
                onTap: () => Navigator.of(context).pop(),
                isDestructive: false,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bottom sheet content widget
class _AtomicBottomSheetContent extends StatelessWidget {
  const _AtomicBottomSheetContent({
    required this.child,
    this.title,
    this.titleWidget,
    this.height,
    this.maxHeight = 0.9,
    this.backgroundColor,
    this.padding,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.onClose,
  });

  final Widget child;
  final String? title;
  final Widget? titleWidget;
  final double? height;
  final double maxHeight;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool showDragHandle;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return AnimatedContainer(
      duration: AtomicAnimations.normal,
      height: height,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeight,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AtomicBorders.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            SizedBox(height: theme.spacing.xs),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colors.gray300,
                borderRadius: AtomicBorders.full,
              ),
            ),
            SizedBox(height: theme.spacing.xs),
          ],
          if (title != null || titleWidget != null || showCloseButton) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.lg,
                vertical: theme.spacing.sm,
              ),
              child: Row(
                children: [
                  if (showCloseButton) ...[
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        onClose?.call();
                        Navigator.of(context).pop();
                      },
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                    SizedBox(width: theme.spacing.sm),
                  ],
                  Expanded(
                    child: titleWidget ?? Text(
                      title!,
                      style: theme.typography.titleLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: showCloseButton 
                        ? TextAlign.start 
                        : TextAlign.center,
                    ),
                  ),
                  if (showCloseButton) ...[
                    const SizedBox(width: 48), // Balance for close button
                  ],
                ],
              ),
            ),
            const AtomicDivider(),
          ],
          Flexible(
            child: Padding(
              padding: padding ?? EdgeInsets.only(
                left: theme.spacing.lg,
                right: theme.spacing.lg,
                top: theme.spacing.md,
                bottom: theme.spacing.lg + bottomPadding,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action item widget
class _ActionItem<T> extends StatelessWidget {
  const _ActionItem({
    required this.action,
  });

  final AtomicBottomSheetAction<T> action;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return InkWell(
      onTap: action.isEnabled 
        ? () {
            final result = action.onTap();
            if (result != null || action.shouldDismiss) {
              Navigator.of(context).pop(result);
            }
          }
        : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.lg,
          vertical: theme.spacing.md,
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(
                action.icon,
                size: 24,
                color: _getColor(theme),
              ),
              SizedBox(width: theme.spacing.md),
            ],
            Expanded(
              child: Text(
                action.label,
                style: theme.typography.bodyLarge.copyWith(
                  color: _getColor(theme),
                  fontWeight: action.isDestructive 
                    ? FontWeight.w600 
                    : FontWeight.normal,
                ),
              ),
            ),
            if (action.trailing != null) ...[
              SizedBox(width: theme.spacing.md),
              action.trailing!,
            ],
          ],
        ),
      ),
    );
  }

  Color _getColor(AtomicThemeData theme) {
    if (!action.isEnabled) {
      return theme.colors.textDisabled;
    }
    if (action.isDestructive) {
      return theme.colors.error;
    }
    return theme.colors.textPrimary;
  }
}

/// Bottom sheet action configuration
class AtomicBottomSheetAction<T> {
  const AtomicBottomSheetAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.isDestructive = false,
    this.isEnabled = true,
    this.shouldDismiss = true,
  });

  final String label;
  final T? Function() onTap;
  final IconData? icon;
  final Widget? trailing;
  final bool isDestructive;
  final bool isEnabled;
  final bool shouldDismiss;
}
