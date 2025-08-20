import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../display/atomic_text.dart';

class AtomicSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String? semanticFormatterCallback;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double? thumbRadius;
  final String? helperText;
  final String? errorText;
  final EdgeInsetsGeometry? margin;

  const AtomicSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.semanticFormatterCallback,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.helperText,
    this.errorText,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final isEnabled = enabled && onChanged != null;
    final hasError = errorText != null;

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getActiveColor(theme, hasError),
              inactiveTrackColor: _getInactiveColor(theme, hasError),
              thumbColor: _getThumbColor(theme, hasError),
              overlayColor: _getActiveColor(theme, hasError).withValues(alpha: 0.1),
              valueIndicatorColor: _getActiveColor(theme, hasError),
              valueIndicatorTextStyle: theme.typography.labelSmall.copyWith(
                color: theme.colors.textInverse,
              ),
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: thumbRadius ?? 12.0,
                disabledThumbRadius: thumbRadius ?? 8.0,
              ),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: (thumbRadius ?? 12.0) + 8.0,
              ),
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
              activeTickMarkColor: _getActiveColor(theme, hasError),
              inactiveTickMarkColor: _getInactiveColor(theme, hasError),
              showValueIndicator: label != null 
                ? ShowValueIndicator.onlyForContinuous 
                : ShowValueIndicator.never,
            ),
            child: Slider(
              value: value.clamp(min, max),
              onChanged: isEnabled ? onChanged : null,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
              min: min,
              max: max,
              divisions: divisions,
              label: label,
              semanticFormatterCallback: semanticFormatterCallback != null
                ? (double value) => semanticFormatterCallback!
                : null,
            ),
          ),
          if (helperText != null || errorText != null) ...[
            SizedBox(height: theme.spacing.xs),
            AtomicText.bodySmall(
              errorText ?? helperText!,
              style: TextStyle(
                color: hasError 
                  ? theme.colors.error 
                  : theme.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getActiveColor(AtomicThemeData theme, bool hasError) {
    if (!enabled) return theme.colors.gray300;
    if (hasError) return theme.colors.error;
    return activeColor ?? theme.colors.primary;
  }

  Color _getInactiveColor(AtomicThemeData theme, bool hasError) {
    if (!enabled) return theme.colors.gray200;
    if (hasError) return theme.colors.error.withValues(alpha: 0.3);
    return inactiveColor ?? theme.colors.gray300;
  }

  Color _getThumbColor(AtomicThemeData theme, bool hasError) {
    if (!enabled) return theme.colors.gray400;
    if (hasError) return theme.colors.error;
    return thumbColor ?? theme.colors.primary;
  }
}

class AtomicRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels? labels;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double? thumbRadius;
  final String? helperText;
  final String? errorText;
  final EdgeInsetsGeometry? margin;

  const AtomicRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.helperText,
    this.errorText,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final isEnabled = enabled && onChanged != null;
    final hasError = errorText != null;

    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: _getActiveColor(theme, hasError),
              inactiveTrackColor: _getInactiveColor(theme, hasError),
              thumbColor: _getThumbColor(theme, hasError),
              overlayColor: _getActiveColor(theme, hasError).withValues(alpha: 0.1),
              valueIndicatorColor: _getActiveColor(theme, hasError),
              valueIndicatorTextStyle: theme.typography.labelSmall.copyWith(
                color: theme.colors.textInverse,
              ),
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: thumbRadius ?? 12.0,
                disabledThumbRadius: thumbRadius ?? 8.0,
              ),
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: (thumbRadius ?? 12.0) + 8.0,
              ),
              rangeTickMarkShape: const RoundRangeSliderTickMarkShape(tickMarkRadius: 2.0),
              activeTickMarkColor: _getActiveColor(theme, hasError),
              inactiveTickMarkColor: _getInactiveColor(theme, hasError),
              showValueIndicator: labels != null 
                ? ShowValueIndicator.onlyForContinuous 
                : ShowValueIndicator.never,
            ),
            child: RangeSlider(
              values: RangeValues(
                values.start.clamp(min, max),
                values.end.clamp(min, max),
              ),
              onChanged: isEnabled ? onChanged : null,
              onChangeStart: onChangeStart,
              onChangeEnd: onChangeEnd,
              min: min,
              max: max,
              divisions: divisions,
              labels: labels,
            ),
          ),
          if (helperText != null || errorText != null) ...[
            SizedBox(height: theme.spacing.xs),
            AtomicText.bodySmall(
              errorText ?? helperText!,
              style: TextStyle(
                color: hasError 
                  ? theme.colors.error 
                  : theme.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getActiveColor(AtomicThemeData theme, bool hasError) {
    if (!enabled) return theme.colors.gray300;
    if (hasError) return theme.colors.error;
    return activeColor ?? theme.colors.primary;
  }

  Color _getInactiveColor(AtomicThemeData theme, bool hasError) {
    if (!enabled) return theme.colors.gray200;
    if (hasError) return theme.colors.error.withValues(alpha: 0.3);
    return inactiveColor ?? theme.colors.gray300;
  }

  Color _getThumbColor(AtomicThemeData theme, bool hasError) {
    if (!enabled) return theme.colors.gray400;
    if (hasError) return theme.colors.error;
    return thumbColor ?? theme.colors.primary;
  }
} 