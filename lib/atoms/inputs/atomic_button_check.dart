import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

/// A customizable button-like checkbox or radio button component.
///
/// The [AtomicButtonCheck] provides an interactive element that combines
/// the appearance of a button with the functionality of a checkbox or
/// a single-selection input. It's ideal for selection lists where each
/// option is presented as a distinct, tappable button.
///
/// Features:
/// - Displays a text label.
/// - Supports controlled or uncontrolled state via [initialValue] and [value].
/// - Customizable colors for background, text, and check indicator in
///   active, inactive, and disabled states.
/// - Adjustable border radius, padding, and margin.
/// - Animated state transitions.
///
/// Example usage:
/// ```dart
/// // Basic usage
/// AtomicButtonCheck(
///   text: 'Option A',
///   initialValue: false,
///   onChanged: (bool newValue) {
///     print('Option A is now: $newValue');
///   },
/// )
///
/// // Controlled usage with custom colors
/// bool _isSelected = true;
/// AtomicButtonCheck(
///   text: 'Selected Option',
///   value: _isSelected,
///   onChanged: (bool newValue) {
///     setState(() {
///       _isSelected = newValue;
///     });
///   },
///   activeBackgroundColor: Colors.green.shade100,
///   activeTextColor: Colors.green.shade800,
///   checkActiveBackgroundColor: Colors.green.shade700,
/// )
/// ```
class AtomicButtonCheck extends StatefulWidget {
  /// Creates an [AtomicButtonCheck] widget.
  ///
  /// [initialValue] is the initial state of the checkbox if [value] is not provided. Defaults to false.
  /// [value] is the current state of the checkbox (controlled mode). If provided, [initialValue] is ignored.
  /// [onChanged] is the callback function executed when the value changes.
  /// [text] is the label displayed on the button.
  /// [backgroundColor] is the background color when not active.
  /// [activeBackgroundColor] is the background color when active.
  /// [checkBackgroundColor] is the background color of the check indicator when not active.
  /// [checkActiveBackgroundColor] is the background color of the check indicator when active.
  /// [disabledColor] is the background color when disabled.
  /// [textColor] is the text color when not active.
  /// [disabledTextColor] is the text color when disabled.
  /// [activeTextColor] is the text color when active.
  /// [disabled] if true, the button is disabled. Defaults to false.
  /// [borderRadius] is the border radius of the button.
  /// [padding] is the internal padding of the button.
  /// [margin] is the external margin around the button.
  const AtomicButtonCheck({
    super.key,
    this.initialValue = false,
    this.value,
    this.onChanged,
    required this.text,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.checkBackgroundColor,
    this.checkActiveBackgroundColor,
    this.disabledColor,
    this.textColor,
    this.disabledTextColor,
    this.activeTextColor,
    this.disabled = false,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  /// The initial state of the checkbox if [value] is not provided. Defaults to false.
  final bool initialValue;

  /// The current state of the checkbox (controlled mode). If provided, [initialValue] is ignored.
  final bool? value;

  /// The callback function executed when the value changes.
  final ValueChanged<bool>? onChanged;

  /// The label displayed on the button.
  final String text;

  /// The background color of the button when it is not active.
  final Color? backgroundColor;

  /// The background color of the button when it is active.
  final Color? activeBackgroundColor;

  /// The background color of the check indicator when it is not active.
  final Color? checkBackgroundColor;

  /// The background color of the check indicator when it is active.
  final Color? checkActiveBackgroundColor;

  /// The background color of the button when it is disabled.
  final Color? disabledColor;

  /// The text color of the button when it is not active.
  final Color? textColor;

  /// The text color of the button when it is disabled.
  final Color? disabledTextColor;

  /// The text color of the button when it is active.
  final Color? activeTextColor;

  /// If true, the button is disabled and cannot be interacted with. Defaults to false.
  final bool disabled;

  /// The border radius of the button.
  final BorderRadius? borderRadius;

  /// The internal padding of the button.
  final EdgeInsetsGeometry? padding;

  /// The external margin around the button.
  final EdgeInsetsGeometry? margin;

  @override
  State<AtomicButtonCheck> createState() => _AtomicButtonCheckState();
}

class _AtomicButtonCheckState extends State<AtomicButtonCheck> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? widget.initialValue;
  }

  @override
  void didUpdateWidget(AtomicButtonCheck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _value) {
      setState(() {
        _value = widget.value!;
      });
    }
  }

  void _handleTap() {
    if (!widget.disabled && widget.onChanged != null) {
      setState(() {
        _value = !_value;
      });
      widget.onChanged!(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Container(
      margin: widget.margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.disabled ? null : _handleTap,
          borderRadius: widget.borderRadius ?? AtomicBorders.md,
          child: AnimatedContainer(
            duration: AtomicAnimations.normal,
            padding: widget.padding ?? EdgeInsets.all(theme.spacing.md),
            decoration: BoxDecoration(
              color: _getBackgroundColor(theme),
              borderRadius: widget.borderRadius ?? AtomicBorders.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AtomicText(
                    widget.text,
                    atomicStyle: AtomicTextStyle.bodyMedium,
                    style: TextStyle(
                      color: _getTextColor(theme),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: theme.spacing.sm),
                _buildCheckbox(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(AtomicThemeData theme) {
    return AnimatedContainer(
      duration: AtomicAnimations.fast,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: _getCheckboxBackgroundColor(theme),
        borderRadius: AtomicBorders.xs,
        border: Border.all(
          color: _value
              ? Colors.transparent
              : (widget.disabled ? theme.colors.gray300 : theme.colors.primary),
          width: _value ? 0 : 1,
        ),
      ),
      child: AnimatedSwitcher(
        duration: AtomicAnimations.fast,
        child: _value
            ? Icon(
                Icons.check,
                size: 12,
                color: widget.disabled
                    ? theme.colors.gray500
                    : theme.colors.primary,
                key: const ValueKey('check'),
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }

  Color _getBackgroundColor(AtomicThemeData theme) {
    if (widget.disabled) {
      return widget.disabledColor ??
          theme.colors.gray100.withValues(alpha: 0.5);
    }

    if (_value) {
      return widget.activeBackgroundColor ??
          theme.colors.primary.withValues(alpha: 0.1);
    }

    return widget.backgroundColor ??
        theme.colors.primary.withValues(alpha: 0.05);
  }

  Color _getTextColor(AtomicThemeData theme) {
    if (widget.disabled) {
      return widget.disabledTextColor ?? theme.colors.textDisabled;
    }

    if (_value) {
      return widget.activeTextColor ?? theme.colors.primary;
    }

    return widget.textColor ?? theme.colors.textPrimary;
  }

  Color _getCheckboxBackgroundColor(AtomicThemeData theme) {
    if (_value) {
      if (widget.disabled) {
        return theme.colors.gray200;
      }
      return widget.checkActiveBackgroundColor ?? theme.colors.surface;
    }

    return widget.checkBackgroundColor ?? Colors.transparent;
  }
}
