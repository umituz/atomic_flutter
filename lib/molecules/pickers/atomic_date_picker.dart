import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/themes/atomic_theme_data.dart';
import 'package:atomic_flutter/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter/atoms/display/atomic_text.dart';
import 'package:atomic_flutter/atoms/buttons/atomic_icon_button.dart';

class AtomicDatePicker extends StatefulWidget {
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

  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onDateSelected;
  final DateTime? currentDate;
  final DatePickerMode initialDatePickerMode;
  final SelectableDayPredicate? selectableDayPredicate;

  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final Locale? locale;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final TextDirection? textDirection;
  final TransitionBuilder? builder;

  final DatePickerEntryMode initialEntryMode;
  final String? fieldHintText;
  final String? fieldLabelText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final TextInputType? keyboardType;

  final AtomicDatePickerVariant variant;
  final AtomicDatePickerSize size;
  final bool showIcon;
  final bool enabled;
  final bool readOnly;
  final String? label;
  final String? helperText;
  final String? errorText;
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
      _controller.text = _selectedDate != null ? _formatDate(_selectedDate!) : '';
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
                    onPressed: widget.enabled && !widget.readOnly ? _showDatePicker : null,
                    variant: AtomicIconButtonVariant.ghost,
                    size: _getIconSize(),
                  ),
                  SizedBox(width: theme.spacing.sm),
                ],
                
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: false, // Always disabled since we use the date picker
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
      builder: widget.builder ?? (context, child) {
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

enum AtomicDatePickerVariant {
  filled,      // Filled background
  outlined,    // Outlined border
  underlined,  // Bottom underline
}

enum AtomicDatePickerSize {
  small,       // Compact size
  medium,      // Standard size
  large,       // Large size
}

class AtomicSimpleDatePicker extends StatelessWidget {
  const AtomicSimpleDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    this.label,
    this.hintText = 'Select date',
    this.enabled = true,
  });

  final ValueChanged<DateTime?> onDateSelected;
  final DateTime? initialDate;
  final String? label;
  final String hintText;
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

class AtomicDateRangePicker extends StatefulWidget {
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

  final ValueChanged<DateTimeRange?> onDateRangeSelected;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String startLabel;
  final String endLabel;
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
              if (_endDate != null && date != null && _endDate!.isBefore(date)) {
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