import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/animations/atomic_animations.dart';
import '../../tokens/borders/atomic_borders.dart';

/// Atomic Checkbox Component
/// Customizable checkbox with smooth animations
class AtomicCheckbox extends StatefulWidget {
  const AtomicCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.inactiveColor,
    this.borderColor,
    this.label,
    this.labelPosition = AtomicCheckboxLabelPosition.end,
    this.size = AtomicCheckboxSize.medium,
    this.shape = AtomicCheckboxShape.rounded,
    this.enabled = true,
    this.tristate = false,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final String? label;
  final AtomicCheckboxLabelPosition labelPosition;
  final AtomicCheckboxSize size;
  final AtomicCheckboxShape shape;
  final bool enabled;
  final bool tristate;

  @override
  State<AtomicCheckbox> createState() => _AtomicCheckboxState();
}

class _AtomicCheckboxState extends State<AtomicCheckbox> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AtomicAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AtomicAnimations.bounceOut,
    ));
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AtomicAnimations.standardEasing,
    );

    if (widget.value == true) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AtomicCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value == true) {
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
      if (widget.tristate) {
        if (widget.value == null) {
          widget.onChanged!(false);
        } else if (widget.value == false) {
          widget.onChanged!(true);
        } else {
          widget.onChanged!(null);
        }
      } else {
        widget.onChanged!(widget.value != true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final size = _getSize();

    Widget checkbox = GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: AtomicAnimations.fast,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getBackgroundColor(theme),
          border: Border.all(
            color: _getBorderColor(theme),
            width: 2,
          ),
          borderRadius: _getBorderRadius(),
        ),
        child: widget.value == null
            ? _buildIndeterminate(theme)
            : AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return widget.value == true
                      ? Transform.scale(
                          scale: _scaleAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Icon(
                              Icons.check,
                              size: size * 0.7,
                              color: _getCheckColor(theme),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
      ),
    );

    if (widget.label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.labelPosition == AtomicCheckboxLabelPosition.start) ...[
            Flexible(
              child: Text(
                widget.label!,
                style: theme.typography.bodyMedium.copyWith(
                  color: widget.enabled 
                    ? theme.colors.textPrimary 
                    : theme.colors.textDisabled,
                ),
              ),
            ),
            SizedBox(width: theme.spacing.sm),
          ],
          checkbox,
          if (widget.labelPosition == AtomicCheckboxLabelPosition.end) ...[
            SizedBox(width: theme.spacing.sm),
            Flexible(
              child: Text(
                widget.label!,
                style: theme.typography.bodyMedium.copyWith(
                  color: widget.enabled 
                    ? theme.colors.textPrimary 
                    : theme.colors.textDisabled,
                ),
              ),
            ),
          ],
        ],
      );
    }

    return checkbox;
  }

  Widget _buildIndeterminate(AtomicThemeData theme) {
    return Center(
      child: Container(
        width: _getSize() * 0.6,
        height: 2,
        decoration: BoxDecoration(
          color: _getCheckColor(theme),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  double _getSize() {
    switch (widget.size) {
      case AtomicCheckboxSize.small:
        return 16;
      case AtomicCheckboxSize.medium:
        return 20;
      case AtomicCheckboxSize.large:
        return 24;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.shape) {
      case AtomicCheckboxShape.square:
        return BorderRadius.zero;
      case AtomicCheckboxShape.rounded:
        return AtomicBorders.sm;
      case AtomicCheckboxShape.circle:
        return AtomicBorders.full;
    }
  }

  Color _getBackgroundColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.gray100;
    }

    if (widget.value == true || widget.value == null) {
      return widget.activeColor ?? theme.colors.primary;
    } else {
      return widget.inactiveColor ?? Colors.transparent;
    }
  }

  Color _getBorderColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.gray300;
    }

    if (widget.value == true || widget.value == null) {
      return widget.activeColor ?? theme.colors.primary;
    } else {
      return widget.borderColor ?? theme.colors.gray400;
    }
  }

  Color _getCheckColor(AtomicThemeData theme) {
    return widget.checkColor ?? theme.colors.textInverse;
  }
}

/// Checkbox size options
enum AtomicCheckboxSize {
  small,
  medium,
  large,
}

/// Checkbox shape options
enum AtomicCheckboxShape {
  square,
  rounded,
  circle,
}

/// Checkbox label position options
enum AtomicCheckboxLabelPosition {
  start,
  end,
}
