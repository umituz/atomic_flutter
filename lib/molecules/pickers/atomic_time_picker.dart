import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_icon_button.dart';

class AtomicTimePicker extends StatefulWidget {
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

  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay?>? onTimeSelected;

  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? hourLabelText;
  final String? minuteLabelText;
  final String? errorInvalidText;
  final TransitionBuilder? builder;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final TimePickerEntryMode entryMode;
  final Orientation? orientation;

  final AtomicTimePickerVariant variant;
  final AtomicTimePickerSize size;
  final bool showIcon;
  final bool enabled;
  final bool readOnly;
  final String? label;
  final String? helperText;
  final String? errorText;
  final String Function(TimeOfDay)? timeFormat;
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
      _controller.text = _selectedTime != null ? _formatTime(_selectedTime!) : '';
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
                    onPressed: widget.enabled && !widget.readOnly ? _showTimePicker : null,
                    variant: AtomicIconButtonVariant.ghost,
                    size: AtomicIconButtonSize.medium,
                  ),
                  SizedBox(width: theme.spacing.sm),
                ],
                
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: false, // Always disabled since we use the time picker
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
      builder: widget.builder ?? (context, child) {
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
    
    final use24Hour = widget.use24HourFormat ?? MediaQuery.of(context).alwaysUse24HourFormat;
    
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

enum AtomicTimePickerVariant {
  filled,      // Filled background
  outlined,    // Outlined border
  underlined,  // Bottom underline
}

enum AtomicTimePickerSize {
  small,       // Compact size
  medium,      // Standard size
  large,       // Large size
}

class AtomicSimpleTimePicker extends StatelessWidget {
  const AtomicSimpleTimePicker({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
    this.label,
    this.hintText = 'Select time',
    this.enabled = true,
    this.use24HourFormat,
  });

  final ValueChanged<TimeOfDay?> onTimeSelected;
  final TimeOfDay? initialTime;
  final String? label;
  final String hintText;
  final bool enabled;
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

class AtomicTimeRangePicker extends StatefulWidget {
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

  final ValueChanged<TimeRange?> onTimeRangeSelected;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final String startLabel;
  final String endLabel;
  final bool enabled;
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
              if (_endTime != null && time != null && _isTimeBefore(_endTime!, time)) {
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

class TimeRange {
  const TimeRange({
    required this.start,
    required this.end,
  });

  final TimeOfDay start;
  final TimeOfDay end;

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