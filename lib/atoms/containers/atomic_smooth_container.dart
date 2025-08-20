import 'package:flutter/material.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';

class AtomicSmoothContainer extends StatelessWidget {
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

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadows;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final Decoration? decoration;
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

class AtomicAnimatedSmoothContainer extends ImplicitlyAnimatedWidget {
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

  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  @override
  AnimatedWidgetBaseState<AtomicAnimatedSmoothContainer> createState() =>
      _AtomicAnimatedSmoothContainerState();
}

class _AtomicAnimatedSmoothContainerState
    extends AnimatedWidgetBaseState<AtomicAnimatedSmoothContainer> {
  AlignmentGeometryTween? _alignment;
  EdgeInsetsGeometryTween? _padding;
  DecorationTween? _decoration;
  DecorationTween? _foregroundDecoration;
  BoxConstraintsTween? _constraints;
  EdgeInsetsGeometryTween? _margin;
  Matrix4Tween? _transform;
  AlignmentGeometryTween? _transformAlignment;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
      _alignment,
      widget.alignment,
      (dynamic value) => AlignmentGeometryTween(begin: value as AlignmentGeometry),
    ) as AlignmentGeometryTween?;
    
    _padding = visitor(
      _padding,
      widget.padding,
      (dynamic value) => EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry),
    ) as EdgeInsetsGeometryTween?;
    
    _decoration = visitor(
      _decoration,
      widget.decoration,
      (dynamic value) => DecorationTween(begin: value as Decoration),
    ) as DecorationTween?;
    
    _foregroundDecoration = visitor(
      _foregroundDecoration,
      widget.foregroundDecoration,
      (dynamic value) => DecorationTween(begin: value as Decoration),
    ) as DecorationTween?;
    
    _constraints = visitor(
      _constraints,
      widget.constraints,
      (dynamic value) => BoxConstraintsTween(begin: value as BoxConstraints),
    ) as BoxConstraintsTween?;
    
    _margin = visitor(
      _margin,
      widget.margin,
      (dynamic value) => EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry),
    ) as EdgeInsetsGeometryTween?;
    
    _transform = visitor(
      _transform,
      widget.transform,
      (dynamic value) => Matrix4Tween(begin: value as Matrix4),
    ) as Matrix4Tween?;
    
    _transformAlignment = visitor(
      _transformAlignment,
      widget.transformAlignment,
      (dynamic value) => AlignmentGeometryTween(begin: value as AlignmentGeometry),
    ) as AlignmentGeometryTween?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;
    
    return Container(
      alignment: _alignment?.evaluate(animation),
      padding: _padding?.evaluate(animation),
      decoration: _decoration?.evaluate(animation),
      foregroundDecoration: _foregroundDecoration?.evaluate(animation),
      constraints: _constraints?.evaluate(animation),
      margin: _margin?.evaluate(animation),
      transform: _transform?.evaluate(animation),
      transformAlignment: _transformAlignment?.evaluate(animation),
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }
} 