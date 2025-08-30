import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
class AtomicButtonOptimized extends StatefulWidget {
  const AtomicButtonOptimized({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AtomicButtonVariant.primary,
    this.size = AtomicButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.iconPosition = AtomicButtonIconPosition.start,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AtomicButtonVariant variant;
  final AtomicButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final AtomicButtonIconPosition iconPosition;
  final bool isFullWidth;

  @override
  State<AtomicButtonOptimized> createState() => _AtomicButtonOptimizedState();
}

class _AtomicButtonOptimizedState extends State<AtomicButtonOptimized> 
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
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

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  void _handleTapDown(TapDownDetails details) {
    if (_isEnabled) {
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
    return _AtomicButtonTheme(
      variant: widget.variant,
      size: widget.size,
      isEnabled: _isEnabled,
      isPressed: _isPressed,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _isEnabled ? widget.onPressed : null,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _AtomicButtonContainer(
                isFullWidth: widget.isFullWidth,
                child: _AtomicButtonContent(
                  label: widget.label,
                  icon: widget.icon,
                  iconPosition: widget.iconPosition,
                  isLoading: widget.isLoading,
                  size: widget.size,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AtomicButtonTheme extends InheritedWidget {
  const _AtomicButtonTheme({
    required this.variant,
    required this.size,
    required this.isEnabled,
    required this.isPressed,
    required super.child,
  });

  final AtomicButtonVariant variant;
  final AtomicButtonSize size;
  final bool isEnabled;
  final bool isPressed;

  static _AtomicButtonTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AtomicButtonTheme>()!;
  }

  @override
  bool updateShouldNotify(_AtomicButtonTheme oldWidget) {
    return variant != oldWidget.variant ||
           size != oldWidget.size ||
           isEnabled != oldWidget.isEnabled ||
           isPressed != oldWidget.isPressed;
  }
}

class _AtomicButtonContainer extends StatelessWidget {
  const _AtomicButtonContainer({
    required this.isFullWidth,
    required this.child,
  });

  final bool isFullWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final buttonTheme = _AtomicButtonTheme.of(context);
    
    return AnimatedContainer(
      duration: AtomicAnimations.fast,
      width: isFullWidth ? double.infinity : null,
      decoration: _ButtonDecoration(
        colors: theme.colors,
        borders: theme.borders,
        variant: buttonTheme.variant,
        isEnabled: buttonTheme.isEnabled,
        isPressed: buttonTheme.isPressed,
      ).decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: theme.borders.button,
          splashColor: _ButtonColors.getSplashColor(theme.colors, buttonTheme.variant),
          highlightColor: _ButtonColors.getHighlightColor(theme.colors, buttonTheme.variant),
          child: Padding(
            padding: _ButtonSizing.getPadding(theme.spacing, buttonTheme.size),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _AtomicButtonContent extends StatelessWidget {
  const _AtomicButtonContent({
    required this.label,
    required this.icon,
    required this.iconPosition,
    required this.isLoading,
    required this.size,
  });

  final String label;
  final IconData? icon;
  final AtomicButtonIconPosition iconPosition;
  final bool isLoading;
  final AtomicButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final buttonTheme = _AtomicButtonTheme.of(context);

    if (isLoading) {
      return SizedBox(
        height: _ButtonSizing.getIconSize(size),
        width: _ButtonSizing.getIconSize(size),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _ButtonColors.getTextColor(theme.colors, buttonTheme.variant, buttonTheme.isEnabled),
          ),
        ),
      );
    }

    return _ButtonContentLayout(
      label: label,
      icon: icon,
      iconPosition: iconPosition,
      size: size,
    );
  }
}

class _ButtonContentLayout extends StatelessWidget {
  const _ButtonContentLayout({
    required this.label,
    required this.icon,
    required this.iconPosition,
    required this.size,
  });

  final String label;
  final IconData? icon;
  final AtomicButtonIconPosition iconPosition;
  final AtomicButtonSize size;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final buttonTheme = _AtomicButtonTheme.of(context);
    final textColor = _ButtonColors.getTextColor(theme.colors, buttonTheme.variant, buttonTheme.isEnabled);

    final List<Widget> children = [];
    
    if (icon != null && iconPosition == AtomicButtonIconPosition.start) {
      children.add(_ButtonIcon(icon: icon!, size: size, color: textColor));
      if (label.isNotEmpty) {
        children.add(const SizedBox(width: AtomicSpacing.xs));
      }
    }

    if (label.isNotEmpty) {
      children.add(
        Flexible(
          child: _ButtonText(
            label: label,
            size: size,
            color: textColor,
          ),
        ),
      );
    }

    if (icon != null && iconPosition == AtomicButtonIconPosition.end) {
      if (label.isNotEmpty) {
        children.add(const SizedBox(width: AtomicSpacing.xs));
      }
      children.add(_ButtonIcon(icon: icon!, size: size, color: textColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _ButtonText extends StatelessWidget {
  const _ButtonText({
    required this.label,
    required this.size,
    required this.color,
  });

  final String label;
  final AtomicButtonSize size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return Text(
      label,
      style: _ButtonSizing.getTextStyle(theme.typography, size).copyWith(color: color),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class _ButtonIcon extends StatelessWidget {
  const _ButtonIcon({
    required this.icon,
    required this.size,
    required this.color,
  });

  final IconData icon;
  final AtomicButtonSize size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: _ButtonSizing.getIconSize(size),
      color: color,
    );
  }
}

class _ButtonSizing {
  static EdgeInsets getPadding(AtomicSpacingTheme spacing, AtomicButtonSize size) {
    return switch (size) {
      AtomicButtonSize.small => EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs),
      AtomicButtonSize.medium => EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
      AtomicButtonSize.large => EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md),
    };
  }

  static TextStyle getTextStyle(AtomicTypographyTheme typography, AtomicButtonSize size) {
    return switch (size) {
      AtomicButtonSize.small => typography.labelSmall,
      AtomicButtonSize.medium => typography.labelMedium,
      AtomicButtonSize.large => typography.labelLarge,
    };
  }

  static double getIconSize(AtomicButtonSize size) {
    return switch (size) {
      AtomicButtonSize.small => 16,
      AtomicButtonSize.medium => 20,
      AtomicButtonSize.large => 24,
    };
  }
}

class _ButtonColors {
  static Color getBackgroundColor(AtomicColorScheme colors, AtomicButtonVariant variant, bool isEnabled) {
    if (!isEnabled) return colors.gray200;

    return switch (variant) {
      AtomicButtonVariant.primary => colors.primary,
      AtomicButtonVariant.secondary => colors.secondary,
      AtomicButtonVariant.tertiary => Colors.transparent,
      AtomicButtonVariant.outlined => Colors.transparent,
      AtomicButtonVariant.ghost => Colors.transparent,
      AtomicButtonVariant.danger => colors.error,
    };
  }

  static Color getTextColor(AtomicColorScheme colors, AtomicButtonVariant variant, bool isEnabled) {
    if (!isEnabled) return colors.textDisabled;

    return switch (variant) {
      AtomicButtonVariant.primary || 
      AtomicButtonVariant.secondary || 
      AtomicButtonVariant.danger => colors.textInverse,
      AtomicButtonVariant.tertiary || 
      AtomicButtonVariant.outlined => colors.primary,
      AtomicButtonVariant.ghost => colors.textPrimary,
    };
  }

  static Color getSplashColor(AtomicColorScheme colors, AtomicButtonVariant variant) {
    return switch (variant) {
      AtomicButtonVariant.primary => colors.primaryDark.withValues(alpha: 0.1),
      AtomicButtonVariant.secondary => colors.secondaryDark.withValues(alpha: 0.1),
      AtomicButtonVariant.danger => colors.errorDark.withValues(alpha: 0.1),
      _ => colors.primary.withValues(alpha: 0.1),
    };
  }

  static Color getHighlightColor(AtomicColorScheme colors, AtomicButtonVariant variant) {
    return getSplashColor(colors, variant).withValues(alpha: 0.05);
  }
}

class _ButtonDecoration {
  _ButtonDecoration({
    required this.colors,
    required this.borders,
    required this.variant,
    required this.isEnabled,
    required this.isPressed,
  });

  final AtomicColorScheme colors;
  final AtomicBordersTheme borders;
  final AtomicButtonVariant variant;
  final bool isEnabled;
  final bool isPressed;

  BoxDecoration get decoration {
    return BoxDecoration(
      color: _ButtonColors.getBackgroundColor(colors, variant, isEnabled),
      borderRadius: borders.button,
      border: _getBorder(),
      boxShadow: isEnabled && !isPressed ? AtomicShadows.button : AtomicShadows.none,
    );
  }

  Border? _getBorder() {
    if (!isEnabled) {
      return Border.all(color: colors.gray200, width: AtomicBorders.widthThin);
    }

    if (variant == AtomicButtonVariant.outlined) {
      return Border.all(color: colors.primary, width: AtomicBorders.widthThin);
    }

    return null;
  }
}

enum AtomicButtonVariant { primary, secondary, tertiary, outlined, ghost, danger }
enum AtomicButtonSize { small, medium, large }
enum AtomicButtonIconPosition { start, end }