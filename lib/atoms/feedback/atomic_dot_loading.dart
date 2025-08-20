import 'dart:async';
import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/themes/atomic_theme_data.dart';

import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';

class AtomicDotLoading extends StatefulWidget {
  const AtomicDotLoading({
    super.key,
    this.dotCount = 3,
    this.animationDuration = const Duration(milliseconds: 275),
    this.activeColor,
    this.inactiveColor,
    this.dotSize = AtomicDotLoadingSize.medium,
    this.spacing,
  });

  final int dotCount;
  final Duration animationDuration;
  final Color? activeColor;
  final Color? inactiveColor;
  final AtomicDotLoadingSize dotSize;
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
    final inactiveColor = widget.inactiveColor ?? theme.colors.primary.withValues(alpha: 0.3);
    final spacing = widget.spacing ?? _getSpacing(theme);

    return SizedBox(
      height: _getMaxSize(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.dotCount, (index) {
          final isActive = _currentDot == index;
          final isNext = _currentDot == ((index - 1 + widget.dotCount) % widget.dotCount);
          
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

enum AtomicDotLoadingSize {
  small,
  medium,
  large,
} 