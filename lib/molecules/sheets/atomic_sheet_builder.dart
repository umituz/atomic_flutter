import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/themes/atomic_theme_data.dart';

import 'atomic_custom_sheet_body.dart';

class AtomicSheetBuilder {
  static Future<T?> showCustomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    double? minHeight,
    double? maxHeight,
    bool showDragIndicator = true,
    Color? dragIndicatorColor,
    bool scrollable = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = false,
    bool isScrollControlled = true,
    Color? barrierColor,
    double? elevation,
    AnimationController? transitionAnimationController,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      elevation: elevation,
      transitionAnimationController: transitionAnimationController,
      builder: (context) => AtomicCustomSheetBody(
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        padding: padding,
        minHeight: minHeight,
        maxHeight: maxHeight,
        showDragIndicator: showDragIndicator,
        dragIndicatorColor: dragIndicatorColor,
        scrollable: scrollable,
        child: builder(context),
      ),
    );
  }

  static Future<T?> showActionSheet<T>({
    required BuildContext context,
    required List<AtomicSheetAction<T>> actions,
    String? title,
    String? message,
    bool showCancelButton = true,
    String cancelText = 'Cancel',
    Color? backgroundColor,
    Color? actionColor,
    Color? cancelColor,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    final theme = AtomicTheme.of(context);
    
    return showCustomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      scrollable: false,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || message != null)
            Padding(
              padding: EdgeInsets.only(
                bottom: theme.spacing.md,
              ),
              child: Column(
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: theme.typography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (title != null && message != null)
                    SizedBox(height: theme.spacing.xs),
                  if (message != null)
                    Text(
                      message,
                      style: theme.typography.bodyMedium.copyWith(
                        color: theme.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ...actions.map((action) => _buildActionItem(
            context: context,
            action: action,
            theme: theme,
            actionColor: actionColor,
          )),
          if (showCancelButton) ...[
            SizedBox(height: theme.spacing.sm),
            _buildCancelButton(
              context: context,
              theme: theme,
              cancelText: cancelText,
              cancelColor: cancelColor,
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildActionItem<T>({
    required BuildContext context,
    required AtomicSheetAction<T> action,
    required AtomicThemeData theme,
    Color? actionColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.isEnabled
            ? () {
                Navigator.of(context).pop(action.value);
                action.onTap?.call();
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
                  size: 20,
                  color: action.isEnabled
                      ? (action.isDestructive
                          ? theme.colors.error
                          : (actionColor ?? theme.colors.primary))
                      : theme.colors.gray400,
                ),
                SizedBox(width: theme.spacing.md),
              ],
              Expanded(
                child: Text(
                  action.label,
                  style: theme.typography.bodyLarge.copyWith(
                    color: action.isEnabled
                        ? (action.isDestructive
                            ? theme.colors.error
                            : (actionColor ?? theme.colors.textPrimary))
                        : theme.colors.textDisabled,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCancelButton({
    required BuildContext context,
    required AtomicThemeData theme,
    required String cancelText,
    Color? cancelColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.lg,
            vertical: theme.spacing.md,
          ),
          child: Text(
            cancelText,
            style: theme.typography.bodyLarge.copyWith(
              color: cancelColor ?? theme.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class AtomicSheetAction<T> {
  const AtomicSheetAction({
    required this.label,
    this.value,
    this.icon,
    this.onTap,
    this.isDestructive = false,
    this.isEnabled = true,
  });

  final String label;
  final T? value;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isEnabled;
} 