import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../containers/atomic_card.dart';
import '../buttons/atomic_button.dart';

/// Atomic Dialog Component
/// Modern dialog with atomic design system styling
class AtomicDialog extends StatelessWidget {
  const AtomicDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.titleIcon,
    this.maxWidth = 400,
    this.barrierDismissible = true,
  });

  final String title;
  final String content;
  final List<Widget> actions;
  final IconData? titleIcon;
  final double maxWidth;
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
              // Title with optional icon
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
              
              // Content
              Text(
                content,
                style: theme.typography.bodyMedium.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
              SizedBox(height: theme.spacing.lg),
              
              // Actions
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

  /// Show atomic dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
    IconData? titleIcon,
    double maxWidth = 400,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
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

  /// Show confirmation dialog
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String content,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    IconData? titleIcon,
    bool isDangerous = false,
  }) async {
    return show<bool>(
      context: context,
      title: title,
      content: content,
      titleIcon: titleIcon,
      actions: [
        AtomicButton(
          label: cancelLabel,
          onPressed: () => Navigator.of(context).pop(false),
          variant: AtomicButtonVariant.outlined,
          size: AtomicButtonSize.medium,
        ),
        AtomicButton(
          label: confirmLabel,
          onPressed: () => Navigator.of(context).pop(true),
          variant: isDangerous 
            ? AtomicButtonVariant.danger 
            : AtomicButtonVariant.primary,
          size: AtomicButtonSize.medium,
        ),
      ],
    );
  }
} 