import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';

import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/animations/atomic_animations.dart';

class AtomicCustomSheetBody extends StatelessWidget {
  const AtomicCustomSheetBody({
    super.key,
    this.child,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.maxHeight,
    this.showDragIndicator = true,
    this.dragIndicatorColor,
    this.scrollable = true,
  });

  final Widget? child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;
  final double? maxHeight;
  final bool showDragIndicator;
  final Color? dragIndicatorColor;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    
    final content = Container(
      constraints: BoxConstraints(
        minHeight: minHeight ?? screenHeight * 0.2,
        maxHeight: maxHeight ?? screenHeight * 0.9,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.surface,
        borderRadius: borderRadius ?? const BorderRadius.vertical(
          top: Radius.circular(AtomicBorders.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragIndicator) _buildDragIndicator(theme),
          Flexible(
            child: scrollable 
              ? SingleChildScrollView(
                  padding: padding ?? EdgeInsets.all(theme.spacing.lg),
                  physics: const BouncingScrollPhysics(),
                  child: child ?? const SizedBox.shrink(),
                )
              : Padding(
                  padding: padding ?? EdgeInsets.all(theme.spacing.lg),
                  child: child ?? const SizedBox.shrink(),
                ),
          ),
        ],
      ),
    );

    return AnimatedContainer(
      duration: AtomicAnimations.normal,
      child: content,
    );
  }

  Widget _buildDragIndicator(AtomicThemeData theme) {
    return Container(
      margin: EdgeInsets.only(top: theme.spacing.sm),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: dragIndicatorColor ?? theme.colors.gray300,
        borderRadius: AtomicBorders.full,
      ),
    );
  }
} 