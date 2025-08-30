import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/atoms/containers/atomic_card.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_button.dart';

/// A customizable dialog component for displaying alerts, confirmations, or custom content.
///
/// The [AtomicDialog] provides a flexible way to present modal content to the user.
/// It supports a title, content message, and a list of actions. It also offers
/// static methods for easily showing generic dialogs and confirmation dialogs.
///
/// Features:
/// - Customizable title with optional icon.
/// - Displays a content message.
/// - Accepts a list of custom action widgets.
/// - Customizable maximum width.
/// - Control over barrier dismissibility.
/// - Static methods for common dialog patterns ([show], [showConfirmation]).
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// // Show a simple alert dialog
/// AtomicDialog.show(
///   context: context,
///   title: 'Alert!',
///   content: 'This is an important message.',
///   actions: [
///     AtomicButton(
///       text: 'OK',
///       onPressed: () => Navigator.of(context).pop(),
///     ),
///   ],
/// );
///
/// // Show a confirmation dialog
/// AtomicDialog.showConfirmation(
///   context: context,
///   title: 'Delete Item',
///   content: 'Are you sure you want to delete this item?',
///   confirmLabel: 'Delete',
///   cancelLabel: 'Cancel',
///   isDangerous: true,
/// ).then((confirmed) {
///   if (confirmed == true) {
///     print('Item deleted!');
///   } else {
///     print('Deletion cancelled.');
///   }
/// });
/// ```
class AtomicDialog extends StatelessWidget {
  /// Creates an [AtomicDialog] widget.
  ///
  /// [title] is the main title of the dialog.
  /// [content] is the main message or content of the dialog.
  /// [actions] is a list of widgets (typically [AtomicButton]s) to display as actions.
  /// [titleIcon] is an optional icon displayed next to the title.
  /// [maxWidth] specifies the maximum width of the dialog. Defaults to 400.
  /// [barrierDismissible] if true, the dialog can be dismissed by tapping outside.
  const AtomicDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.titleIcon,
    this.maxWidth = 400,
    this.barrierDismissible = true,
  });

  /// The main title of the dialog.
  final String title;

  /// The main message or content of the dialog.
  final String content;

  /// A list of widgets (typically [AtomicButton]s) to display as actions at the bottom of the dialog.
  final List<Widget> actions;

  /// An optional icon displayed next to the title.
  final IconData? titleIcon;

  /// The maximum width of the dialog. Defaults to 400.
  final double maxWidth;

  /// If true, the dialog can be dismissed by tapping outside the dialog.
  final bool barrierDismissible;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: AtomicCard(
          padding: EdgeInsets.all(theme.spacing.lg),
          shadow: AtomicCardShadow.large,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (titleIcon != null) ...[
                    Icon(
                      titleIcon,
                      color: theme.colors.primary,
                      size: 24,
                    ),
                    SizedBox(width: theme.spacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.typography.headlineSmall.copyWith(
                        color: theme.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: theme.spacing.md),
              Text(
                content,
                style: theme.typography.bodyMedium.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
              SizedBox(height: theme.spacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions
                    .map((action) => Padding(
                          padding: EdgeInsets.only(left: theme.spacing.sm),
                          child: action,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays a generic [AtomicDialog].
  ///
  /// [context] is the BuildContext to show the dialog in.
  /// [title] is the main title of the dialog.
  /// [content] is the main message or content of the dialog.
  /// [actions] is a list of widgets (typically [AtomicButton]s) to display as actions.
  /// [titleIcon] is an optional icon displayed next to the title.
  /// [maxWidth] specifies the maximum width of the dialog. Defaults to 400.
  /// [barrierDismissible] if true, the dialog can be dismissed by tapping outside.
  /// [useRootNavigator] if true, the dialog is pushed onto the root navigator.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
    IconData? titleIcon,
    double maxWidth = 400,
    bool barrierDismissible = true,
    bool useRootNavigator = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => AtomicDialog(
        title: title,
        content: content,
        actions: actions,
        titleIcon: titleIcon,
        maxWidth: maxWidth,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  /// Displays a confirmation dialog with customizable confirm and cancel buttons.
  ///
  /// Returns a [Future] that resolves to `true` if confirmed, `false` if cancelled,
  /// or `null` if dismissed by tapping outside (if [barrierDismissible] is true).
  ///
  /// [context] is the BuildContext to show the dialog in.
  /// [title] is the main title of the dialog.
  /// [content] is the main message or content of the dialog.
  /// [confirmLabel] is the label for the confirmation button. Defaults to 'Confirm'.
  /// [cancelLabel] is the label for the cancellation button. Defaults to 'Cancel'.
  /// [titleIcon] is an optional icon displayed next to the title.
  /// [isDangerous] if true, the confirm button will be styled as a destructive action.
  /// [useRootNavigator] if true, the dialog is pushed onto the root navigator.
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    IconData? titleIcon,
    bool isDangerous = false,
    bool useRootNavigator = false,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext dialogContext) {
        final theme = AtomicTheme.of(dialogContext);

        return Dialog(
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: AtomicCard(
              padding: EdgeInsets.all(theme.spacing.lg),
              shadow: AtomicCardShadow.large,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (titleIcon != null) ...[
                        Icon(
                          titleIcon,
                          color: theme.colors.primary,
                          size: 24,
                        ),
                        SizedBox(width: theme.spacing.sm),
                      ],
                      Expanded(
                        child: Text(
                          title,
                          style: theme.typography.headlineSmall.copyWith(
                            color: theme.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  Text(
                    content,
                    style: theme.typography.bodyMedium.copyWith(
                      color: theme.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: theme.spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AtomicButton(
                        label: cancelLabel,
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        variant: AtomicButtonVariant.outlined,
                        size: AtomicButtonSize.medium,
                      ),
                      SizedBox(width: theme.spacing.sm),
                      AtomicButton(
                        label: confirmLabel,
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        variant: isDangerous
                            ? AtomicButtonVariant.danger
                            : AtomicButtonVariant.primary,
                        size: AtomicButtonSize.medium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
