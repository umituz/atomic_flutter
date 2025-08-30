import 'dart:async';
import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';

import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

/// A visually engaging loading indicator composed of animating dots.
///
/// The [AtomicDotLoading] widget provides a subtle yet effective way to
/// indicate ongoing processes. It features a series of dots that animate
/// sequentially, creating a continuous loading effect.
///
/// Features:
/// - Customizable number of dots.
/// - Adjustable animation speed.
/// - Customizable active and inactive dot colors.
/// - Three predefined dot sizes ([AtomicDotLoadingSize]).
/// - Customizable spacing between dots.
///
/// Example usage:
/// ```dart
/// AtomicDotLoading(
///   dotCount: 4,
///   animationDuration: const Duration(milliseconds: 300),
///   activeColor: Colors.deepPurple,
///   inactiveColor: Colors.deepPurple.withOpacity(0.3),
///   dotSize: AtomicDotLoadingSize.large,
/// )
/// ```
class AtomicDotLoading extends StatefulWidget {
  /// Creates an [AtomicDotLoading] indicator.
  ///
  /// [dotCount] specifies the number of dots in the animation. Defaults to 3.
  /// [animationDuration] controls the speed of the animation for each dot. Defaults to 275ms.
  /// [activeColor] is the color of the currently active dot.
  /// [inactiveColor] is the color of the inactive dots.
  /// [dotSize] defines the size of the dots. Defaults to [AtomicDotLoadingSize.medium].
  /// [spacing] is the horizontal spacing between dots.
  const AtomicDotLoading({
    super.key,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 275),
    this.activeColor,
    this.inactiveColor,
    this.dotSize = AtomicDotLoadingSize.medium,
    this.spacing,
  });

  /// The number of dots in the animation. Defaults to 3.
  final int dotCount;

  /// The duration of the animation for each dot. Defaults to 275ms.
  final Duration animationDuration;

  /// The color of the currently active dot.
  final Color? activeColor;

  /// The color of the inactive dots.
  final Color? inactiveColor;

  /// The size of the dots. Defaults to [AtomicDotLoadingSize.medium].
  final AtomicDotLoadingSize dotSize;

  /// The horizontal spacing between dots.
  final double? spacing;

  @override
  State<AtomicDotLoading> createState() => _AtomicDotLoadingState();
}

class _AtomicDotLoadingState extends State<AtomicDotLoading> {
  int _currentDot = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.animationDuration, (timer) {
      if (mounted) {
        setState(() {
          _currentDot = (_currentDot + 1) % widget.dotCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final activeColor = widget.activeColor ?? theme.colors.primary;
    final inactiveColor =
        widget.inactiveColor ?? theme.colors.primary.withValues(alpha: 0.3);
    final spacing = widget.spacing ?? _getSpacing(theme);

    return SizedBox(
      height: _getMaxSize(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.dotCount, (index) {
          final isActive = _currentDot == index;
          final isNext =
              _currentDot == ((index - 1 + widget.dotCount) % widget.dotCount);

          return Padding(
            padding: EdgeInsets.only(
              right: index < widget.dotCount - 1 ? spacing : 0,
            ),
            child: AnimatedContainer(
              duration: AtomicAnimations.normal,
              curve: AtomicAnimations.bounceOut,
              width: _getDotSize(isActive, isNext),
              height: _getDotSize(isActive, isNext),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? activeColor
                    : isNext
                        ? activeColor.withValues(alpha: 0.86)
                        : inactiveColor,
              ),
            ),
          );
        }),
      ),
    );
  }

  double _getDotSize(bool isActive, bool isNext) {
    final baseSize = _getBaseSize();
    if (isActive) {
      return baseSize * 1.4;
    } else if (isNext) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  double _getBaseSize() {
    switch (widget.dotSize) {
      case AtomicDotLoadingSize.small:
        return 6;
      case AtomicDotLoadingSize.medium:
        return 8;
      case AtomicDotLoadingSize.large:
        return 10;
    }
  }

  double _getMaxSize() {
    return _getBaseSize() * 1.4;
  }

  double _getSpacing(AtomicThemeData theme) {
    switch (widget.dotSize) {
      case AtomicDotLoadingSize.small:
        return theme.spacing.xxs;
      case AtomicDotLoadingSize.medium:
        return theme.spacing.xs;
      case AtomicDotLoadingSize.large:
        return theme.spacing.sm;
    }
  }
}

/// Defines the predefined sizes for the dots in [AtomicDotLoading].
enum AtomicDotLoadingSize {
  /// Small dots.
  small,

  /// Medium-sized dots.
  medium,

  /// Large dots.
  large,
}
