import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';

/// Atomic Tooltip Component
/// Material Design tooltip with theme integration
class AtomicTooltip extends StatelessWidget {
  final Widget child;
  final String message;
  final String? richMessage;
  final InlineSpan? textSpan;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;
  final bool preferBelow;
  final bool excludeFromSemantics;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Duration? waitDuration;
  final Duration? showDuration;
  final TooltipTriggerMode? triggerMode;
  final bool? enableTapToDismiss;
  final bool? enableFeedback;
  final AtomicTooltipVariant variant;

  const AtomicTooltip({
    super.key,
    required this.child,
    required this.message,
    this.richMessage,
    this.textSpan,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow = true,
    this.excludeFromSemantics = false,
    this.decoration,
    this.textStyle,
    this.textAlign,
    this.waitDuration,
    this.showDuration,
    this.triggerMode,
    this.enableTapToDismiss,
    this.enableFeedback,
    this.variant = AtomicTooltipVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return Tooltip(
      message: message,
      richMessage: textSpan,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: margin,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      excludeFromSemantics: excludeFromSemantics,
      decoration: decoration ?? _getDecorationForVariant(theme, variant),
      textStyle: textStyle ?? _getTextStyleForVariant(theme, variant),
      textAlign: textAlign,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      showDuration: showDuration ?? const Duration(seconds: 1),
      triggerMode: triggerMode ?? TooltipTriggerMode.longPress,
      enableTapToDismiss: enableTapToDismiss ?? true,
      enableFeedback: enableFeedback ?? true,
      child: child,
    );
  }

  Decoration _getDecorationForVariant(AtomicThemeData theme, AtomicTooltipVariant variant) {
    switch (variant) {
      case AtomicTooltipVariant.standard:
        return BoxDecoration(
          color: theme.colors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );
      case AtomicTooltipVariant.dark:
        return BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        );
      case AtomicTooltipVariant.accent:
        return BoxDecoration(
          color: theme.colors.primary,
          borderRadius: BorderRadius.circular(8),
        );
    }
  }

  TextStyle _getTextStyleForVariant(AtomicThemeData theme, AtomicTooltipVariant variant) {
    switch (variant) {
      case AtomicTooltipVariant.standard:
        return TextStyle(
          color: theme.colors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
      case AtomicTooltipVariant.dark:
        return const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
      case AtomicTooltipVariant.accent:
        return const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );
    }
  }
}

/// Atomic Rich Tooltip Component
/// Enhanced tooltip with rich content support
class AtomicRichTooltip extends StatelessWidget {
  final Widget child;
  final InlineSpan message;
  final String? plainTextMessage;
  final Widget? richMessage;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;
  final bool preferBelow;
  final bool excludeFromSemantics;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Duration? waitDuration;
  final Duration? showDuration;
  final TooltipTriggerMode? triggerMode;
  final bool? enableTapToDismiss;
  final bool? enableFeedback;

  const AtomicRichTooltip({
    super.key,
    required this.child,
    required this.message,
    this.plainTextMessage,
    this.richMessage,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow = true,
    this.excludeFromSemantics = false,
    this.decoration,
    this.textStyle,
    this.textAlign,
    this.waitDuration,
    this.showDuration,
    this.triggerMode,
    this.enableTapToDismiss,
    this.enableFeedback,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return Tooltip(
      message: plainTextMessage ?? '',
      richMessage: message,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: margin,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      excludeFromSemantics: excludeFromSemantics,
      decoration: decoration ?? BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: textStyle ?? TextStyle(
        color: theme.colors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textAlign: textAlign,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      showDuration: showDuration ?? const Duration(seconds: 2),
      triggerMode: triggerMode ?? TooltipTriggerMode.longPress,
      enableTapToDismiss: enableTapToDismiss ?? true,
      enableFeedback: enableFeedback ?? true,
      child: child,
    );
  }
}

/// Tooltip helper utility for common tooltip patterns
class AtomicTooltipHelper {
  static Widget help({
    required Widget child,
    required String helpText,
    AtomicTooltipVariant variant = AtomicTooltipVariant.standard,
  }) {
    return AtomicTooltip(
      message: helpText,
      variant: variant,
      child: child,
    );
  }

  static Widget info({
    required Widget child,
    required String infoText,
  }) {
    return AtomicTooltip(
      message: infoText,
      variant: AtomicTooltipVariant.accent,
      child: child,
    );
  }

  static Widget warning({
    required Widget child,
    required String warningText,
  }) {
    return AtomicTooltip(
      message: warningText,
      variant: AtomicTooltipVariant.dark,
      triggerMode: TooltipTriggerMode.tap,
      child: child,
    );
  }
}

/// Tooltip variant options
enum AtomicTooltipVariant {
  standard,
  dark,
  accent,
}

/// Tooltip size options
enum AtomicTooltipSize {
  small,
  medium,
  large,
} 