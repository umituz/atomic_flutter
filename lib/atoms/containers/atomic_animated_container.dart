import 'package:flutter/material.dart';

class AtomicAnimatedContainer extends ImplicitlyAnimatedWidget {
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

  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BoxDecoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadows;
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
      (dynamic value) => AlignmentGeometryTween(begin: value as AlignmentGeometry?),
    ) as AlignmentGeometryTween?;
    
    _padding = visitor(
      _padding,
      widget.padding,
      (dynamic value) => EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
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
      (dynamic value) => EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;
    
    _transform = visitor(
      _transform,
      widget.transform,
      (dynamic value) => Matrix4Tween(begin: value as Matrix4?),
    ) as Matrix4Tween?;
    
    _transformAlignment = visitor(
      _transformAlignment,
      widget.transformAlignment,
      (dynamic value) => AlignmentGeometryTween(begin: value as AlignmentGeometry?),
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