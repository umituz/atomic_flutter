import 'dart:ui';
import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';

import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/animations/atomic_animations.dart';
import '../../tokens/shadows/atomic_shadows.dart';
import 'atomic_smooth_container.dart';

/// Atomic Icon Box Component
/// Container with icon, customizable styling and tap interactions
class AtomicIconBox extends StatefulWidget {
  const AtomicIconBox({
    super.key,
    required this.icon,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.width = 44.0,
    this.height = 44.0,
    this.iconSize = 18.0,
    this.borderRadius,
    this.margin,
    this.padding,
    this.autoWidth = false,
    this.blur = false,
    this.onTap,
    this.loading = false,
    this.enabled = true,
    this.shadow = AtomicIconBoxShadow.none,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final double width;
  final double height;
  final double iconSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool autoWidth;
  final bool blur;
  final VoidCallback? onTap;
  final bool loading;
  final bool enabled;
  final AtomicIconBoxShadow shadow;

  @override
  State<AtomicIconBox> createState() => _AtomicIconBoxState();
}

class _AtomicIconBoxState extends State<AtomicIconBox> with SingleTickerProviderStateMixin {
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

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
      // Delay the callback to show the animation
      Future.delayed(const Duration(milliseconds: 120), () {
        widget.onTap?.call();
      });
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
    final theme = AtomicTheme.of(context);
    
    Widget iconBox = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AtomicSmoothContainer(
              margin: widget.margin,
              padding: widget.padding,
              borderRadius: widget.borderRadius ?? AtomicBorders.md,
              width: widget.autoWidth ? null : widget.width,
              height: widget.height,
              color: _getBackgroundColor(theme),
              constraints: widget.autoWidth ? BoxConstraints(minWidth: widget.width) : null,
              border: Border.all(color: _getBorderColor(theme)),
              shadows: _getShadow(),
              alignment: Alignment.center,
              child: widget.loading ? _buildLoader(theme) : _buildIcon(theme),
            ),
          );
        },
      ),
    );

    // Apply blur effect if needed
    if (widget.blur) {
      return ClipRRect(
        borderRadius: widget.borderRadius ?? AtomicBorders.md,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: iconBox,
        ),
      );
    }

    return iconBox;
  }

  Widget _buildLoader(AtomicThemeData theme) {
    return SizedBox(
      width: widget.iconSize,
      height: widget.iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_getIconColor(theme)),
      ),
    );
  }

  Widget _buildIcon(AtomicThemeData theme) {
    return Icon(
      widget.icon,
      size: widget.iconSize,
      color: _getIconColor(theme),
    );
  }

  Color _getBackgroundColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.gray100;
    }
    return widget.backgroundColor ?? Colors.transparent;
  }

  Color _getBorderColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.gray300;
    }
    return widget.borderColor ?? theme.colors.gray300;
  }

  Color _getIconColor(AtomicThemeData theme) {
    if (!widget.enabled) {
      return theme.colors.textDisabled;
    }
    return widget.iconColor ?? theme.colors.textSecondary;
  }

  List<BoxShadow>? _getShadow() {
    switch (widget.shadow) {
      case AtomicIconBoxShadow.none:
        return null;
      case AtomicIconBoxShadow.small:
        return AtomicShadows.sm;
      case AtomicIconBoxShadow.medium:
        return AtomicShadows.md;
      case AtomicIconBoxShadow.large:
        return AtomicShadows.lg;
    }
  }
}

/// Icon box shadow options
enum AtomicIconBoxShadow {
  none,
  small,
  medium,
  large,
} 