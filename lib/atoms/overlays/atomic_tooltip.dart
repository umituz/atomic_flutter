import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';

/// A customizable tooltip component for displaying contextual information.
///
/// The [AtomicTooltip] provides a way to show a brief, informative message
/// when a user hovers over or long-presses a widget. It supports various
/// visual variants and customization options for appearance and behavior.
///
/// Features:
/// - Customizable message (plain text or rich text).
/// - Adjustable padding, margin, and vertical offset.
/// - Control over preferred position relative to the child.
/// - Three visual variants ([AtomicTooltipVariant]): standard, dark, and accent.
/// - Customizable decoration and text style.
/// - Adjustable wait and show durations.
/// - Control over trigger mode (long press, tap, hover).
/// - Accessibility features like `excludeFromSemantics`.
///
/// Example usage:
/// ```dart
/// AtomicTooltip(
///   message: 'This is a standard tooltip.',
///   child: IconButton(
///     icon: Icon(Icons.info),
///     onPressed: () {},
///   ),
/// )
///
/// AtomicTooltip(
///   message: 'Dark tooltip example.',
///   variant: AtomicTooltipVariant.dark,
///   preferBelow: false,
///   child: Text('Hover over me'),
/// )
/// ```
class AtomicTooltip extends StatelessWidget {
  /// The widget to which the tooltip is attached.
  final Widget child;

  /// The plain text message to display in the tooltip.
  final String message;

  /// A rich text message to display in the tooltip. Overrides [message].
  final String? richMessage;

  /// A rich text message to display in the tooltip. Overrides [message] and [richMessage].
  final InlineSpan? textSpan;

  /// The padding around the tooltip's content.
  final EdgeInsetsGeometry? padding;

  /// The margin around the tooltip.
  final EdgeInsetsGeometry? margin;

  /// The vertical distance between the tooltip and the widget.
  final double? verticalOffset;

  /// Whether the tooltip should prefer to be displayed below the widget.
  final bool preferBelow;

  /// Whether the tooltip's message should be excluded from the semantics tree.
  final bool excludeFromSemantics;

  /// The decoration for the tooltip's container.
  final Decoration? decoration;

  /// The text style for the tooltip's message.
  final TextStyle? textStyle;

  /// How the text in the tooltip should be aligned horizontally.
  final TextAlign? textAlign;

  /// The duration of the delay before the tooltip is shown.
  final Duration? waitDuration;

  /// The duration for which the tooltip is shown.
  final Duration? showDuration;

  /// The mode by which the tooltip is triggered.
  final TooltipTriggerMode? triggerMode;

  /// Whether tapping the tooltip dismisses it.
  final bool? enableTapToDismiss;

  /// Whether haptic feedback is enabled when the tooltip is shown.
  final bool? enableFeedback;

  /// The visual variant of the tooltip. Defaults to [AtomicTooltipVariant.standard].
  final AtomicTooltipVariant variant;

  /// Creates an [AtomicTooltip] widget.
  ///
  /// [child] is the widget to which the tooltip is attached.
  /// [message] is the plain text message.
  /// [richMessage] and [textSpan] provide rich text options.
  /// [padding], [margin], [verticalOffset] control layout.
  /// [preferBelow] controls vertical positioning.
  /// [excludeFromSemantics] for accessibility.
  /// [decoration], [textStyle], [textAlign] customize appearance.
  /// [waitDuration], [showDuration], [triggerMode] control behavior.
  /// [enableTapToDismiss], [enableFeedback] control interaction.
  /// [variant] defines visual style.
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
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Decoration _getDecorationForVariant(
      AtomicThemeData theme, AtomicTooltipVariant variant) {
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

  TextStyle _getTextStyleForVariant(
      AtomicThemeData theme, AtomicTooltipVariant variant) {
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

/// A tooltip component that supports rich text messages.
///
/// The [AtomicRichTooltip] is similar to [AtomicTooltip] but is specifically
/// designed to display messages formatted with [InlineSpan]s, allowing for
/// more complex text styling within the tooltip.
///
/// Example usage:
/// ```dart
/// AtomicRichTooltip(
///   message: TextSpan(
///     text: 'This is ',
///     children: [
///       TextSpan(
///         text: 'rich text',
///         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
///       ),
///       TextSpan(text: ' in a tooltip.'),
///     ],
///   ),
///   plainTextMessage: 'This is rich text in a tooltip.', // For accessibility
///   child: Text('Hover for rich info'),
/// )
/// ```
class AtomicRichTooltip extends StatelessWidget {
  /// The widget to which the tooltip is attached.
  final Widget child;

  /// The rich text message to display in the tooltip.
  final InlineSpan message;

  /// A plain text representation of the message, used for accessibility.
  final String? plainTextMessage;

  /// A rich text message to display in the tooltip. Overrides [message].
  final Widget? richMessage;

  /// The padding around the tooltip's content.
  final EdgeInsetsGeometry? padding;

  /// The margin around the tooltip.
  final EdgeInsetsGeometry? margin;

  /// The vertical distance between the tooltip and the widget.
  final double? verticalOffset;

  /// Whether the tooltip should prefer to be displayed below the widget.
  final bool preferBelow;

  /// Whether the tooltip's message should be excluded from the semantics tree.
  final bool excludeFromSemantics;

  /// The decoration for the tooltip's container.
  final Decoration? decoration;

  /// The text style for the tooltip's message.
  final TextStyle? textStyle;

  /// How the text in the tooltip should be aligned horizontally.
  final TextAlign? textAlign;

  /// The duration of the delay before the tooltip is shown.
  final Duration? waitDuration;

  /// The duration for which the tooltip is shown.
  final Duration? showDuration;

  /// The mode by which the tooltip is triggered.
  final TooltipTriggerMode? triggerMode;

  /// Whether tapping the tooltip dismisses it.
  final bool? enableTapToDismiss;

  /// Whether haptic feedback is enabled when the tooltip is shown.
  final bool? enableFeedback;

  /// Creates an [AtomicRichTooltip] widget.
  ///
  /// [child] is the widget to which the tooltip is attached.
  /// [message] is the rich text message.
  /// [plainTextMessage] is a plain text fallback for accessibility.
  /// [richMessage] is an alternative rich message widget.
  /// [padding], [margin], [verticalOffset] control layout.
  /// [preferBelow] controls vertical positioning.
  /// [excludeFromSemantics] for accessibility.
  /// [decoration], [textStyle], [textAlign] customize appearance.
  /// [waitDuration], [showDuration], [triggerMode] control behavior.
  /// [enableTapToDismiss], [enableFeedback] control interaction.
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
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: margin,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      excludeFromSemantics: excludeFromSemantics,
      decoration: decoration ??
          BoxDecoration(
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
      textStyle: textStyle ??
          TextStyle(
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

/// A utility class providing static methods for common tooltip patterns.
///
/// The [AtomicTooltipHelper] simplifies the creation of tooltips for various
/// purposes, such as displaying help text, information, or warnings.
class AtomicTooltipHelper {
  /// Creates a help-themed tooltip.
  ///
  /// [child] is the widget to which the tooltip is attached.
  /// [helpText] is the message to display.
  /// [variant] defines the visual style. Defaults to [AtomicTooltipVariant.standard].
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

  /// Creates an info-themed tooltip.
  ///
  /// [child] is the widget to which the tooltip is attached.
  /// [infoText] is the message to display.
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

  /// Creates a warning-themed tooltip.
  ///
  /// [child] is the widget to which the tooltip is attached.
  /// [warningText] is the message to display.
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

/// Defines the visual variants for an [AtomicTooltip].
enum AtomicTooltipVariant {
  /// A standard-themed tooltip with a light background.
  standard,

  /// A dark-themed tooltip with a dark background.
  dark,

  /// An accent-themed tooltip, typically using the primary color.
  accent,
}

/// Defines the predefined sizes for an [AtomicTooltip].
///
/// Note: This enum is currently not used in [AtomicTooltip] but is provided
/// for future expansion or consistency with other components.
enum AtomicTooltipSize {
  /// A small tooltip.
  small,

  /// A medium-sized tooltip.
  medium,

  /// A large tooltip.
  large,
}
