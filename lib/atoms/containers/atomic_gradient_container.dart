import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';

/// A container widget that displays a gradient background.
///
/// The [AtomicGradientContainer] allows you to easily create containers with
/// linear gradients, customizable colors, alignment, stops, and tile mode.
/// It also supports padding, margin, dimensions, border radius, border,
/// and various shadow effects, including a unique 'glow' shadow based on the gradient's first color.
///
/// Features:
/// - Flexible gradient definition (either a [Gradient] object or a list of [colors]).
/// - Customizable gradient direction ([begin], [end]).
/// - Support for padding, margin, width, height, and constraints.
/// - Adjustable border radius and border.
/// - Multiple shadow options, including a 'glow' effect.
/// - Optional tap functionality.
///
/// Example usage:
/// ```dart
/// AtomicGradientContainer(
///   colors: const [Colors.purple, Colors.blue],
///   begin: Alignment.topLeft,
///   end: Alignment.bottomRight,
///   borderRadius: BorderRadius.circular(16),
///   shadow: AtomicGradientShadow.glow,
///   padding: const EdgeInsets.all(20),
///   child: const Text(
///     'Gradient Container',
///     style: TextStyle(color: Colors.white, fontSize: 24),
///   ),
/// )
/// ```
class AtomicGradientContainer extends StatelessWidget {
  /// Creates an [AtomicGradientContainer].
  ///
  /// [child] is the widget contained within the container.
  /// [gradient] is the gradient to paint behind the child. If provided, [colors], [begin], [end], [stops], and [tileMode] are ignored.
  /// [colors] is a list of colors to use for the linear gradient. Required if [gradient] is null.
  /// [begin] is the alignment of the gradient's start point. Defaults to [Alignment.topLeft].
  /// [end] is the alignment of the gradient's end point. Defaults to [Alignment.bottomRight].
  /// [stops] is a list of fractional offsets, from 0.0 to 1.0, for each color in the [colors] list.
  /// [tileMode] determines how the gradient fills the space. Defaults to [TileMode.clamp].
  /// [padding] is the internal padding of the container.
  /// [margin] is the external margin around the container.
  /// [width] and [height] specify the dimensions of the container.
  /// [constraints] additional constraints on the child.
  /// [borderRadius] is the border radius of the container. Defaults to [AtomicBorders.lg].
  /// [border] is an optional border for the container.
  /// [shadow] defines the shadow effect of the container. Defaults to [AtomicGradientShadow.none].
  /// [onTap] is the callback function executed when the container is tapped.
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

  /// The widget contained within the container.
  final Widget child;

  /// The gradient to paint behind the child. If provided, [colors], [begin], [end], [stops], and [tileMode] are ignored.
  final Gradient? gradient;

  /// A list of colors to use for the linear gradient. Required if [gradient] is null.
  final List<Color>? colors;

  /// The alignment of the gradient's start point. Defaults to [Alignment.topLeft].
  final AlignmentGeometry begin;

  /// The alignment of the gradient's end point. Defaults to [Alignment.bottomRight].
  final AlignmentGeometry end;

  /// A list of fractional offsets, from 0.0 to 1.0, for each color in the [colors] list.
  final List<double>? stops;

  /// Determines how the gradient fills the space. Defaults to [TileMode.clamp].
  final TileMode tileMode;

  /// The internal padding of the container.
  final EdgeInsets? padding;

  /// The external margin around the container.
  final EdgeInsets? margin;

  /// The width of the container.
  final double? width;

  /// The height of the container.
  final double? height;

  /// Additional constraints to apply to the child.
  final BoxConstraints? constraints;

  /// The border radius of the container. Defaults to [AtomicBorders.lg].
  final BorderRadius? borderRadius;

  /// An optional border for the container.
  final Border? border;

  /// Defines the shadow effect of the container. Defaults to [AtomicGradientShadow.none].
  final AtomicGradientShadow shadow;

  /// The callback function executed when the container is tapped.
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

/// Defines the shadow elevation options for an [AtomicGradientContainer].
enum AtomicGradientShadow {
  /// No shadow.
  none,

  /// A small shadow elevation.
  small,

  /// A medium shadow elevation.
  medium,

  /// A large shadow elevation.
  large,

  /// A glowing shadow effect, typically matching the gradient's primary color.
  glow,
}
