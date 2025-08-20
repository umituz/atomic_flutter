import 'package:flutter/material.dart';
import 'package:atomic_flutter/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';

class AtomicIconButton extends StatefulWidget {
  const AtomicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = AtomicIconButtonVariant.ghost,
    this.size = AtomicIconButtonSize.medium,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final AtomicIconButtonVariant variant;
  final AtomicIconButtonSize size;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;
  final bool isLoading;
  final bool isDisabled;

  @override
  State<AtomicIconButton> createState() => _AtomicIconButtonState();
}

class _AtomicIconButtonState extends State<AtomicIconButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AtomicAnimations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AtomicAnimations.buttonCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isButtonEnabled => 
    widget.onPressed != null && !widget.isLoading && !widget.isDisabled;

  void _handleTapDown(TapDownDetails details) {
    if (_isButtonEnabled) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _isButtonEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: _getSize(),
              height: _getSize(),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: _getBorderRadius(),
                border: _getBorder(),
                boxShadow: _getShadow(),
              ),
              child: Center(
                child: widget.isLoading
                  ? SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_getIconColor()),
                      ),
                    )
                  : Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getIconColor(),
                    ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }

    return button;
  }

  double _getSize() {
    switch (widget.size) {
      case AtomicIconButtonSize.small:
        return 32;
      case AtomicIconButtonSize.medium:
        return 40;
      case AtomicIconButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AtomicIconButtonSize.small:
        return 16;
      case AtomicIconButtonSize.medium:
        return 20;
      case AtomicIconButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor() {
    if (!_isButtonEnabled) {
      return widget.variant == AtomicIconButtonVariant.ghost 
        ? Colors.transparent 
        : AtomicColors.gray200;
    }

    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.variant) {
      case AtomicIconButtonVariant.filled:
        return AtomicColors.primary;
      case AtomicIconButtonVariant.outlined:
      case AtomicIconButtonVariant.ghost:
        return Colors.transparent;
      case AtomicIconButtonVariant.subtle:
        return AtomicColors.primary.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    if (!_isButtonEnabled) return AtomicColors.textDisabled;
    if (widget.color != null) return widget.color!;

    switch (widget.variant) {
      case AtomicIconButtonVariant.filled:
        return AtomicColors.textInverse;
      case AtomicIconButtonVariant.outlined:
      case AtomicIconButtonVariant.ghost:
      case AtomicIconButtonVariant.subtle:
        return AtomicColors.primary;
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.variant) {
      case AtomicIconButtonVariant.filled:
      case AtomicIconButtonVariant.outlined:
      case AtomicIconButtonVariant.subtle:
        return AtomicBorders.md;
      case AtomicIconButtonVariant.ghost:
        return AtomicBorders.full;
    }
  }

  Border? _getBorder() {
    if (!_isButtonEnabled && widget.variant == AtomicIconButtonVariant.outlined) {
      return Border.all(
        color: AtomicColors.gray300,
        width: AtomicBorders.widthThin,
      );
    }

    switch (widget.variant) {
      case AtomicIconButtonVariant.outlined:
        return Border.all(
          color: AtomicColors.primary,
          width: AtomicBorders.widthThin,
        );
      default:
        return null;
    }
  }

  List<BoxShadow>? _getShadow() {
    if (!_isButtonEnabled || _isPressed) return null;
    
    switch (widget.variant) {
      case AtomicIconButtonVariant.filled:
        return AtomicShadows.sm;
      default:
        return null;
    }
  }
}

enum AtomicIconButtonVariant {
  filled,
  outlined,
  ghost,
  subtle,
}

enum AtomicIconButtonSize {
  small,
  medium,
  large,
} 