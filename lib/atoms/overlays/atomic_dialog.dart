import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/atoms/containers/atomic_card.dart';
import 'package:atomic_flutter/atoms/buttons/atomic_button.dart';

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