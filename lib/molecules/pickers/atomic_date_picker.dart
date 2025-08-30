import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_icon_button.dart';

/// A customizable date picker input field.
///
/// The [AtomicDatePicker] provides a text field that, when tapped, opens a
/// Material Design date picker. It supports various customization options
/// for initial date, date range, appearance, and validation.
///
/// Features:
/// - Integrates with Flutter's `showDatePicker` for date selection.
/// - Customizable initial, first, and last selectable dates.
/// - Three visual variants ([AtomicDatePickerVariant]): filled, outlined, underlined.
/// - Three predefined sizes ([AtomicDatePickerSize]): small, medium, large.
/// - Optional label, helper text, and error text.
/// - Customizable date formatting.
/// - Enabled/disabled and read-only states.
/// - Optional leading calendar icon.
///
/// Example usage:
/// ```dart
/// DateTime? _selectedDate;
/// AtomicDatePicker(
///   initialDate: DateTime.now(),
///   firstDate: DateTime(2000),
///   lastDate: DateTime(2030),
///   onDateSelected: (date) {
///     setState(() {
///       _selectedDate = date;
///     });
///     print('Selected date: $_selectedDate');
///   },
///   label: 'Select your birth date',
///   variant: AtomicDatePickerVariant.outlined,
///   size: AtomicDatePickerSize.large,
/// )
/// ```
class AtomicDatePicker extends StatefulWidget {
  /// Creates an [AtomicDatePicker] widget.
  ///
  /// [initialDate] is the date initially selected in the picker.
  /// [firstDate] is the earliest date the user can select.
  /// [lastDate] is the latest date the user can select.
  /// [onDateSelected] is the callback function executed when a date is selected.
  /// [currentDate] is the date to highlight in the picker.
  /// [initialDatePickerMode] is the initial mode of the date picker (day, year).
  /// [selectableDayPredicate] is a function that determines if a day is selectable.
  /// [helpText], [cancelText], [confirmText] customize the picker's labels.
  /// [locale] specifies the locale for the picker.
  /// [useRootNavigator] if true, the picker is pushed onto the root navigator.
  /// [routeSettings] are settings for the picker's route.
  /// [textDirection] specifies the text direction for the picker.
  /// [builder] is a builder function for the picker's theme.
  /// [initialEntryMode] is the initial entry mode of the date picker (calendar, input).
  /// [fieldHintText], [fieldLabelText], [errorFormatText], [errorInvalidText] customize text field labels and errors.
  /// [keyboardType] specifies the keyboard type for date input.
  /// [variant] defines the visual style of the input field. Defaults to [AtomicDatePickerVariant.filled].
  /// [size] defines the size of the input field. Defaults to [AtomicDatePickerSize.medium].
  /// [showIcon] if true, displays a leading calendar icon. Defaults to true.
  /// [enabled] if true, the input field is interactive. Defaults to true.
  /// [readOnly] if true, the input field cannot be edited directly. Defaults to false.
  /// [label] is the text label for the input field.
  /// [helperText] is an optional helper text displayed below the input field.
  /// [errorText] is an optional error text displayed below the input field.
  /// [dateFormat] is a function to format the selected date for display.
  const AtomicDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.currentDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.selectableDayPredicate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.locale,
    this.useRootNavigator = true,
    this.routeSettings,
    this.textDirection,
    this.builder,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.fieldHintText,
    this.fieldLabelText,
    this.errorFormatText,
    this.errorInvalidText,
    this.keyboardType,
    this.variant = AtomicDatePickerVariant.filled,
    this.size = AtomicDatePickerSize.medium,
    this.showIcon = true,
    this.enabled = true,
    this.readOnly = false,
    this.label,
    this.helperText,
    this.errorText,
    this.dateFormat,
  });

  /// The date initially selected in the picker.
  final DateTime? initialDate;

  /// The earliest date the user can select.
  final DateTime? firstDate;

  /// The latest date the user can select.
  final DateTime? lastDate;

  /// The callback function executed when a date is selected.
  final ValueChanged<DateTime?>? onDateSelected;

  /// The date to highlight in the picker.
  final DateTime? currentDate;

  /// The initial mode of the date picker (day, year).
  final DatePickerMode initialDatePickerMode;

  /// A function that determines if a day is selectable.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The help text displayed in the picker.
  final String? helpText;

  /// The text for the cancel button in the picker.
  final String? cancelText;

  /// The text for the confirm button in the picker.
  final String? confirmText;

  /// The locale for the picker.
  final Locale? locale;

  /// If true, the picker is pushed onto the root navigator.
  final bool useRootNavigator;

  /// Settings for the picker's route.
  final RouteSettings? routeSettings;

  /// The text direction for the picker.
  final TextDirection? textDirection;

  /// A builder function for the picker's theme.
  final TransitionBuilder? builder;

  /// The initial entry mode of the date picker (calendar, input).
  final DatePickerEntryMode initialEntryMode;

  /// The hint text for the date input field.
  final String? fieldHintText;

  /// The label text for the date input field.
  final String? fieldLabelText;

  /// The error text for invalid date format.
  final String? errorFormatText;

  /// The error text for invalid date.
  final String? errorInvalidText;

  /// The keyboard type for date input.
  final TextInputType? keyboardType;

  /// Defines the visual style of the input field. Defaults to [AtomicDatePickerVariant.filled].
  final AtomicDatePickerVariant variant;

  /// Defines the size of the input field. Defaults to [AtomicDatePickerSize.medium].
  final AtomicDatePickerSize size;

  /// If true, displays a leading calendar icon. Defaults to true.
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

  /// A function to format the selected date for display.
  final String Function(DateTime)? dateFormat;

  @override
  State<AtomicDatePicker> createState() => _AtomicDatePickerState();
}

class _AtomicDatePickerState extends State<AtomicDatePicker> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null ? _formatDate(_selectedDate!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AtomicDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
      _controller.text =
          _selectedDate != null ? _formatDate(_selectedDate!) : '';
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
          onTap: widget.enabled && !widget.readOnly ? _showDatePicker : null,
          borderRadius: _getBorderRadius(theme),
          child: Container(
            height: _getHeight(),
            padding: _getPadding(theme),
            decoration: _getDecoration(theme),
            child: Row(
              children: [
                if (widget.showIcon) ...[
                  AtomicIconButton(
                    icon: Icons.calendar_today,
                    onPressed: widget.enabled && !widget.readOnly
                        ? _showDatePicker
                        : null,
                    variant: AtomicIconButtonVariant.ghost,
                    size: _getIconSize(),
                  ),
                  SizedBox(width: theme.spacing.sm),
                ],
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled:
                        false, // Always disabled since we use the date picker
                    style: _getTextStyle(theme),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.fieldHintText ?? 'Select date',
                      hintStyle: _getHintTextStyle(theme),
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

  Future<void> _showDatePicker() async {
    final theme = AtomicTheme.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.currentDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      currentDate: widget.currentDate,
      initialDatePickerMode: widget.initialDatePickerMode,
      selectableDayPredicate: widget.selectableDayPredicate,
      helpText: widget.helpText,
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      locale: widget.locale,
      useRootNavigator: widget.useRootNavigator,
      routeSettings: widget.routeSettings,
      textDirection: widget.textDirection,
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
              ),
              child: child!,
            );
          },
      initialEntryMode: widget.initialEntryMode,
      fieldHintText: widget.fieldHintText,
      fieldLabelText: widget.fieldLabelText,
      errorFormatText: widget.errorFormatText,
      errorInvalidText: widget.errorInvalidText,
      keyboardType: widget.keyboardType,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  String _formatDate(DateTime date) {
    if (widget.dateFormat != null) {
      return widget.dateFormat!(date);
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  double _getHeight() {
    switch (widget.size) {
      case AtomicDatePickerSize.small:
        return 40;
      case AtomicDatePickerSize.medium:
        return 48;
      case AtomicDatePickerSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding(AtomicThemeData theme) {
    switch (widget.size) {
      case AtomicDatePickerSize.small:
        return EdgeInsets.symmetric(horizontal: theme.spacing.sm);
      case AtomicDatePickerSize.medium:
        return EdgeInsets.symmetric(horizontal: theme.spacing.md);
      case AtomicDatePickerSize.large:
        return EdgeInsets.symmetric(horizontal: theme.spacing.lg);
    }
  }

  AtomicIconButtonSize _getIconSize() {
    switch (widget.size) {
      case AtomicDatePickerSize.small:
        return AtomicIconButtonSize.small;
      case AtomicDatePickerSize.medium:
        return AtomicIconButtonSize.medium;
      case AtomicDatePickerSize.large:
        return AtomicIconButtonSize.large;
    }
  }

  BorderRadius _getBorderRadius(AtomicThemeData theme) {
    switch (widget.variant) {
      case AtomicDatePickerVariant.filled:
      case AtomicDatePickerVariant.outlined:
        return AtomicBorders.md;
      case AtomicDatePickerVariant.underlined:
        return BorderRadius.zero;
    }
  }

  BoxDecoration _getDecoration(AtomicThemeData theme) {
    switch (widget.variant) {
      case AtomicDatePickerVariant.filled:
        return BoxDecoration(
          color: widget.enabled
              ? theme.colors.surface
              : theme.colors.surface.withValues(alpha: 0.5),
          borderRadius: _getBorderRadius(theme),
          border: widget.errorText != null
              ? Border.all(color: theme.colors.error, width: 2)
              : null,
        );
      case AtomicDatePickerVariant.outlined:
        return BoxDecoration(
          color: theme.colors.background,
          borderRadius: _getBorderRadius(theme),
          border: Border.all(
            color: widget.errorText != null
                ? theme.colors.error
                : widget.enabled
                    ? AtomicColors.dividerColor
                    : AtomicColors.dividerColor.withValues(alpha: 0.5),
            width: widget.errorText != null ? 2 : 1,
          ),
        );
      case AtomicDatePickerVariant.underlined:
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

  TextStyle _getTextStyle(AtomicThemeData theme) {
    final baseStyle = theme.typography.bodyMedium.copyWith(
      color: widget.enabled
          ? theme.colors.textPrimary
          : theme.colors.textPrimary.withValues(alpha: 0.5),
    );

    switch (widget.size) {
      case AtomicDatePickerSize.small:
        return baseStyle.copyWith(fontSize: 14);
      case AtomicDatePickerSize.medium:
        return baseStyle;
      case AtomicDatePickerSize.large:
        return baseStyle.copyWith(fontSize: 16);
    }
  }

  TextStyle _getHintTextStyle(AtomicThemeData theme) {
    final baseStyle = theme.typography.bodyMedium.copyWith(
      color: theme.colors.textSecondary,
    );

    switch (widget.size) {
      case AtomicDatePickerSize.small:
        return baseStyle.copyWith(fontSize: 14);
      case AtomicDatePickerSize.medium:
        return baseStyle;
      case AtomicDatePickerSize.large:
        return baseStyle.copyWith(fontSize: 16);
    }
  }
}

/// Defines the visual variants for an [AtomicDatePicker].
enum AtomicDatePickerVariant {
  /// A date picker with a filled background.
  filled,

  /// A date picker with an outlined border.
  outlined,

  /// A date picker with only a bottom underline.
  underlined,
}

/// Defines the predefined sizes for an [AtomicDatePicker].
enum AtomicDatePickerSize {
  /// A small date picker.
  small,

  /// A medium-sized date picker.
  medium,

  /// A large date picker.
  large,
}

/// A simplified date picker component for common use cases.
///
/// The [AtomicSimpleDatePicker] provides a basic date picker input field
/// with a label and hint text. It's a convenient wrapper around [AtomicDatePicker]
/// for quick setup.
///
/// Example usage:
/// ```dart
/// AtomicSimpleDatePicker(
///   initialDate: DateTime.now(),
///   onDateSelected: (date) {
///     print('Selected simple date: $date');
///   },
///   label: 'Event Date',
///   hintText: 'Choose a date for the event',
/// )
/// ```
class AtomicSimpleDatePicker extends StatelessWidget {
  /// Creates an [AtomicSimpleDatePicker] widget.
  ///
  /// [onDateSelected] is the callback function executed when a date is selected.
  /// [initialDate] is the date initially selected.
  /// [label] is the text label for the input field.
  /// [hintText] is the hint text displayed in the input field. Defaults to 'Select date'.
  /// [enabled] if true, the input field is interactive. Defaults to true.
  const AtomicSimpleDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    this.label,
    this.hintText = 'Select date',
    this.enabled = true,
  });

  /// The callback function executed when a date is selected.
  final ValueChanged<DateTime?> onDateSelected;

  /// The date initially selected in the picker.
  final DateTime? initialDate;

  /// The text label for the input field.
  final String? label;

  /// The hint text displayed in the input field. Defaults to 'Select date'.
  final String hintText;

  /// If true, the input field is interactive. Defaults to true.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AtomicDatePicker(
      initialDate: initialDate,
      onDateSelected: onDateSelected,
      label: label,
      fieldHintText: hintText,
      enabled: enabled,
    );
  }
}

/// A date range picker component for selecting a start and end date.
///
/// The [AtomicDateRangePicker] provides two linked date picker input fields
/// for selecting a date range. It ensures that the end date is not before
/// the start date and provides a single callback for the selected range.
///
/// Features:
/// - Two linked date pickers for start and end dates.
/// - Customizable labels for start and end date fields.
/// - Customizable initial, first, and last selectable dates.
/// - Enabled/disabled states.
/// - Provides a single [DateTimeRange] in the callback.
///
/// Example usage:
/// ```dart
/// DateTimeRange? _selectedRange;
/// AtomicDateRangePicker(
///   onDateRangeSelected: (range) {
///     setState(() {
///       _selectedRange = range;
///     });
///     print('Selected range: $_selectedRange');
///   },
///   initialStartDate: DateTime.now(),
///   initialEndDate: DateTime.now().add(Duration(days: 7)),
///   startLabel: 'Check-in Date',
///   endLabel: 'Check-out Date',
/// )
/// ```
class AtomicDateRangePicker extends StatefulWidget {
  /// Creates an [AtomicDateRangePicker] widget.
  ///
  /// [onDateRangeSelected] is the callback function executed when a date range is selected.
  /// [initialStartDate] is the initially selected start date.
  /// [initialEndDate] is the initially selected end date.
  /// [firstDate] is the earliest date the user can select.
  /// [lastDate] is the latest date the user can select.
  /// [startLabel] is the label for the start date field. Defaults to 'Start Date'.
  /// [endLabel] is the label for the end date field. Defaults to 'End Date'.
  /// [enabled] if true, the date pickers are interactive. Defaults to true.
  const AtomicDateRangePicker({
    super.key,
    required this.onDateRangeSelected,
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
    this.startLabel = 'Start Date',
    this.endLabel = 'End Date',
    this.enabled = true,
  });

  /// The callback function executed when a date range is selected.
  final ValueChanged<DateTimeRange?> onDateRangeSelected;

  /// The initially selected start date.
  final DateTime? initialStartDate;

  /// The initially selected end date.
  final DateTime? initialEndDate;

  /// The earliest date the user can select.
  final DateTime? firstDate;

  /// The latest date the user can select.
  final DateTime? lastDate;

  /// The label for the start date field. Defaults to 'Start Date'.
  final String startLabel;

  /// The label for the end date field. Defaults to 'End Date'.
  final String endLabel;

  /// If true, the date pickers are interactive. Defaults to true.
  final bool enabled;

  @override
  State<AtomicDateRangePicker> createState() => _AtomicDateRangePickerState();
}

class _AtomicDateRangePickerState extends State<AtomicDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Column(
      children: [
        AtomicDatePicker(
          initialDate: _startDate,
          firstDate: widget.firstDate,
          lastDate: _endDate ?? widget.lastDate,
          label: widget.startLabel,
          onDateSelected: (date) {
            setState(() {
              _startDate = date;
              if (_endDate != null &&
                  date != null &&
                  _endDate!.isBefore(date)) {
                _endDate = null;
              }
            });
            _updateRange();
          },
          enabled: widget.enabled,
        ),
        SizedBox(height: theme.spacing.md),
        AtomicDatePicker(
          initialDate: _endDate,
          firstDate: _startDate ?? widget.firstDate,
          lastDate: widget.lastDate,
          label: widget.endLabel,
          onDateSelected: (date) {
            setState(() {
              _endDate = date;
            });
            _updateRange();
          },
          enabled: widget.enabled && _startDate != null,
        ),
      ],
    );
  }

  void _updateRange() {
    if (_startDate != null && _endDate != null) {
      widget.onDateRangeSelected(DateTimeRange(
        start: _startDate!,
        end: _endDate!,
      ));
    } else {
      widget.onDateRangeSelected(null);
    }
  }
}
