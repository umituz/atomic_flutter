import 'package:flutter/material.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/shadows/atomic_shadows.dart';

/// Atomic Gradient Container Component
/// Container with gradient background support
class AtomicGradientContainer extends StatelessWidget {
  const AtomicGradientContainer({
    super.key,
    required this.child,
    this.gradient,
    this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops,
    this.tileMode = TileMode.clamp,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.borderRadius,
    this.border,
    this.shadow = AtomicGradientShadow.none,
    this.onTap,
  });

  final Widget child;
  final Gradient? gradient;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double>? stops;
  final TileMode tileMode;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final Border? border;
  final AtomicGradientShadow shadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? 
      (colors != null 
        ? LinearGradient(
            colors: colors!,
            begin: begin,
            end: end,
            stops: stops,
            tileMode: tileMode,
          )
        : null);

    Widget container = Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: borderRadius ?? AtomicBorders.lg,
        border: border,
        boxShadow: _getShadow(),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? AtomicBorders.lg,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AtomicBorders.lg,
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    return container;
  }

  List<BoxShadow>? _getShadow() {
    switch (shadow) {
      case AtomicGradientShadow.none:
        return AtomicShadows.none;
      case AtomicGradientShadow.small:
        return AtomicShadows.sm;
      case AtomicGradientShadow.medium:
        return AtomicShadows.md;
      case AtomicGradientShadow.large:
        return AtomicShadows.lg;
      case AtomicGradientShadow.glow:
        if (colors != null && colors!.isNotEmpty) {
          return AtomicShadows.glow(colors!.first, opacity: 0.3, blur: 16);
        }
        return AtomicShadows.lg;
    }
  }
}

/// Gradient container shadow options
enum AtomicGradientShadow {
  none,
  small,
  medium,
  large,
  glow,
} 