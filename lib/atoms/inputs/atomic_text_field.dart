import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/typography/atomic_typography.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';

/// A customizable text input field component.
///
/// The [AtomicTextField] provides a flexible and theme-integrated text input
/// solution. It supports various input types, validation, and visual styles
/// for its borders.
///
/// Features:
/// - Customizable label, hint, helper, and error texts.
/// - Optional prefix and suffix icons/widgets.
/// - Support for various keyboard types and text input actions.
/// - Password input (obscureText).
/// - Enabled/disabled and read-only states.
/// - Customizable max lines, min lines, and max length.
/// - Input formatters for controlled input.
/// - Customizable fill color and border types ([AtomicTextFieldBorderType]).
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// TextEditingController _nameController = TextEditingController();
/// AtomicTextField(
///   controller: _nameController,
///   label: 'Full Name',
///   hint: 'Enter your full name',
///   prefixIcon: Icons.person,
///   onChanged: (value) {
///     print('Name: $value');
///   },
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Name cannot be empty';
///     }
///     return null;
///   },
/// )
///
/// AtomicTextField(
///   controller: TextEditingController(),
///   label: 'Password',
///   obscureText: true,
///   suffixIcon: Icon(Icons.visibility),
///   borderType: AtomicTextFieldBorderType.filled,
///   fillColor: Colors.blue.shade50,
/// )
/// ```
class AtomicTextField extends StatefulWidget {
  /// Creates an [AtomicTextField] widget.
  ///
  /// [controller] is the text editing controller for the field.
  /// [label] is the text displayed above the input field.
  /// [hint] is the text displayed inside the input field when it's empty.
  /// [helperText] is an optional helper text displayed below the input field.
  /// [errorText] is an optional error text displayed below the input field.
  /// [prefixIcon] is an optional icon displayed at the beginning of the input field.
  /// [suffixIcon] is an optional widget displayed at the end of the input field.
  /// [onChanged] is the callback function executed when the text changes.
  /// [onSubmitted] is the callback function executed when the user submits the text.
  /// [onTap] is the callback function executed when the input field is tapped.
  /// [validator] is a function that validates the input text.
  /// [keyboardType] specifies the type of keyboard to use.
  /// [textInputAction] specifies the action button on the keyboard.
  /// [obscureText] if true, hides the input text (e.g., for passwords). Defaults to false.
  /// [enabled] if true, the input field is interactive. Defaults to true.
  /// [readOnly] if true, the input field cannot be edited. Defaults to false.
  /// [autofocus] if true, the input field gains focus automatically. Defaults to false.
  /// [maxLines] is the maximum number of lines for the input field. Defaults to 1.
  /// [minLines] is the minimum number of lines for the input field. Defaults to 1.
  /// [maxLength] is the maximum number of characters allowed.
  /// [inputFormatters] is a list of formatters to apply to the input.
  /// [focusNode] is an optional focus node for controlling focus.
  /// [fillColor] is the background color of the input field.
  /// [borderType] defines the visual style of the input field's border. Defaults to [AtomicTextFieldBorderType.outlined].
  const AtomicTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.fillColor,
    this.borderType = AtomicTextFieldBorderType.outlined,
  });

  /// The text editing controller for the field.
  final TextEditingController controller;

  /// The text displayed above the input field.
  final String? label;

  /// The text displayed inside the input field when it's empty.
  final String? hint;

  /// An optional helper text displayed below the input field.
  final String? helperText;

  /// An optional error text displayed below the input field.
  final String? errorText;

  /// An optional icon displayed at the beginning of the input field.
  final IconData? prefixIcon;

  /// An optional widget displayed at the end of the input field.
  final Widget? suffixIcon;

  /// The callback function executed when the text changes.
  final ValueChanged<String>? onChanged;

  /// The callback function executed when the user submits the text.
  final ValueChanged<String>? onSubmitted;

  /// The callback function executed when the input field is tapped.
  final VoidCallback? onTap;

  /// A function that validates the input text.
  final String? Function(String?)? validator;

  /// Specifies the type of keyboard to use.
  final TextInputType? keyboardType;

  /// Specifies the action button on the keyboard.
  final TextInputAction? textInputAction;

  /// If true, hides the input text (e.g., for passwords). Defaults to false.
  final bool obscureText;

  /// If true, the input field is interactive. Defaults to true.
  final bool enabled;

  /// If true, the input field cannot be edited. Defaults to false.
  final bool readOnly;

  /// If true, the input field gains focus automatically. Defaults to false.
  final bool autofocus;

  /// The maximum number of lines for the input field. Defaults to 1.
  final int? maxLines;

  /// The minimum number of lines for the input field. Defaults to 1.
  final int? minLines;

  /// The maximum number of characters allowed.
  final int? maxLength;

  /// A list of formatters to apply to the input.
  final List<TextInputFormatter>? inputFormatters;

  /// An optional focus node for controlling focus.
  final FocusNode? focusNode;

  /// The background color of the input field.
  final Color? fillColor;

  /// Defines the visual style of the input field's border. Defaults to [AtomicTextFieldBorderType.outlined].
  final AtomicTextFieldBorderType borderType;

  @override
  State<AtomicTextField> createState() => _AtomicTextFieldState();
}

class _AtomicTextFieldState extends State<AtomicTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _errorText = widget.errorText;
    _hasError = _errorText != null;
  }

  @override
  void didUpdateWidget(AtomicTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorText = widget.errorText;
        _hasError = _errorText != null;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _handleChanged(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
        _hasError = error != null;
      });
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AtomicTypography.labelMedium.copyWith(
              color: _hasError
                  ? AtomicColors.error
                  : _isFocused
                      ? AtomicColors.primary
                      : AtomicColors.textSecondary,
              fontWeight: AtomicTypography.medium,
            ),
          ),
          const SizedBox(height: AtomicSpacing.xs),
        ],
        AnimatedContainer(
          duration: AtomicAnimations.fast,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: _handleChanged,
            onSubmitted: widget.onSubmitted,
            onTap: () {
              widget.onTap?.call();
              if (!_focusNode.hasFocus) {
                _focusNode.requestFocus();
              }
            },
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            style: AtomicTypography.bodyMedium.copyWith(
              color: widget.enabled
                  ? AtomicColors.textPrimary
                  : AtomicColors.textDisabled,
            ),
            decoration: _getDecoration(),
          ),
        ),
        if (_errorText != null || widget.helperText != null) ...[
          const SizedBox(height: AtomicSpacing.xxs),
          AnimatedDefaultTextStyle(
            duration: AtomicAnimations.fast,
            style: AtomicTypography.bodySmall.copyWith(
              color: _hasError ? AtomicColors.error : AtomicColors.textTertiary,
            ),
            child: Text(_errorText ?? widget.helperText!),
          ),
        ],
      ],
    );
  }

  InputDecoration _getDecoration() {
    switch (widget.borderType) {
      case AtomicTextFieldBorderType.outlined:
        return _getOutlinedDecoration();
      case AtomicTextFieldBorderType.filled:
        return _getFilledDecoration();
      case AtomicTextFieldBorderType.underlined:
        return _getUnderlinedDecoration();
      case AtomicTextFieldBorderType.none:
        return _getNoneDecoration();
    }
  }

  InputDecoration _getOutlinedDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AtomicTypography.bodyMedium.copyWith(
        color: AtomicColors.textTertiary,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _hasError
                  ? AtomicColors.error
                  : _isFocused
                      ? AtomicColors.primary
                      : AtomicColors.textTertiary,
              size: 20,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      filled: widget.fillColor != null,
      fillColor: widget.fillColor,
      contentPadding: AtomicSpacing.symmetric(
        horizontal: AtomicSpacing.inputPaddingX,
        vertical: AtomicSpacing.inputPaddingY,
      ),
      border: AtomicBorders.inputDefaultBorder,
      enabledBorder: _hasError
          ? AtomicBorders.inputErrorBorder
          : AtomicBorders.inputDefaultBorder,
      focusedBorder: _hasError
          ? AtomicBorders.inputErrorBorder
          : AtomicBorders.inputFocusedBorder,
      errorBorder: AtomicBorders.inputErrorBorder,
      focusedErrorBorder: AtomicBorders.inputErrorBorder,
      disabledBorder: AtomicBorders.inputDisabledBorder,
      counterText: '',
    );
  }

  InputDecoration _getFilledDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AtomicTypography.bodyMedium.copyWith(
        color: AtomicColors.textTertiary,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _hasError
                  ? AtomicColors.error
                  : _isFocused
                      ? AtomicColors.primary
                      : AtomicColors.textTertiary,
              size: 20,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      filled: true,
      fillColor: widget.fillColor ?? AtomicColors.gray100,
      contentPadding: AtomicSpacing.symmetric(
        horizontal: AtomicSpacing.inputPaddingX,
        vertical: AtomicSpacing.inputPaddingY,
      ),
      border: const OutlineInputBorder(
        borderRadius: AtomicBorders.input,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AtomicBorders.input,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AtomicBorders.input,
        borderSide:
            _hasError ? AtomicBorders.errorSide : AtomicBorders.primarySide,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AtomicBorders.input,
        borderSide: AtomicBorders.errorSide,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AtomicBorders.input,
        borderSide: AtomicBorders.errorSide,
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: AtomicBorders.input,
        borderSide: BorderSide.none,
      ),
      counterText: '',
    );
  }

  InputDecoration _getUnderlinedDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AtomicTypography.bodyMedium.copyWith(
        color: AtomicColors.textTertiary,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _hasError
                  ? AtomicColors.error
                  : _isFocused
                      ? AtomicColors.primary
                      : AtomicColors.textTertiary,
              size: 20,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      contentPadding: AtomicSpacing.symmetric(
        horizontal: 0,
        vertical: AtomicSpacing.inputPaddingY,
      ),
      border: UnderlineInputBorder(
        borderSide: AtomicBorders.defaultSide,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide:
            _hasError ? AtomicBorders.errorSide : AtomicBorders.defaultSide,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide:
            _hasError ? AtomicBorders.errorSide : AtomicBorders.primarySide,
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: AtomicBorders.errorSide,
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: AtomicBorders.errorSide,
      ),
      disabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AtomicColors.gray200,
          width: AtomicBorders.widthThin,
        ),
      ),
      counterText: '',
    );
  }

  InputDecoration _getNoneDecoration() {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AtomicTypography.bodyMedium.copyWith(
        color: AtomicColors.textTertiary,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _hasError
                  ? AtomicColors.error
                  : _isFocused
                      ? AtomicColors.primary
                      : AtomicColors.textTertiary,
              size: 20,
            )
          : null,
      suffixIcon: widget.suffixIcon,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      counterText: '',
    );
  }
}

enum AtomicTextFieldBorderType {
  outlined,
  filled,
  underlined,
  none,
}
