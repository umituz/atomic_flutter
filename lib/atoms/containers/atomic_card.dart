import 'package:flutter/material.dart';
import 'package:atomic_flutter/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';

class AtomicCard extends StatefulWidget {
  const AtomicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.shadow = AtomicCardShadow.medium,
    this.onTap,
    this.onLongPress,
    this.isClickable = false,
    this.animateOnTap = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Border? border;
  final AtomicCardShadow shadow;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isClickable;
  final bool animateOnTap;

  @override
  State<AtomicCard> createState() => _AtomicCardState();
}

class _AtomicCardState extends State<AtomicCard> 
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
      end: 0.98,
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

  bool get _hasInteraction => 
    widget.isClickable || widget.onTap != null || widget.onLongPress != null;

  void _handleTapDown(TapDownDetails details) {
    if (_hasInteraction && widget.animateOnTap) {
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
    final card = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.animateOnTap && _hasInteraction 
            ? _scaleAnimation.value 
            : 1.0,
          child: Container(
            margin: widget.margin,
            decoration: BoxDecoration(
              color: widget.gradient == null 
                ? (widget.color ?? AtomicColors.surface) 
                : null,
              gradient: widget.gradient,
              borderRadius: widget.borderRadius ?? AtomicBorders.card,
              border: widget.border,
              boxShadow: _getShadow(),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: widget.borderRadius ?? AtomicBorders.card,
              child: InkWell(
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                borderRadius: widget.borderRadius ?? AtomicBorders.card,
                splashColor: _hasInteraction 
                  ? AtomicColors.primary.withValues(alpha: 0.1) 
                  : Colors.transparent,
                highlightColor: _hasInteraction 
                  ? AtomicColors.primary.withValues(alpha: 0.05) 
                  : Colors.transparent,
                child: Container(
                  padding: widget.padding ?? AtomicSpacing.cardContentPadding,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (_hasInteraction && widget.animateOnTap) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: card,
      );
    }

    return card;
  }

  List<BoxShadow>? _getShadow() {
    if (_isPressed && widget.animateOnTap) {
      return AtomicShadows.xs;
    }

    switch (widget.shadow) {
      case AtomicCardShadow.none:
        return AtomicShadows.none;
      case AtomicCardShadow.small:
        return AtomicShadows.sm;
      case AtomicCardShadow.medium:
        return AtomicShadows.md;
      case AtomicCardShadow.large:
        return AtomicShadows.lg;
      case AtomicCardShadow.extraLarge:
        return AtomicShadows.xl;
    }
  }
}

enum AtomicCardShadow {
  none,
  small,
  medium,
  large,
  extraLarge,
} 