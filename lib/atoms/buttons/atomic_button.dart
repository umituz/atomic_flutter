import 'package:flutter/material.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/spacing/atomic_spacing.dart';
import '../../tokens/typography/atomic_typography.dart';
import '../../tokens/animations/atomic_animations.dart';
import '../../tokens/shadows/atomic_shadows.dart';
import '../../tokens/borders/atomic_borders.dart';

/// Atomic Button Component
/// Flexible button component with multiple variants and states
class AtomicButton extends StatefulWidget {
  const AtomicButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AtomicButtonVariant.primary,
    this.size = AtomicButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = AtomicButtonIconPosition.start,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AtomicButtonVariant variant;
  final AtomicButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final AtomicButtonIconPosition iconPosition;
  final bool isFullWidth;

  @override
  State<AtomicButton> createState() => _AtomicButtonState();
}

class _AtomicButtonState extends State<AtomicButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AtomicAnimations.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  bool get _isButtonEnabled => 
    widget.onPressed != null && !widget.isLoading && !widget.isDisabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _isButtonEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: AtomicAnimations.fast,
              width: widget.isFullWidth ? double.infinity : null,
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: AtomicBorders.button,
                border: _getBorder(),
                boxShadow: _isButtonEnabled && !_isPressed 
                  ? AtomicShadows.button 
                  : AtomicShadows.none,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isButtonEnabled ? widget.onPressed : null,
                  borderRadius: AtomicBorders.button,
                  splashColor: _getSplashColor(),
                  highlightColor: _getHighlightColor(),
                  child: Padding(
                    padding: _getPadding(),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    final List<Widget> children = [];
    
    if (widget.icon != null && widget.iconPosition == AtomicButtonIconPosition.start) {
      children.add(Icon(
        widget.icon,
        size: _getIconSize(),
        color: _getTextColor(),
      ));
      if (widget.label.isNotEmpty) {
        children.add(SizedBox(width: AtomicSpacing.xs));
      }
    }

    if (widget.label.isNotEmpty) {
      children.add(Text(
        widget.label,
        style: _getTextStyle(),
      ));
    }

    if (widget.icon != null && widget.iconPosition == AtomicButtonIconPosition.end) {
      if (widget.label.isNotEmpty) {
        children.add(SizedBox(width: AtomicSpacing.xs));
      }
      children.add(Icon(
        widget.icon,
        size: _getIconSize(),
        color: _getTextColor(),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case AtomicButtonSize.small:
        return AtomicSpacing.symmetric(horizontal: AtomicSpacing.sm, vertical: AtomicSpacing.xs);
      case AtomicButtonSize.medium:
        return AtomicSpacing.symmetric(horizontal: AtomicSpacing.md, vertical: AtomicSpacing.sm);
      case AtomicButtonSize.large:
        return AtomicSpacing.symmetric(horizontal: AtomicSpacing.lg, vertical: AtomicSpacing.md);
    }
  }

  TextStyle _getTextStyle() {
    final TextStyle baseStyle;
    switch (widget.size) {
      case AtomicButtonSize.small:
        baseStyle = AtomicTypography.labelSmall;
      case AtomicButtonSize.medium:
        baseStyle = AtomicTypography.labelMedium;
      case AtomicButtonSize.large:
        baseStyle = AtomicTypography.labelLarge;
    }
    
    return baseStyle.copyWith(
      color: _getTextColor(),
      fontWeight: AtomicTypography.semiBold,
    );
  }

  double _getIconSize() {
    switch (widget.size) {
      case AtomicButtonSize.small:
        return 16;
      case AtomicButtonSize.medium:
        return 20;
      case AtomicButtonSize.large:
        return 24;
    }
  }

  Color _getBackgroundColor() {
    if (!_isButtonEnabled) {
      return AtomicColors.gray200;
    }

    switch (widget.variant) {
      case AtomicButtonVariant.primary:
        return AtomicColors.primary;
      case AtomicButtonVariant.secondary:
        return AtomicColors.secondary;
      case AtomicButtonVariant.tertiary:
        return Colors.transparent;
      case AtomicButtonVariant.outlined:
        return Colors.transparent;
      case AtomicButtonVariant.ghost:
        return Colors.transparent;
      case AtomicButtonVariant.danger:
        return AtomicColors.error;
    }
  }

  Color _getTextColor() {
    if (!_isButtonEnabled) {
      return AtomicColors.textDisabled;
    }

    switch (widget.variant) {
      case AtomicButtonVariant.primary:
      case AtomicButtonVariant.secondary:
      case AtomicButtonVariant.danger:
        return AtomicColors.textInverse;
      case AtomicButtonVariant.tertiary:
      case AtomicButtonVariant.outlined:
        return AtomicColors.primary;
      case AtomicButtonVariant.ghost:
        return AtomicColors.textPrimary;
    }
  }

  Border? _getBorder() {
    if (!_isButtonEnabled) {
      return AtomicBorders.disabledBorder;
    }

    switch (widget.variant) {
      case AtomicButtonVariant.outlined:
        return AtomicBorders.primaryBorder;
      default:
        return null;
    }
  }

  Color _getSplashColor() {
    switch (widget.variant) {
      case AtomicButtonVariant.primary:
        return AtomicColors.primaryDark.withValues(alpha: 0.1);
      case AtomicButtonVariant.secondary:
        return AtomicColors.secondaryDark.withValues(alpha: 0.1);
      case AtomicButtonVariant.danger:
        return AtomicColors.errorDark.withValues(alpha: 0.1);
      default:
        return AtomicColors.primary.withValues(alpha: 0.1);
    }
  }

  Color _getHighlightColor() {
    return _getSplashColor().withValues(alpha: 0.05);
  }
}

/// Button variant options
enum AtomicButtonVariant {
  primary,
  secondary,
  tertiary,
  outlined,
  ghost,
  danger,
}

/// Button size options
enum AtomicButtonSize {
  small,
  medium,
  large,
}

/// Button icon position
enum AtomicButtonIconPosition {
  start,
  end,
} 