import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AtomicAccessibility {
  AtomicAccessibility._();

  static const double minimumTouchTarget = 44.0;

  static const double minContrastNormal = 4.5;
  static const double minContrastLarge = 3.0;
  static const double minContrastAAA = 7.0;

  static double contrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  static bool meetsWCAGAA(Color foreground, Color background,
      {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return ratio >= (isLargeText ? minContrastLarge : minContrastNormal);
  }

  static bool meetsWCAGAAA(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= minContrastAAA;
  }

  static Widget ensureMinimumTouchTarget({
    required Widget child,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: minimumTouchTarget,
      height: minimumTouchTarget,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class AtomicAccessibleButton extends StatelessWidget {
  const AtomicAccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    this.tooltip,
    this.excludeSemantics = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String? semanticLabel;
  final String? tooltip;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: onPressed,
      child: child,
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    if (!excludeSemantics) {
      button = Semantics(
        label: semanticLabel,
        button: true,
        enabled: onPressed != null,
        child: button,
      );
    }

    return button;
  }
}

class AtomicAccessibleTextField extends StatelessWidget {
  const AtomicAccessibleTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final String? semanticLabel;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? labelText,
      textField: true,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
        ),
      ),
    );
  }
}

class AtomicAnnouncements {
  static void announce(String message, {bool assertive = false}) {
    SemanticsService.announce(
      message,
      TextDirection.ltr,
    );
  }

  static void announceError(String error) {
    announce('Error: $error', assertive: true);
  }

  static void announceSuccess(String message) {
    announce('Success: $message');
  }

  static void announceLoading(String operation) {
    announce('Loading $operation');
  }

  static void announceLoadingComplete(String operation) {
    announce('$operation completed');
  }
}

class AtomicFocusManager {
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  static void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
