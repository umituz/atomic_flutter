import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';

import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter/tokens/shadows/atomic_shadows.dart';

class AtomicStackedBody extends StatelessWidget {
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

  final Widget child;
  final int stackCount;
  final double stackOffset;
  final Color? backgroundColor;
  final List<Color>? stackColors;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
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