import 'package:flutter/material.dart';

/// An implicitly animated container that animates changes to its properties.
///
/// This widget is a wrapper around Flutter's [Container] that automatically
/// animates changes to its properties over a specified [duration] and [curve].
/// It's useful for creating smooth UI transitions without explicitly managing
/// [AnimationController]s.
///
/// All properties that are typically animated in a [Container] (like color,
/// decoration, size, alignment, etc.) are supported. Additionally, it allows
/// for direct specification of [borderRadius], [border], [shadows], and [gradient]
/// which are then combined into an internal [BoxDecoration].
///
/// Example usage:
/// ```dart
/// class MyAnimatedContainer extends StatefulWidget {
///   const MyAnimatedContainer({super.key});
///
///   @override
///   State<MyAnimatedContainer> createState() => _MyAnimatedContainerState();
/// }
///
/// class _MyAnimatedContainerState extends State<MyAnimatedContainer> {
///   bool _isExpanded = false;
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onTap: () {
///         setState(() {
///           _isExpanded = !_isExpanded;
///         });
///       },
///       child: AtomicAnimatedContainer(
///         duration: const Duration(milliseconds: 500),
///         curve: Curves.fastOutSlowIn,
///         width: _isExpanded ? 200 : 100,
///         height: _isExpanded ? 200 : 100,
///         color: _isExpanded ? Colors.blue : Colors.red,
///         borderRadius: _isExpanded ? BorderRadius.circular(20) : BorderRadius.circular(5),
///         child: Center(
///           child: Text(
///             _isExpanded ? 'Expanded!' : 'Tap me!',
///             style: const TextStyle(color: Colors.white),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
class AtomicAnimatedContainer extends ImplicitlyAnimatedWidget {
  /// Creates an [AtomicAnimatedContainer].
  ///
  /// All properties are animated implicitly when their values change.
  ///
  /// [duration] and [curve] control the animation.
  /// [child] is the widget below this widget in the tree.
  /// [alignment] aligns the child within the container.
  /// [padding] insets the child.
  /// [color] fills the container.
  /// [decoration] paints behind the child.
  /// [foregroundDecoration] paints in front of the child.
  /// [margin] empty space around the container.
  /// [transform] applies a transformation matrix before painting.
  /// [transformAlignment] aligns the origin of the transformation.
  /// [clipBehavior] controls how content is clipped.
  /// [width] and [height] specify the dimensions.
  /// [constraints] additional constraints on the child.
  /// [borderRadius] applies rounded corners to the container.
  /// [border] applies a border to the container.
  /// [shadows] applies a list of box shadows to the container.
  /// [gradient] applies a gradient to the container.
  const AtomicAnimatedContainer({
    super.key,
    this.child,
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.width,
    this.height,
    this.constraints,
    this.borderRadius,
    this.border,
    this.shadows,
    this.gradient,
    required super.duration,
    super.curve = Curves.easeInOut,
    super.onEnd,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Align the [child] within the container.
  final AlignmentGeometry? alignment;

  /// Empty space to inscribe inside the [decoration]. The [child] is
  /// placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// The color to paint behind the [child].
  ///
  /// This is a short-hand for building a [BoxDecoration] with a color.
  final Color? color;

  /// The decoration to paint behind the [child].
  final BoxDecoration? decoration;

  /// The decoration to paint in front of the [child].
  final Decoration? foregroundDecoration;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The alignment of the origin of the transformation.
  final AlignmentGeometry? transformAlignment;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  /// If non-null, requires the container to have the given width.
  final double? width;

  /// If non-null, requires the container to have the given height.
  final double? height;

  /// Additional constraints to apply to the child.
  final BoxConstraints? constraints;

  /// The border radius of the container.
  final BorderRadius? borderRadius;

  /// The border of the container.
  final Border? border;

  /// A list of box shadows to paint behind the container.
  final List<BoxShadow>? shadows;

  /// A gradient to paint behind the container.
  final Gradient? gradient;

  @override
  AnimatedWidgetBaseState<AtomicAnimatedContainer> createState() =>
      _AtomicAnimatedContainerState();
}

class _AtomicAnimatedContainerState
    extends AnimatedWidgetBaseState<AtomicAnimatedContainer> {
  AlignmentGeometryTween? _alignment;
  EdgeInsetsGeometryTween? _padding;
  DecorationTween? _decoration;
  DecorationTween? _foregroundDecoration;
  EdgeInsetsGeometryTween? _margin;
  Matrix4Tween? _transform;
  AlignmentGeometryTween? _transformAlignment;
  Tween<double>? _width;
  Tween<double>? _height;
  BoxConstraintsTween? _constraints;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
      _alignment,
      widget.alignment,
      (dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry?),
    ) as AlignmentGeometryTween?;

    _padding = visitor(
      _padding,
      widget.padding,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;

    _decoration = visitor(
      _decoration,
      widget.decoration ?? _createDecoration(),
      (dynamic value) => DecorationTween(begin: value as Decoration?),
    ) as DecorationTween?;

    _foregroundDecoration = visitor(
      _foregroundDecoration,
      widget.foregroundDecoration,
      (dynamic value) => DecorationTween(begin: value as Decoration?),
    ) as DecorationTween?;

    _margin = visitor(
      _margin,
      widget.margin,
      (dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;

    _transform = visitor(
      _transform,
      widget.transform,
      (dynamic value) => Matrix4Tween(begin: value as Matrix4?),
    ) as Matrix4Tween?;

    _transformAlignment = visitor(
      _transformAlignment,
      widget.transformAlignment,
      (dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry?),
    ) as AlignmentGeometryTween?;

    _width = visitor(
      _width,
      widget.width,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _height = visitor(
      _height,
      widget.height,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;

    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints?),
    ) as BoxConstraintsTween?;
  }

  BoxDecoration _createDecoration() {
    return BoxDecoration(
      color: widget.color,
      borderRadius: widget.borderRadius,
      border: widget.border,
      boxShadow: widget.shadows,
      gradient: widget.gradient,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;

    return Container(
      alignment: _alignment?.evaluate(animation),
      padding: _padding?.evaluate(animation),
      decoration: _decoration?.evaluate(animation),
      foregroundDecoration: _foregroundDecoration?.evaluate(animation),
      margin: _margin?.evaluate(animation),
      transform: _transform?.evaluate(animation),
      transformAlignment: _transformAlignment?.evaluate(animation),
      width: _width?.evaluate(animation),
      height: _height?.evaluate(animation),
      constraints: _constraints?.evaluate(animation),
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
}
