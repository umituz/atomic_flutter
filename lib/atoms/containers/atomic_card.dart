import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';

/// A customizable card component for displaying content with elevation and interaction.
///
/// The [AtomicCard] provides a flexible container that can display any [child]
/// widget. It supports various visual customizations like padding, margin,
/// color, gradient, border radius, and shadow. It also offers tap and long-press
/// interactions with optional animation.
///
/// Features:
/// - Customizable padding and margin for content.
/// - Support for solid colors or gradients as background.
/// - Adjustable border radius and border.
/// - Multiple shadow elevations ([AtomicCardShadow]).
/// - Optional tap and long-press callbacks.
/// - Clickable state with visual feedback and animation.
///
/// Example usage:
/// ```dart
/// AtomicCard(
///   onTap: () {
///     // Handle card tap
///   },
///   shadow: AtomicCardShadow.medium,
///   child: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Column(
///       children: [
///         Text('Card Title'),
///         SizedBox(height: 8),
///         Text('This is some content inside the card.'),
///       ],
///     ),
///   ),
/// )
/// ```
class AtomicCard extends StatefulWidget {
  /// Creates an [AtomicCard].
  ///
  /// [child] is the widget contained within the card.
  /// [padding] is the internal padding of the card. Defaults to [AtomicSpacing.cardContentPadding].
  /// [margin] is the external margin around the card.
  /// [color] is the background color of the card. Defaults to [AtomicColors.surface].
  /// [gradient] is an optional gradient to paint behind the card. Overrides [color].
  /// [borderRadius] is the border radius of the card. Defaults to [AtomicBorders.card].
  /// [border] is an optional border for the card.
  /// [shadow] defines the elevation and shadow effect of the card. Defaults to [AtomicCardShadow.medium].
  /// [onTap] is the callback function executed when the card is tapped.
  /// [onLongPress] is the callback function executed when the card is long-pressed.
  /// [isClickable] determines if the card should show visual feedback on tap.
  /// [animateOnTap] controls if the card animates on tap down/up. Defaults to true.
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

  /// The widget contained within the card.
  final Widget child;

  /// The internal padding of the card.
  final EdgeInsets? padding;

  /// The external margin around the card.
  final EdgeInsets? margin;

  /// The background color of the card.
  final Color? color;

  /// An optional gradient to paint behind the card. Overrides [color].
  final Gradient? gradient;

  /// The border radius of the card.
  final BorderRadius? borderRadius;

  /// An optional border for the card.
  final Border? border;

  /// Defines the elevation and shadow effect of the card.
  final AtomicCardShadow shadow;

  /// The callback function executed when the card is tapped.
  final VoidCallback? onTap;

  /// The callback function executed when the card is long-pressed.
  final VoidCallback? onLongPress;

  /// Determines if the card should show visual feedback on tap, even if [onTap] is null.
  final bool isClickable;

  /// Controls if the card animates on tap down/up. Defaults to true.
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

/// Defines the shadow elevation options for an [AtomicCard].
enum AtomicCardShadow {
  /// No shadow.
  none,

  /// A small shadow elevation.
  small,

  /// A medium shadow elevation.
  medium,

  /// A large shadow elevation.
  large,

  /// An extra large shadow elevation.
  extraLarge,
}
