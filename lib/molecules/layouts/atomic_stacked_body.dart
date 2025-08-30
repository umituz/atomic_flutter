import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';

import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';

/// A layout widget that creates a visually stacked body effect.
///
/// The [AtomicStackedBody] displays its [child] content on top of a series
/// of slightly offset background layers, creating a depth effect. This is
/// often used for cards or sections that appear to be stacked on top of each other.
///
/// Features:
/// - Customizable number of background stack layers.
/// - Adjustable offset between stack layers.
/// - Customizable background color for the main body and stack layers.
/// - Adjustable border radius for the main body and stack layers.
/// - Optional shadow for the main body.
/// - Customizable padding for the main body content.
///
/// Example usage:
/// ```dart
/// AtomicStackedBody(
///   stackCount: 3,
///   stackOffset: 10.0,
///   backgroundColor: Colors.white,
///   borderRadius: BorderRadius.circular(16),
///   shadow: BoxShadow(
///     color: Colors.black.withOpacity(0.1),
///     blurRadius: 10,
///     offset: Offset(0, 5),
///   ),
///   child: Padding(
///     padding: const EdgeInsets.all(24.0),
///     child: Column(
///       children: [
///         Text(
///           'Stacked Content',
///           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
///         ),
///         SizedBox(height: 16),
///         Text('This content appears on the top layer.'),
///       ],
///     ),
///   ),
/// )
/// ```
class AtomicStackedBody extends StatelessWidget {
  /// Creates an [AtomicStackedBody] widget.
  ///
  /// [child] is the main content to be displayed on the top layer.
  /// [stackCount] is the number of background layers to display. Defaults to 2.
  /// [stackOffset] is the vertical offset between each stack layer. Defaults to 8.0.
  /// [backgroundColor] is the background color of the main body.
  /// [stackColors] is an optional list of colors for the stack layers. If null, colors are generated based on opacity.
  /// [borderRadius] is the border radius for the main body and stack layers. Defaults to [AtomicBorders.lg].
  /// [padding] is the internal padding for the main body content.
  /// [shadow] is an optional [BoxShadow] for the main body. Defaults to [AtomicShadows.lg].
  const AtomicStackedBody({
    super.key,
    required this.child,
    this.stackCount = 2,
    this.stackOffset = 8.0,
    this.backgroundColor,
    this.stackColors,
    this.borderRadius,
    this.padding,
    this.shadow,
  });

  /// The main content to be displayed on the top layer.
  final Widget child;

  /// The number of background layers to display. Defaults to 2.
  final int stackCount;

  /// The vertical offset between each stack layer. Defaults to 8.0.
  final double stackOffset;

  /// The background color of the main body.
  final Color? backgroundColor;

  /// An optional list of colors for the stack layers. If null, colors are generated based on opacity.
  final List<Color>? stackColors;

  /// The border radius for the main body and stack layers. Defaults to [AtomicBorders.lg].
  final BorderRadius? borderRadius;

  /// The internal padding for the main body content.
  final EdgeInsetsGeometry? padding;

  /// An optional [BoxShadow] for the main body. Defaults to [AtomicShadows.lg].
  final BoxShadow? shadow;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final radius = borderRadius ?? AtomicBorders.lg;
    final bgColor = backgroundColor ?? theme.colors.surface;

    final colors = stackColors ??
        List.generate(stackCount, (index) {
          final opacity = 0.05 + (index * 0.02);
          return theme.colors.gray500.withValues(alpha: opacity);
        });

    return Stack(
      children: [
        ...List.generate(stackCount, (index) {
          final reverseIndex = stackCount - index - 1;
          final offset = stackOffset * (reverseIndex + 1);

          return Positioned(
            left: 0,
            right: 0,
            top: offset,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: colors[reverseIndex],
                borderRadius: radius,
              ),
            ),
          );
        }),
        Container(
          margin: EdgeInsets.only(top: stackOffset * stackCount),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: radius,
            boxShadow: shadow != null ? [shadow!] : AtomicShadows.lg,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: padding != null
                ? Padding(padding: padding!, child: child)
                : child,
          ),
        ),
      ],
    );
  }
}
