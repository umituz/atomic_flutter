import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/animations/atomic_animations.dart';

/// Atomic Shimmer Component
/// Skeleton loading effect for content placeholders
class AtomicShimmer extends StatefulWidget {
  const AtomicShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.child,
    this.duration = AtomicAnimations.shimmer,
    this.enabled = true,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Widget? child;
  final Duration duration;
  final bool enabled;

  @override
  State<AtomicShimmer> createState() => _AtomicShimmerState();
}

class _AtomicShimmerState extends State<AtomicShimmer> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    ));
    
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AtomicShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final baseColor = widget.baseColor ?? theme.colors.gray200;
    final highlightColor = widget.highlightColor ?? theme.colors.gray100;

    if (!widget.enabled) {
      return widget.child ?? _buildDefaultContainer(baseColor);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [
                0.0,
                0.5,
                1.0,
              ],
              transform: _ShimmerSlideTransform(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child ?? _buildDefaultContainer(baseColor),
        );
      },
    );
  }

  Widget _buildDefaultContainer(Color color) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: widget.borderRadius ?? AtomicBorders.md,
      ),
    );
  }
}

/// Transform for shimmer slide effect
class _ShimmerSlideTransform extends GradientTransform {
  const _ShimmerSlideTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Atomic Shimmer List Component
/// Pre-built shimmer list for common loading states
class AtomicShimmerList extends StatelessWidget {
  const AtomicShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.spacing = 16,
    this.padding,
    this.scrollDirection = Axis.vertical,
  });

  final int itemCount;
  final double itemHeight;
  final double spacing;
  final EdgeInsets? padding;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return ListView.separated(
      padding: padding ?? EdgeInsets.all(theme.spacing.md),
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(
        width: scrollDirection == Axis.horizontal ? spacing : 0,
        height: scrollDirection == Axis.vertical ? spacing : 0,
      ),
      itemBuilder: (context, index) {
        return AtomicShimmer(
          width: scrollDirection == Axis.horizontal ? 200 : null,
          height: itemHeight,
        );
      },
    );
  }
}

/// Atomic Shimmer Card Component
/// Pre-built shimmer card for loading states
class AtomicShimmerCard extends StatelessWidget {
  const AtomicShimmerCard({
    super.key,
    this.showAvatar = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showAction = false,
  });

  final bool showAvatar;
  final bool showTitle;
  final bool showSubtitle;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Container(
      padding: EdgeInsets.all(theme.spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar) ...[
            const AtomicShimmer(
              width: 48,
              height: 48,
              borderRadius: AtomicBorders.full,
            ),
            SizedBox(width: theme.spacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTitle) ...[
                  const AtomicShimmer(
                    height: 20,
                    width: double.infinity,
                  ),
                  SizedBox(height: theme.spacing.xs),
                ],
                if (showSubtitle) ...[
                  const AtomicShimmer(
                    height: 16,
                    width: double.infinity,
                  ),
                  SizedBox(height: theme.spacing.xxs),
                  const AtomicShimmer(
                    height: 16,
                    width: 200,
                  ),
                ],
              ],
            ),
          ),
          if (showAction) ...[
            SizedBox(width: theme.spacing.md),
            const AtomicShimmer(
              width: 24,
              height: 24,
              borderRadius: AtomicBorders.sm,
            ),
          ],
        ],
      ),
    );
  }
}
