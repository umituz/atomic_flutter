import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

class AtomicButtonCheck extends StatefulWidget {
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

  final bool initialValue;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final String text;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? checkBackgroundColor;
  final Color? checkActiveBackgroundColor;
  final Color? disabledColor;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? activeTextColor;
  final bool disabled;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
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
            : (widget.disabled 
                ? theme.colors.gray300 
                : theme.colors.primary),
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
      return widget.disabledColor ?? theme.colors.gray100.withValues(alpha: 0.5);
    }
    
    if (_value) {
      return widget.activeBackgroundColor ?? theme.colors.primary.withValues(alpha: 0.1);
    }
    
    return widget.backgroundColor ?? theme.colors.primary.withValues(alpha: 0.05);
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