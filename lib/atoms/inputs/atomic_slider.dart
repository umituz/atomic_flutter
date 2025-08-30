import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';

/// A customizable slider component for selecting a single value from a range.
///
/// The [AtomicSlider] provides an interactive way for users to select a value
/// by sliding a thumb along a track. It supports a continuous or discrete range
/// of values, and offers various customization options for colors, labels,
/// and error/helper texts.
///
/// Features:
/// - Supports continuous or discrete values ([divisions]).
/// - Customizable minimum ([min]) and maximum ([max]) values.
/// - Optional label for the current value.
/// - Customizable active, inactive, and thumb colors.
/// - Adjustable thumb radius.
/// - Support for helper and error texts.
/// - Enabled/disabled states.
///
/// Example usage:
/// ```dart
/// double _sliderValue = 0.5;
/// AtomicSlider(
///   value: _sliderValue,
///   onChanged: (newValue) {
///     setState(() {
///       _sliderValue = newValue;
///     });
///   },
///   min: 0.0,
///   max: 1.0,
///   divisions: 10,
///   label: _sliderValue.toStringAsFixed(1),
///   helperText: 'Select a value between 0 and 1',
/// )
/// ```
class AtomicSlider extends StatelessWidget {
  /// The current value of the slider.
  final double value;

  /// Called when the user is selecting a new value for the slider.
  final ValueChanged<double>? onChanged;

  /// Called when the user starts to select a new value for the slider.
  final ValueChanged<double>? onChangeStart;

  /// Called when the user is done selecting a new value for the slider.
  final ValueChanged<double>? onChangeEnd;

  /// The minimum value the user can select. Defaults to 0.0.
  final double min;

  /// The maximum value the user can select. Defaults to 1.0.
  final double max;

  /// The number of discrete divisions in the slider.
  /// If null, the slider is continuous.
  final int? divisions;

  /// A label for the slider's current value, displayed above the thumb.
  final String? label;

  /// A callback to format the semantic value of the slider.
  final String? semanticFormatterCallback;

  /// If true, the slider is interactive. Defaults to true.
  final bool enabled;

  /// The color of the track and thumb when the slider is active.
  final Color? activeColor;

  /// The color of the track when the slider is inactive.
  final Color? inactiveColor;

  /// The color of the thumb.
  final Color? thumbColor;

  /// The radius of the thumb.
  final double? thumbRadius;

  /// An optional helper text displayed below the slider.
  final String? helperText;

  /// An optional error text displayed below the slider.
  final String? errorText;

  /// The external margin around the slider.
  final EdgeInsetsGeometry? margin;

  /// Creates an [AtomicSlider] widget.
  ///
  /// [value] is the current value.
  /// [onChanged] is the callback when value changes.
  /// [onChangeStart] and [onChangeEnd] are callbacks for interaction start/end.
  /// [min] and [max] define the range.
  /// [divisions] makes the slider discrete.
  /// [label] displays current value.
  /// [semanticFormatterCallback] for accessibility.
  /// [enabled] controls interactivity.
  /// [activeColor], [inactiveColor], [thumbColor], [thumbRadius] customize appearance.
  /// [helperText] and [errorText] provide additional information.
  /// [margin] for external spacing.
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
              overlayColor:
                  _getActiveColor(theme, hasError).withValues(alpha: 0.1),
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
              tickMarkShape:
                  const RoundSliderTickMarkShape(tickMarkRadius: 2.0),
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
                color:
                    hasError ? theme.colors.error : theme.colors.textSecondary,
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

/// A customizable range slider component for selecting a range of values.
///
/// The [AtomicRangeSlider] allows users to select a range of values by
/// sliding two thumbs along a track. It supports a continuous or discrete
/// range of values, and offers various customization options for colors,
/// labels, and error/helper texts.
///
/// Features:
/// - Supports continuous or discrete values ([divisions]).
/// - Customizable minimum ([min]) and maximum ([max]) values.
/// - Optional labels for the start and end values.
/// - Customizable active, inactive, and thumb colors.
/// - Adjustable thumb radius.
/// - Support for helper and error texts.
/// - Enabled/disabled states.
///
/// Example usage:
/// ```dart
/// RangeValues _rangeValues = const RangeValues(0.2, 0.8);
/// AtomicRangeSlider(
///   values: _rangeValues,
///   onChanged: (newValues) {
///     setState(() {
///       _rangeValues = newValues;
///     });
///   },
///   min: 0.0,
///   max: 1.0,
///   divisions: 10,
///   labels: RangeLabels(
///     _rangeValues.start.toStringAsFixed(1),
///     _rangeValues.end.toStringAsFixed(1),
///   ),
///   helperText: 'Select a range between 0 and 1',
/// )
/// ```
class AtomicRangeSlider extends StatelessWidget {
  /// The current selected range of values.
  final RangeValues values;

  /// Called when the user is selecting a new range for the slider.
  final ValueChanged<RangeValues>? onChanged;

  /// Called when the user starts to select a new range for the slider.
  final ValueChanged<RangeValues>? onChangeStart;

  /// Called when the user is done selecting a new range for the slider.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// The minimum value the user can select. Defaults to 0.0.
  final double min;

  /// The maximum value the user can select. Defaults to 1.0.
  final double max;

  /// The number of discrete divisions in the slider.
  /// If null, the slider is continuous.
  final int? divisions;

  /// Labels for the start and end values of the range.
  final RangeLabels? labels;

  /// If true, the slider is interactive. Defaults to true.
  final bool enabled;

  /// The color of the track and thumbs when the slider is active.
  final Color? activeColor;

  /// The color of the track when the slider is inactive.
  final Color? inactiveColor;

  /// The color of the thumbs.
  final Color? thumbColor;

  /// The radius of the thumbs.
  final double? thumbRadius;

  /// An optional helper text displayed below the slider.
  final String? helperText;

  /// An optional error text displayed below the slider.
  final String? errorText;

  /// The external margin around the slider.
  final EdgeInsetsGeometry? margin;

  /// Creates an [AtomicRangeSlider] widget.
  ///
  /// [values] is the current selected range.
  /// [onChanged] is the callback when range changes.
  /// [onChangeStart] and [onChangeEnd] are callbacks for interaction start/end.
  /// [min] and [max] define the range.
  /// [divisions] makes the slider discrete.
  /// [labels] displays current range values.
  /// [enabled] controls interactivity.
  /// [activeColor], [inactiveColor], [thumbColor], [thumbRadius] customize appearance.
  /// [helperText] and [errorText] provide additional information.
  /// [margin] for external spacing.
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
              overlayColor:
                  _getActiveColor(theme, hasError).withValues(alpha: 0.1),
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
              rangeTickMarkShape:
                  const RoundRangeSliderTickMarkShape(tickMarkRadius: 2.0),
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
                color:
                    hasError ? theme.colors.error : theme.colors.textSecondary,
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
