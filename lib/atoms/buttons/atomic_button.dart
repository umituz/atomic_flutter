import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/typography/atomic_typography.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';

/// A modern, customizable button component following atomic design principles.
///
/// The [AtomicButton] provides a comprehensive button solution with multiple
/// variants, sizes, loading states, and icon support. Built with Material Design 3
/// principles and optimized for accessibility.
///
/// Features:
/// - Multiple variants (primary, secondary, tertiary, ghost, destructive)
/// - Three sizes (small, medium, large)
/// - Loading state with animated indicators
/// - Icon support with flexible positioning
/// - Full-width option for forms
/// - Accessibility optimized (screen readers, focus handling)
/// - Smooth animations and hover effects
///
/// Example usage:
/// ```dart
/// AtomicButton(
///   label: 'Save Changes',
///   onPressed: () => _handleSave(),
///   variant: AtomicButtonVariant.primary,
///   size: AtomicButtonSize.large,
///   icon: Icons.save,
///   isLoading: _isSaving,
/// )
/// ```
///
/// For icon-only buttons, consider using [AtomicIconButton] instead.
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
    final theme = AtomicTheme.maybeOf(context);
    final colors = theme?.colors ?? AtomicColorScheme.defaultScheme;
    final spacing = theme?.spacing ?? const AtomicSpacingTheme();
    final typography = theme?.typography ?? const AtomicTypographyTheme();
    final borders = theme?.borders ?? const AtomicBordersTheme();

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
                color: _getBackgroundColor(colors),
                borderRadius: borders.button,
                border: _getBorder(colors),
                boxShadow: _isButtonEnabled && !_isPressed 
                  ? AtomicShadows.button 
                  : AtomicShadows.none,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isButtonEnabled ? widget.onPressed : null,
                  borderRadius: borders.button,
                  splashColor: _getSplashColor(colors),
                  highlightColor: _getHighlightColor(colors),
                  child: Padding(
                    padding: _getPadding(spacing),
                    child: _buildContent(colors, typography),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(AtomicColorScheme colors, AtomicTypographyTheme typography) {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(colors)),
        ),
      );
    }

    final List<Widget> children = [];
    
    if (widget.icon != null && widget.iconPosition == AtomicButtonIconPosition.start) {
      children.add(Icon(
        widget.icon,
        size: _getIconSize(),
        color: _getTextColor(colors),
      ));
      if (widget.label.isNotEmpty) {
        children.add(const SizedBox(width: AtomicSpacing.xs));
      }
    }

    if (widget.label.isNotEmpty) {
      children.add(Flexible(
        child: Text(
          widget.label,
          style: _getTextStyle(typography, colors),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ));
    }

    if (widget.icon != null && widget.iconPosition == AtomicButtonIconPosition.end) {
      if (widget.label.isNotEmpty) {
        children.add(const SizedBox(width: AtomicSpacing.xs));
      }
      children.add(Icon(
        widget.icon,
        size: _getIconSize(),
        color: _getTextColor(colors),
      ));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  EdgeInsets _getPadding(AtomicSpacingTheme spacing) {
    switch (widget.size) {
      case AtomicButtonSize.small:
        return EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs);
      case AtomicButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm);
      case AtomicButtonSize.large:
        return EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md);
    }
  }

  TextStyle _getTextStyle(AtomicTypographyTheme typography, AtomicColorScheme colors) {
    final TextStyle baseStyle;
    switch (widget.size) {
      case AtomicButtonSize.small:
        baseStyle = typography.labelSmall;
      case AtomicButtonSize.medium:
        baseStyle = typography.labelMedium;
      case AtomicButtonSize.large:
        baseStyle = typography.labelLarge;
    }
    
    return baseStyle.copyWith(
      color: _getTextColor(colors),
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

  Color _getBackgroundColor(AtomicColorScheme colors) {
    if (!_isButtonEnabled) {
      return colors.gray200;
    }

    switch (widget.variant) {
      case AtomicButtonVariant.primary:
        return colors.primary;
      case AtomicButtonVariant.secondary:
        return colors.secondary;
      case AtomicButtonVariant.tertiary:
        return Colors.transparent;
      case AtomicButtonVariant.outlined:
        return Colors.transparent;
      case AtomicButtonVariant.ghost:
        return Colors.transparent;
      case AtomicButtonVariant.danger:
        return colors.error;
    }
  }

  Color _getTextColor(AtomicColorScheme colors) {
    if (!_isButtonEnabled) {
      return colors.textDisabled;
    }

    switch (widget.variant) {
      case AtomicButtonVariant.primary:
      case AtomicButtonVariant.secondary:
      case AtomicButtonVariant.danger:
        return colors.textInverse;
      case AtomicButtonVariant.tertiary:
      case AtomicButtonVariant.outlined:
        return colors.primary;
      case AtomicButtonVariant.ghost:
        return colors.textPrimary;
    }
  }

  Border? _getBorder(AtomicColorScheme colors) {
    if (!_isButtonEnabled) {
      return Border.all(
        color: colors.gray200,
        width: AtomicBorders.widthThin,
      );
    }

    switch (widget.variant) {
      case AtomicButtonVariant.outlined:
        return Border.all(
          color: colors.primary,
          width: AtomicBorders.widthThin,
        );
      default:
        return null;
    }
  }

  Color _getSplashColor(AtomicColorScheme colors) {
    switch (widget.variant) {
      case AtomicButtonVariant.primary:
        return colors.primaryDark.withValues(alpha: 0.1);
      case AtomicButtonVariant.secondary:
        return colors.secondaryDark.withValues(alpha: 0.1);
      case AtomicButtonVariant.danger:
        return colors.errorDark.withValues(alpha: 0.1);
      default:
        return colors.primary.withValues(alpha: 0.1);
    }
  }

  Color _getHighlightColor(AtomicColorScheme colors) {
    return _getSplashColor(colors).withValues(alpha: 0.05);
  }
}

enum AtomicButtonVariant {
  primary,
  secondary,
  tertiary,
  outlined,
  ghost,
  danger,
}

enum AtomicButtonSize {
  small,
  medium,
  large,
}

enum AtomicButtonIconPosition {
  start,
  end,
} 