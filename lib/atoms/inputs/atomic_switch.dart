import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

class AtomicSwitch extends StatefulWidget {
  const AtomicSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeIcon,
    this.inactiveIcon,
    this.label,
    this.labelPosition = AtomicSwitchLabelPosition.end,
    this.size = AtomicSwitchSize.medium,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final String? label;
  final AtomicSwitchLabelPosition labelPosition;
  final AtomicSwitchSize size;
  final bool enabled;

  @override
  State<AtomicSwitch> createState() => _AtomicSwitchState();
}

class _AtomicSwitchState extends State<AtomicSwitch> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AtomicAnimations.fast,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
    _positionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AtomicAnimations.standardEasing,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(AtomicSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final trackWidth = _getTrackWidth();
    final trackHeight = _getTrackHeight();
    final thumbSize = _getThumbSize();

    Widget switchWidget = GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: trackWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(trackHeight / 2),
              color: _getTrackColor(theme),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: AtomicAnimations.fast,
                  curve: AtomicAnimations.standardEasing,
                  left: _positionAnimation.value * (trackWidth - thumbSize - 4) + 2,
                  top: (trackHeight - thumbSize) / 2,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getThumbColor(theme),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _buildThumbIcon(theme),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (widget.label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.labelPosition == AtomicSwitchLabelPosition.start) ...[
            Text(
              widget.label!,
              style: theme.typography.bodyMedium.copyWith(
                color: widget.enabled 
                  ? theme.colors.textPrimary 
                  : theme.colors.textDisabled,
              ),
            ),
            SizedBox(width: theme.spacing.sm),
          ],
          switchWidget,
          if (widget.labelPosition == AtomicSwitchLabelPosition.end) ...[
            SizedBox(width: theme.spacing.sm),
            Text(
              widget.label!,
              style: theme.typography.bodyMedium.copyWith(
                color: widget.enabled 
                  ? theme.colors.textPrimary 
                  : theme.colors.textDisabled,
              ),
            ),
          ],
        ],
      );
    }

    return switchWidget;
  }

  Widget? _buildThumbIcon(AtomicThemeData theme) {
    final icon = widget.value ? widget.activeIcon : widget.inactiveIcon;
    if (icon == null) return null;

    return Center(
      child: Icon(
        icon,
        size: _getIconSize(),
        color: widget.value 
          ? theme.colors.primary 
          : theme.colors.textTertiary,
      ),
    );
  }

  double _getTrackWidth() {
    switch (widget.size) {
      case AtomicSwitchSize.small:
        return 40;
      case AtomicSwitchSize.medium:
        return 52;
      case AtomicSwitchSize.large:
        return 64;
    }
  }

  double _getTrackHeight() {
    switch (widget.size) {
      case AtomicSwitchSize.small:
        return 24;
      case AtomicSwitchSize.medium:
        return 32;
      case AtomicSwitchSize.large:
        return 40;
    }
  }

  double _getThumbSize() {
    switch (widget.size) {
      case AtomicSwitchSize.small:
        return 20;
      case AtomicSwitchSize.medium:
        return 28;
      case AtomicSwitchSize.large:
        return 36;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AtomicSwitchSize.small:
        return 10;
      case AtomicSwitchSize.medium:
        return 14;
      case AtomicSwitchSize.large:
        return 18;
    }
  }

  Color _getTrackColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.gray200;
    }

    if (widget.value) {
      return widget.activeTrackColor ?? theme.colors.primary.withValues(alpha: 0.2);
    } else {
      return widget.inactiveTrackColor ?? theme.colors.gray300;
    }
  }

  Color _getThumbColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.gray400;
    }

    if (widget.value) {
      return widget.activeColor ?? theme.colors.primary;
    } else {
      return widget.inactiveColor ?? theme.colors.surface;
    }
  }
}

enum AtomicSwitchSize {
  small,
  medium,
  large,
}

enum AtomicSwitchLabelPosition {
  start,
  end,
} 