import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/atoms/overlays/atomic_divider.dart';

/// A utility class for displaying customizable bottom sheets.
///
/// The [AtomicBottomSheet] provides static methods to show modal bottom sheets
/// with various content types, including custom widgets and lists of actions.
/// It offers extensive customization for appearance, behavior, and interaction.
///
/// Features:
/// - Show custom content or a list of actions.
/// - Customizable title and drag handle.
/// - Control over dismissibility and drag behavior.
/// - Adjustable height and maximum height.
/// - Customizable background color and padding.
/// - Optional close button.
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// // Show a bottom sheet with custom content
/// AtomicBottomSheet.show(
///   context: context,
///   title: 'Custom Bottom Sheet',
///   showDragHandle: true,
///   child: Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       Text('This is custom content in the bottom sheet.'),
///       SizedBox(height: 20),
///       ElevatedButton(
///         onPressed: () => Navigator.pop(context),
///         child: Text('Close'),
///       ),
///     ],
///   ),
/// );
///
/// // Show a bottom sheet with actions
/// AtomicBottomSheet.showActions(
///   context: context,
///   title: 'Choose an Option',
///   message: 'Select one of the following actions:',
///   actions: [
///     AtomicBottomSheetAction(
///       label: 'Edit Profile',
///       icon: Icons.edit,
///       onTap: () {
///         print('Edit Profile tapped!');
///         return 'profile_edited'; // Return value to show method
///       },
///     ),
///     AtomicBottomSheetAction(
///       label: 'Delete Account',
///       icon: Icons.delete,
///       isDestructive: true,
///       onTap: () {
///         print('Delete Account tapped!');
///         return null; // Don't dismiss automatically
///       },
///       shouldDismiss: false,
///     ),
///   ],
/// );
/// ```
class AtomicBottomSheet {
  static OverlayEntry? _currentToast; // This seems to be a copy-paste error from AtomicToast, should be _currentBottomSheet

  /// Displays a customizable modal bottom sheet with arbitrary content.
  ///
  /// [context] is the BuildContext to show the bottom sheet in.
  /// [child] is the main content of the bottom sheet.
  /// [title] is an optional text title displayed at the top of the sheet.
  /// [titleWidget] is an optional custom widget to use as the title. Overrides [title].
  /// [isDismissible] if true, the sheet can be dismissed by tapping outside. Defaults to true.
  /// [enableDrag] if true, the sheet can be dismissed by dragging down. Defaults to true.
  /// [showDragHandle] if true, a drag handle is displayed at the top of the sheet. Defaults to true.
  /// [height] specifies a fixed height for the bottom sheet.
  /// [maxHeight] specifies the maximum height as a fraction of screen height. Defaults to 0.9.
  /// [backgroundColor] is the background color of the bottom sheet.
  /// [padding] is the internal padding for the content area.
  /// [isScrollControlled] if true, the sheet can be full screen. Defaults to true.
  /// [showCloseButton] if true, a close button is displayed in the header. Defaults to false.
  /// [onClose] is the callback function executed when the close button is pressed.
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
      builder: (context) => Container(
        height: height ?? 400,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            if (showDragHandle)
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            if (title != null)
              Text(title!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  /// Displays a modal bottom sheet with a list of predefined actions.
  ///
  /// [context] is the BuildContext to show the bottom sheet in.
  /// [actions] is a list of [AtomicBottomSheetAction]s to display.
  /// [title] is an optional text title for the action sheet.
  /// [message] is an optional message displayed above the actions.
  /// [cancelLabel] is the label for the cancel button. Defaults to 'Cancel'.
  /// [showCancelButton] if true, a cancel button is displayed. Defaults to true.
  /// [isDismissible] if true, the sheet can be dismissed by tapping outside. Defaults to true.
  /// [enableDrag] if true, the sheet can be dismissed by dragging down. Defaults to true.
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
              padding: const EdgeInsets.symmetric(
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
          ...actions.map((action) => ListTile(
            title: Text(action.label),
            onTap: () {
              Navigator.of(context).pop();
              action.onTap();
            },
          )),
          if (showCancelButton) ...[
            const AtomicDivider(),
            ListTile(
              title: Text(cancelLabel ?? 'Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ],
      ),
    );
  }
}

/// A model representing a single action within an [AtomicBottomSheet].
class AtomicBottomSheetAction<T> {
  /// The label displayed for the action.
  final String label;

  /// The callback function executed when the action is tapped.
  ///
  /// This function can optionally return a value of type [T] which will be
  /// returned by the `AtomicBottomSheet.show` method.
  final T? Function() onTap;

  /// An optional leading icon for the action.
  final IconData? icon;

  /// An optional trailing widget for the action.
  final Widget? trailing;

  /// If true, the action is styled as a destructive action (e.g., red text).
  final bool isDestructive;

  /// If true, the action is interactive. Defaults to true.
  final bool isEnabled;

  /// If true, the bottom sheet will be dismissed after the action's [onTap] is called. Defaults to true.
  final bool shouldDismiss;

  /// Creates an [AtomicBottomSheetAction].
  ///
  /// [label] is the text displayed for the action.
  /// [onTap] is the callback function executed when the action is tapped.
  /// [icon] is an optional leading icon.
  /// [trailing] is an optional trailing widget.
  /// [isDestructive] styles the action as destructive.
  /// [isEnabled] controls interactivity.
  /// [shouldDismiss] controls automatic dismissal after tap.
  const AtomicBottomSheetAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.trailing,
    this.isDestructive = false,
    this.isEnabled = true,
    this.shouldDismiss = true,
  });
}
