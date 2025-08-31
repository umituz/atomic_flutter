import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';

import 'atomic_custom_sheet_body.dart';

/// A utility class for building and showing various types of custom bottom sheets.
///
/// The [AtomicSheetBuilder] provides static methods to simplify the creation
/// and display of custom bottom sheets, including sheets with arbitrary content
/// and action sheets with predefined options. It leverages [AtomicCustomSheetBody]
/// for consistent styling and behavior.
///
/// Features:
/// - Show custom content in a bottom sheet with various customization options.
/// - Show action sheets with a list of [AtomicSheetAction]s.
/// - Customizable background color, border radius, padding, and height constraints.
/// - Control over dismissibility, drag behavior, and drag indicator visibility.
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// // Show a custom content sheet
/// AtomicSheetBuilder.showCustomSheet(
///   context: context,
///   builder: (context) {
///     return Column(
///       mainAxisSize: MainAxisSize.min,
///       children: [
///         Text('This is a custom sheet!'),
///         ElevatedButton(
///           onPressed: () => Navigator.pop(context),
///           child: Text('Close'),
///         ),
///       ],
///     );
///   },
///   minHeight: 150,
///   maxHeight: 300,
/// );
///
/// // Show an action sheet
/// AtomicSheetBuilder.showActionSheet<String>(
///   context: context,
///   title: 'Choose an Action',
///   message: 'What would you like to do?',
///   actions: [
///     AtomicSheetAction(
///       label: 'Option 1',
///       value: 'option1',
///       icon: Icons.check,
///       onTap: () => print('Option 1 selected'),
///     ),
///     AtomicSheetAction(
///       label: 'Delete',
///       value: 'delete',
///       icon: Icons.delete,
///       isDestructive: true,
///       onTap: () => print('Delete action'),
///     ),
///   ],
/// ).then((result) {
///   if (result != null) {
///     print('Action sheet result: $result');
///   }
/// });
/// ```
class AtomicSheetBuilder {
  /// Shows a custom bottom sheet with the provided content and customization options.
  ///
  /// [context] is the BuildContext to show the sheet in.
  /// [builder] is a function that builds the content of the sheet.
  /// [backgroundColor] is the background color of the sheet.
  /// [borderRadius] is the border radius of the sheet.
  /// [padding] is the internal padding for the content.
  /// [minHeight] is the minimum height of the sheet.
  /// [maxHeight] is the maximum height of the sheet.
  /// [showDragIndicator] if true, a drag indicator is displayed at the top. Defaults to true.
  /// [dragIndicatorColor] is the color of the drag indicator.
  /// [scrollable] if true, the child content will be wrapped in a [SingleChildScrollView]. Defaults to true.
  /// [isDismissible] if true, the sheet can be dismissed by tapping outside. Defaults to true.
  /// [enableDrag] if true, the sheet can be dismissed by dragging down. Defaults to true.
  /// [useRootNavigator] if true, the sheet is pushed onto the root navigator. Defaults to false.
  /// [isScrollControlled] if true, the sheet can be full screen. Defaults to true.
  /// [barrierColor] is the color of the modal barrier.
  /// [elevation] is the z-coordinate at which to place the sheet.
  /// [transitionAnimationController] is the animation controller for the sheet's transition.
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

  /// Shows an action sheet with a list of predefined actions.
  ///
  /// [context] is the BuildContext to show the sheet in.
  /// [actions] is a list of [AtomicSheetAction]s to display.
  /// [title] is an optional title for the action sheet.
  /// [message] is an optional message displayed above the actions.
  /// [showCancelButton] if true, a cancel button is displayed at the bottom. Defaults to true.
  /// [cancelText] is the label for the cancel button. Defaults to 'Cancel'.
  /// [backgroundColor] is the background color of the sheet.
  /// [actionColor] is the color for action labels and icons.
  /// [cancelColor] is the color for the cancel button's text.
  /// [isDismissible] if true, the sheet can be dismissed by tapping outside. Defaults to true.
  /// [enableDrag] if true, the sheet can be dismissed by dragging down. Defaults to true.
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

/// A model representing a single action within an action sheet shown by [AtomicSheetBuilder].
class AtomicSheetAction<T> {
  /// The label displayed for the action.
  final String label;

  /// The value associated with this action. This value will be returned by `showActionSheet` if this action is selected.
  final T? value;

  /// An optional leading icon for the action.
  final IconData? icon;

  /// The callback function executed when the action is tapped.
  final VoidCallback? onTap;

  /// If true, the action is styled as a destructive action (e.g., red text).
  final bool isDestructive;

  /// If true, the action is interactive. Defaults to true.
  final bool isEnabled;

  /// Creates an [AtomicSheetAction].
  ///
  /// [label] is the text displayed for the action.
  /// [value] is the value returned when this action is selected.
  /// [icon] is an optional leading icon.
  /// [onTap] is the callback function executed when the action is tapped.
  /// [isDestructive] styles the action as destructive.
  /// [isEnabled] controls interactivity.
  const AtomicSheetAction({
    required this.label,
    this.value,
    this.icon,
    this.onTap,
    this.isDestructive = false,
    this.isEnabled = true,
  });
}
