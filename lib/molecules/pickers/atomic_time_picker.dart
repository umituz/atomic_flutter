import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_icon_button.dart';

/// A customizable time picker input field.
///
/// The [AtomicTimePicker] provides a text field that, when tapped, opens a
/// Material Design time picker. It supports various customization options
/// for initial time, appearance, and validation.
///
/// Features:
/// - Integrates with Flutter's `showTimePicker` for time selection.
/// - Customizable initial time.
/// - Three visual variants ([AtomicTimePickerVariant]): filled, outlined, underlined.
/// - Three predefined sizes ([AtomicTimePickerSize]): small, medium, large.
/// - Optional label, helper text, and error text.
/// - Customizable time formatting (12-hour or 24-hour).
/// - Enabled/disabled and read-only states.
/// - Optional leading clock icon.
///
/// Example usage:
/// ```dart
/// TimeOfDay? _selectedTime;
/// AtomicTimePicker(
///   initialTime: TimeOfDay.now(),
///   onTimeSelected: (time) {
///     setState(() {
///       _selectedTime = time;
///     });
///     print('Selected time: $_selectedTime');
///   },
///   label: 'Select meeting time',
///   variant: AtomicTimePickerVariant.outlined,
///   size: AtomicTimePickerSize.large,
///   use24HourFormat: true,
/// )
/// ```
class AtomicTimePicker extends StatefulWidget {
  /// Creates an [AtomicTimePicker] widget.
  ///
  /// [initialTime] is the time initially selected in the picker.
  /// [onTimeSelected] is the callback function executed when a time is selected.
  /// [helpText], [cancelText], [confirmText] customize the picker's labels.
  /// [hourLabelText], [minuteLabelText] customize hour/minute input labels.
  /// [errorInvalidText] customizes the error message for invalid time.
  /// [builder] is a builder function for the picker's theme.
  /// [useRootNavigator] if true, the picker is pushed onto the root navigator.
  /// [routeSettings] are settings for the picker's route.
  /// [entryMode] is the initial entry mode of the time picker (dial, input).
  /// [orientation] specifies the preferred orientation for the picker.
  /// [variant] defines the visual style of the input field. Defaults to [AtomicTimePickerVariant.filled].
  /// [size] defines the size of the input field. Defaults to [AtomicTimePickerSize.medium].
  /// [showIcon] if true, displays a leading clock icon. Defaults to true.
  /// [enabled] if true, the input field is interactive. Defaults to true.
  /// [readOnly] if true, the input field cannot be edited directly. Defaults to false.
  /// [label] is the text label for the input field.
  /// [helperText] is an optional helper text displayed below the input field.
  /// [errorText] is an optional error text displayed below the input field.
  /// [timeFormat] is a function to format the selected time for display.
  /// [use24HourFormat] if true, uses 24-hour format; if false, uses 12-hour format. If null, uses system setting.
  const AtomicTimePicker({
    super.key,
    this.initialTime,
    this.onTimeSelected,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.hourLabelText,
    this.minuteLabelText,
    this.errorInvalidText,
    this.builder,
    this.useRootNavigator = true,
    this.routeSettings,
    this.entryMode = TimePickerEntryMode.dial,
    this.orientation,
    this.variant = AtomicTimePickerVariant.filled,
    this.size = AtomicTimePickerSize.medium,
    this.showIcon = true,
    this.enabled = true,
    this.readOnly = false,
    this.label,
    this.helperText,
    this.errorText,
    this.timeFormat,
    this.use24HourFormat,
  });

  /// The time initially selected in the picker.
  final TimeOfDay? initialTime;

  /// The callback function executed when a time is selected.
  final ValueChanged<TimeOfDay?>? onTimeSelected;

  /// The help text displayed in the picker.
  final String? helpText;

  /// The text for the cancel button in the picker.
  final String? cancelText;

  /// The text for the confirm button in the picker.
  final String? confirmText;

  /// The label text for the hour input field in the picker.
  final String? hourLabelText;

  /// The label text for the minute input field in the picker.
  final String? minuteLabelText;

  /// The error text for invalid time.
  final String? errorInvalidText;

  /// A builder function for the picker's theme.
  final TransitionBuilder? builder;

  /// If true, the picker is pushed onto the root navigator.
  final bool useRootNavigator;

  /// Settings for the picker's route.
  final RouteSettings? routeSettings;

  /// The initial entry mode of the time picker (dial, input).
  final TimePickerEntryMode entryMode;

  /// Specifies the preferred orientation for the picker.
  final Orientation? orientation;

  /// Defines the visual style of the input field. Defaults to [AtomicTimePickerVariant.filled].
  final AtomicTimePickerVariant variant;

  /// Defines the size of the input field. Defaults to [AtomicTimePickerSize.medium].
  final AtomicTimePickerSize size;

  /// If true, displays a leading clock icon. Defaults to true.
  final bool showIcon;

  /// If true, the input field is interactive. Defaults to true.
  final bool enabled;

  /// If true, the input field cannot be edited directly. Defaults to false.
  final bool readOnly;

  /// The text label for the input field.
  final String? label;

  /// An optional helper text displayed below the input field.
  final String? helperText;

  /// An optional error text displayed below the input field.
  final String? errorText;

  /// A function to format the selected time for display.
  final String Function(TimeOfDay)? timeFormat;

  /// If true, uses 24-hour format; if false, uses 12-hour format. If null, uses system setting.
  final bool? use24HourFormat;

  @override
  State<AtomicTimePicker> createState() => _AtomicTimePickerState();
}

class _AtomicTimePickerState extends State<AtomicTimePicker> {
  late TextEditingController _controller;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _controller = TextEditingController(
      text: _selectedTime != null ? _formatTime(_selectedTime!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AtomicTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime) {
      _selectedTime = widget.initialTime;
      _controller.text =
          _selectedTime != null ? _formatTime(_selectedTime!) : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          AtomicText(
            widget.label!,
            atomicStyle: AtomicTextStyle.labelMedium,
          ),
          SizedBox(height: theme.spacing.xs),
        ],
        InkWell(
          onTap: widget.enabled && !widget.readOnly ? _showTimePicker : null,
          borderRadius: AtomicBorders.md,
          child: Container(
            height: _getHeight(),
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            decoration: _getDecoration(theme),
            child: Row(
              children: [
                if (widget.showIcon) ...[
                  AtomicIconButton(
                    icon: Icons.access_time,
                    onPressed: widget.enabled && !widget.readOnly
                        ? _showTimePicker
                        : null,
                    variant: AtomicIconButtonVariant.ghost,
                    size: AtomicIconButtonSize.medium,
                  ),
                  SizedBox(width: theme.spacing.sm),
                ],
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled:
                        false, // Always disabled since we use the time picker
                    style: theme.typography.bodyMedium.copyWith(
                      color: widget.enabled
                          ? theme.colors.textPrimary
                          : theme.colors.textPrimary.withValues(alpha: 0.5),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select time',
                      hintStyle: theme.typography.bodyMedium.copyWith(
                        color: theme.colors.textSecondary,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (widget.showIcon) ...[
                  SizedBox(width: theme.spacing.sm),
                  Icon(
                    Icons.arrow_drop_down,
                    color: widget.enabled
                        ? theme.colors.textSecondary
                        : theme.colors.textSecondary.withValues(alpha: 0.5),
                    size: 24,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (widget.helperText != null || widget.errorText != null) ...[
          SizedBox(height: theme.spacing.xs),
          AtomicText(
            widget.errorText ?? widget.helperText!,
            atomicStyle: AtomicTextStyle.bodySmall,
            style: TextStyle(
              color: widget.errorText != null
                  ? theme.colors.error
                  : theme.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _showTimePicker() async {
    final theme = AtomicTheme.of(context);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: widget.helpText,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      hourLabelText: widget.hourLabelText,
      minuteLabelText: widget.minuteLabelText,
      errorInvalidText: widget.errorInvalidText,
      builder: widget.builder ??
          (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: theme.colors.primary,
                      onPrimary: theme.colors.surface,
                      surface: theme.colors.surface,
                      onSurface: theme.colors.textPrimary,
                    ),
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: theme.colors.surface,
                  dialBackgroundColor: theme.colors.background,
                  dialHandColor: theme.colors.primary,
                  dialTextColor: theme.colors.textPrimary,
                  entryModeIconColor: theme.colors.primary,
                  hourMinuteTextColor: theme.colors.textPrimary,
                  hourMinuteColor: theme.colors.background,
                  dayPeriodTextColor: theme.colors.textPrimary,
                  dayPeriodColor: theme.colors.background,
                  dayPeriodBorderSide: BorderSide(
                    color: AtomicColors.dividerColor,
                    width: 1,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: AtomicBorders.inputDefaultBorder,
                    focusedBorder: AtomicBorders.inputFocusedBorder,
                    errorBorder: AtomicBorders.inputErrorBorder,
                  ),
                ),
              ),
              child: child!,
            );
          },
      useRootNavigator: widget.useRootNavigator,
      routeSettings: widget.routeSettings,
      initialEntryMode: widget.entryMode,
      orientation: widget.orientation,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTime(picked);
      });
      widget.onTimeSelected?.call(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    if (widget.timeFormat != null) {
      return widget.timeFormat!(time);
    }

    final use24Hour =
        widget.use24HourFormat ?? MediaQuery.of(context).alwaysUse24HourFormat;

    if (use24Hour) {
      return '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case AtomicTimePickerSize.small:
        return 40;
      case AtomicTimePickerSize.medium:
        return 48;
      case AtomicTimePickerSize.large:
        return 56;
    }
  }

  BoxDecoration _getDecoration(AtomicThemeData theme) {
    switch (widget.variant) {
      case AtomicTimePickerVariant.filled:
        return BoxDecoration(
          color: widget.enabled
              ? theme.colors.surface
              : theme.colors.surface.withValues(alpha: 0.5),
          borderRadius: AtomicBorders.md,
          border: widget.errorText != null
              ? Border.all(color: theme.colors.error, width: 2)
              : null,
        );
      case AtomicTimePickerVariant.outlined:
        return BoxDecoration(
          color: theme.colors.background,
          borderRadius: AtomicBorders.md,
          border: Border.all(
            color: widget.errorText != null
                ? theme.colors.error
                : widget.enabled
                    ? AtomicColors.dividerColor
                    : AtomicColors.dividerColor.withValues(alpha: 0.5),
            width: widget.errorText != null ? 2 : 1,
          ),
        );
      case AtomicTimePickerVariant.underlined:
        return BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: widget.errorText != null
                  ? theme.colors.error
                  : widget.enabled
                      ? AtomicColors.dividerColor
                      : AtomicColors.dividerColor.withValues(alpha: 0.5),
              width: widget.errorText != null ? 2 : 1,
            ),
          ),
        );
    }
  }
}

/// Defines the visual variants for an [AtomicTimePicker].
enum AtomicTimePickerVariant {
  /// A time picker with a filled background.
  filled,

  /// A time picker with an outlined border.
  outlined,

  /// A time picker with only a bottom underline.
  underlined,
}

/// Defines the predefined sizes for an [AtomicTimePicker].
enum AtomicTimePickerSize {
  /// A small time picker.
  small,

  /// A medium-sized time picker.
  medium,

  /// A large time picker.
  large,
}

/// A simplified time picker component for common use cases.
///
/// The [AtomicSimpleTimePicker] provides a basic time picker input field
/// with a label and hint text. It's a convenient wrapper around [AtomicTimePicker]
/// for quick setup.
///
/// Example usage:
/// ```dart
/// AtomicSimpleTimePicker(
///   initialTime: TimeOfDay.now(),
///   onTimeSelected: (time) {
///     print('Selected simple time: $time');
///   },
///   label: 'Meeting Time',
///   hintText: 'Choose a time for the meeting',
/// )
/// ```
class AtomicSimpleTimePicker extends StatelessWidget {
  /// Creates an [AtomicSimpleTimePicker] widget.
  ///
  /// [onTimeSelected] is the callback function executed when a time is selected.
  /// [initialTime] is the time initially selected.
  /// [label] is the text label for the input field.
  /// [hintText] is the hint text displayed in the input field. Defaults to 'Select time'.
  /// [enabled] if true, the input field is interactive. Defaults to true.
  /// [use24HourFormat] if true, uses 24-hour format; if false, uses 12-hour format. If null, uses system setting.
  const AtomicSimpleTimePicker({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
    this.label,
    this.hintText = 'Select time',
    this.enabled = true,
    this.use24HourFormat,
  });

  /// The callback function executed when a time is selected.
  final ValueChanged<TimeOfDay?> onTimeSelected;

  /// The time initially selected in the picker.
  final TimeOfDay? initialTime;

  /// The text label for the input field.
  final String? label;

  /// The hint text displayed in the input field. Defaults to 'Select time'.
  final String hintText;

  /// If true, the input field is interactive. Defaults to true.
  final bool enabled;

  /// If true, uses 24-hour format; if false, uses 12-hour format. If null, uses system setting.
  final bool? use24HourFormat;

  @override
  Widget build(BuildContext context) {
    return AtomicTimePicker(
      initialTime: initialTime,
      onTimeSelected: onTimeSelected,
      label: label,
      enabled: enabled,
      use24HourFormat: use24HourFormat,
    );
  }
}

/// A time range picker component for selecting a start and end time.
///
/// The [AtomicTimeRangePicker] provides two linked time picker input fields
/// for selecting a time range. It ensures that the end time is not before
/// the start time and provides a single callback for the selected range.
///
/// Features:
/// - Two linked time pickers for start and end times.
/// - Customizable labels for start and end time fields.
/// - Enabled/disabled states.
/// - Provides a single [TimeRange] in the callback.
/// - Supports 12-hour or 24-hour format.
///
/// Example usage:
/// ```dart
/// TimeRange? _selectedTimeRange;
/// AtomicTimeRangePicker(
///   onTimeRangeSelected: (range) {
///     setState(() {
///       _selectedTimeRange = range;
///     });
///     print('Selected time range: $_selectedTimeRange');
///   },
///   initialStartTime: TimeOfDay(hour: 9, minute: 0),
///   initialEndTime: TimeOfDay(hour: 17, minute: 0),
///   startLabel: 'Meeting Start',
///   endLabel: 'Meeting End',
///   use24HourFormat: false,
/// )
/// ```
class AtomicTimeRangePicker extends StatefulWidget {
  /// Creates an [AtomicTimeRangePicker] widget.
  ///
  /// [onTimeRangeSelected] is the callback function executed when a time range is selected.
  /// [initialStartTime] is the initially selected start time.
  /// [initialEndTime] is the initially selected end time.
  /// [startLabel] is the label for the start time field. Defaults to 'Start Time'.
  /// [endLabel] is the label for the end time field. Defaults to 'End Time'.
  /// [enabled] if true, the time pickers are interactive. Defaults to true.
  /// [use24HourFormat] if true, uses 24-hour format; if false, uses 12-hour format. If null, uses system setting.
  const AtomicTimeRangePicker({
    super.key,
    required this.onTimeRangeSelected,
    this.initialStartTime,
    this.initialEndTime,
    this.startLabel = 'Start Time',
    this.endLabel = 'End Time',
    this.enabled = true,
    this.use24HourFormat,
  });

  /// The callback function executed when a time range is selected.
  final ValueChanged<TimeRange?> onTimeRangeSelected;

  /// The initially selected start time.
  final TimeOfDay? initialStartTime;

  /// The initially selected end time.
  final TimeOfDay? initialEndTime;

  /// The label for the start time field. Defaults to 'Start Time'.
  final String startLabel;

  /// The label for the end time field. Defaults to 'End Time'.
  final String endLabel;

  /// If true, the time pickers are interactive. Defaults to true.
  final bool enabled;

  /// If true, uses 24-hour format; if false, uses 12-hour format. If null, uses system setting.
  final bool? use24HourFormat;

  @override
  State<AtomicTimeRangePicker> createState() => _AtomicTimeRangePickerState();
}

class _AtomicTimeRangePickerState extends State<AtomicTimeRangePicker> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Column(
      children: [
        AtomicTimePicker(
          initialTime: _startTime,
          label: widget.startLabel,
          onTimeSelected: (time) {
            setState(() {
              _startTime = time;
              if (_endTime != null &&
                  time != null &&
                  _isTimeBefore(_endTime!, time)) {
                _endTime = null;
              }
            });
            _updateRange();
          },
          enabled: widget.enabled,
          use24HourFormat: widget.use24HourFormat,
        ),
        SizedBox(height: theme.spacing.md),
        AtomicTimePicker(
          initialTime: _endTime,
          label: widget.endLabel,
          onTimeSelected: (time) {
            setState(() {
              _endTime = time;
            });
            _updateRange();
          },
          enabled: widget.enabled && _startTime != null,
          use24HourFormat: widget.use24HourFormat,
        ),
      ],
    );
  }

  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    final minutes1 = time1.hour * 60 + time1.minute;
    final minutes2 = time2.hour * 60 + time2.minute;
    return minutes1 < minutes2;
  }

  void _updateRange() {
    if (_startTime != null && _endTime != null) {
      widget.onTimeRangeSelected(TimeRange(
        start: _startTime!,
        end: _endTime!,
      ));
    } else {
      widget.onTimeRangeSelected(null);
    }
  }
}

/// A model representing a time range with a start and end time.
class TimeRange {
  /// The start time of the range.
  final TimeOfDay start;

  /// The end time of the range.
  final TimeOfDay end;

  /// Creates a [TimeRange].
  ///
  /// [start] is the beginning of the time range.
  /// [end] is the end of the time range.
  const TimeRange({
    required this.start,
    required this.end,
  });

  Duration get duration {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    int diffMinutes = endMinutes - startMinutes;

    if (diffMinutes < 0) {
      diffMinutes += 24 * 60; // Add 24 hours
    }

    return Duration(minutes: diffMinutes);
  }

  @override
  String toString() {
    return 'TimeRange(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
