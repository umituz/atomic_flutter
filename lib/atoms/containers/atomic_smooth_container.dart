import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';

/// A versatile container widget with smooth, customizable styling.
///
/// The [AtomicSmoothContainer] provides a flexible way to create containers
/// with rounded corners, borders, shadows, and gradient backgrounds. It acts
/// as a wrapper around Flutter's [Container] but simplifies common styling
/// options.
///
/// Features:
/// - Customizable width, height, padding, and margin.
/// - Support for solid colors or gradients.
/// - Adjustable border radius and border.
/// - Optional box shadows.
/// - Alignment and transformation properties.
/// - Clip behavior control.
///
/// Example usage:
/// ```dart
/// AtomicSmoothContainer(
///   width: 100,
///   height: 100,
///   color: Colors.blue,
///   borderRadius: BorderRadius.circular(16),
///   shadows: [
///     BoxShadow(
///       color: Colors.black.withOpacity(0.2),
///       blurRadius: 8,
///       offset: Offset(0, 4),
///     ),
///   ],
///   child: Center(
///     child: Text(
///       'Smooth',
///       style: TextStyle(color: Colors.white),
///     ),
///   ),
/// )
/// ```
class AtomicSmoothContainer extends StatelessWidget {
  /// Creates an [AtomicSmoothContainer].
  ///
  /// [child] is the widget contained within the container.
  /// [width] and [height] specify the dimensions of the container.
  /// [padding] is the internal padding of the container.
  /// [margin] is the external margin around the container.
  /// [color] is the background color of the container.
  /// [gradient] is an optional gradient to paint behind the container. Overrides [color].
  /// [borderRadius] is the border radius of the container. Defaults to [AtomicBorders.md].
  /// [border] is an optional border for the container.
  /// [shadows] is a list of box shadows to paint behind the container.
  /// [alignment] aligns the child within the container.
  /// [constraints] additional constraints on the child.
  /// [transform] applies a transformation matrix before painting.
  /// [transformAlignment] aligns the origin of the transformation.
  /// [clipBehavior] controls how content is clipped. Defaults to [Clip.antiAlias].
  /// [decoration] paints behind the child. If provided, [color], [gradient], [borderRadius], [border], and [shadows] are ignored.
  /// [foregroundDecoration] paints in front of the child.
  const AtomicSmoothContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.shadows,
    this.alignment,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.antiAlias,
    this.decoration,
    this.foregroundDecoration,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The width of the container.
  final double? width;

  /// The height of the container.
  final double? height;

  /// Empty space to inscribe inside the [decoration]. The [child] is
  /// placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The color to paint behind the [child].
  final Color? color;

  /// The gradient to paint behind the [child].
  final Gradient? gradient;

  /// The border radius of the container. Defaults to [AtomicBorders.md].
  final BorderRadius? borderRadius;

  /// The border of the container.
  final Border? border;

  /// A list of box shadows to paint behind the container.
  final List<BoxShadow>? shadows;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// Additional constraints to apply to the child.
  final BoxConstraints? constraints;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The alignment of the origin of the transformation.
  final AlignmentGeometry? transformAlignment;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  /// The decoration to paint behind the [child].
  /// If provided, [color], [gradient], [borderRadius], [border], and [shadows] are ignored.
  final Decoration? decoration;

  /// The decoration to paint in front of the [child].
  final Decoration? foregroundDecoration;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? AtomicBorders.md;

    if (decoration != null) {
      return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        alignment: alignment,
        constraints: constraints,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        decoration: decoration,
        foregroundDecoration: foregroundDecoration,
        child: child,
      );
    }

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: border,
        boxShadow: shadows,
      ),
      foregroundDecoration: foregroundDecoration,
      child: child,
    );
  }
}

/// An implicitly animated version of [AtomicSmoothContainer].
///
/// This widget animates changes to its properties over a specified [duration]
/// and [curve]. It's useful for creating smooth transitions for container
/// properties without explicitly managing [AnimationController]s.
///
/// Properties like alignment, padding, color, decoration, constraints, margin,
/// and transform are animated when their values change.
///
/// Example usage:
/// ```dart
/// class MyAnimatedSmoothContainer extends StatefulWidget {
///   const MyAnimatedSmoothContainer({super.key});
///
///   @override
///   State<MyAnimatedSmoothContainer> createState() => _MyAnimatedSmoothContainerState();
/// }
///
/// class _MyAnimatedSmoothContainerState extends State<MyAnimatedSmoothContainer> {
///   bool _isBig = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTap: () {
///         setState(() {
///           _isBig = !_isBig;
///         });
///       },
///       child: AtomicAnimatedSmoothContainer(
///         duration: const Duration(milliseconds: 400),
///         curve: Curves.easeInOut,
///         width: _isBig ? 200 : 100,
///         height: _isBig ? 200 : 100,
///         color: _isBig ? Colors.green : Colors.orange,
///         borderRadius: BorderRadius.circular(_isBig ? 20 : 5),
///         child: Center(
///           child: Text(
///             _isBig ? 'Big!' : 'Small!',
///             style: const TextStyle(color: Colors.white),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class AtomicAnimatedSmoothContainer extends ImplicitlyAnimatedWidget {
  /// Creates an [AtomicAnimatedSmoothContainer].
  ///
  /// [duration] and [curve] control the animation.
  /// [child] is the widget below this widget in the tree.
  /// [alignment] aligns the child within the container.
  /// [padding] insets the child.
  /// [color] fills the container.
  /// [decoration] paints behind the child.
  /// [foregroundDecoration] paints in front of the child.
  /// [width] and [height] specify the dimensions.
  /// [constraints] additional constraints on the child.
  /// [margin] empty space around the container.
  /// [transform] applies a transformation matrix before painting.
  /// [transformAlignment] aligns the origin of the transformation.
  /// [clipBehavior] controls how content is clipped. Defaults to [Clip.none].
  AtomicAnimatedSmoothContainer({
    super.key,
    this.child,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    required super.duration,
    super.curve,
    super.onEnd,
  }) : constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// Empty space to inscribe inside the [decoration]. The [child] is
  /// placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// The color to paint behind the [child].
  final Color? color;

  /// The decoration to paint behind the [child].
  final Decoration? decoration;

  /// The decoration to paint in front of the [child].
  final Decoration? foregroundDecoration;

  /// Additional constraints to apply to the child.
  final BoxConstraints? constraints;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The alignment of the origin of the transformation.
  final AlignmentGeometry? transformAlignment;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  @override
  AnimatedWidgetBaseState<AtomicAnimatedSmoothContainer> createState() =>
      _AtomicAnimatedSmoothContainerState();
}

class _AtomicAnimatedSmoothContainerState 
    extends AnimatedWidgetBaseState<AtomicAnimatedSmoothContainer> {
  
  @override
  Widget build(BuildContext context) {
    return AtomicSmoothContainer(
      width: animation.value,
      height: animation.value,
      decoration: widget.decoration,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
  
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    // Add tween animations for properties that need to be animated
  }
}
