import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atomic_flutter/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter/tokens/typography/atomic_typography.dart';
import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';

class AtomicTextField extends StatefulWidget {
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

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final Color? fillColor;
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
              color: _hasError 
                ? AtomicColors.error 
                : AtomicColors.textTertiary,
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
        borderSide: _hasError 
          ? AtomicBorders.errorSide 
          : AtomicBorders.primarySide,
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
        borderSide: _hasError 
          ? AtomicBorders.errorSide 
          : AtomicBorders.defaultSide,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: _hasError 
          ? AtomicBorders.errorSide 
          : AtomicBorders.primarySide,
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