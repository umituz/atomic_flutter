import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

/// A customizable shimmer effect widget for indicating loading states.
///
/// The [AtomicShimmer] widget provides a visual placeholder that animates
/// a light "shimmer" across its content, commonly used to improve user
/// experience during data loading. It can be applied to any widget or
/// used as a standalone placeholder.
///
/// Features:
/// - Customizable width and height.
/// - Adjustable border radius.
/// - Customizable base and highlight colors for the shimmer effect.
/// - Control over animation duration.
/// - Can be enabled/disabled.
/// - Can wrap any child widget.
///
/// Example usage:
/// ```dart
/// // Standalone shimmer placeholder
/// AtomicShimmer(
///   width: 200,
///   height: 100,
///   borderRadius: BorderRadius.circular(8),
/// )
///
/// // Shimmer applied to a text widget
/// AtomicShimmer(
///   child: Text(
///     'Loading Content...',
///     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
///   ),
/// )
/// ```
class AtomicShimmer extends StatefulWidget {
  /// Creates an [AtomicShimmer] widget.
  ///
  /// [width] and [height] specify the dimensions of the shimmer effect.
  /// [borderRadius] is the border radius of the shimmer container.
  /// [baseColor] is the primary color of the shimmer effect.
  /// [highlightColor] is the secondary color of the shimmer effect.
  /// [child] is the widget over which the shimmer effect will be applied.
  /// [duration] is the duration of one shimmer animation cycle. Defaults to [AtomicAnimations.shimmer].
  /// [enabled] controls whether the shimmer animation is active. Defaults to true.
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

  /// The width of the shimmer effect.
  final double? width;

  /// The height of the shimmer effect.
  final double? height;

  /// The border radius of the shimmer container. Defaults to [AtomicBorders.md].
  final BorderRadius? borderRadius;

  /// The primary color of the shimmer effect.
  final Color? baseColor;

  /// The secondary color of the shimmer effect.
  final Color? highlightColor;

  /// The widget over which the shimmer effect will be applied.
  final Widget? child;

  /// The duration of one shimmer animation cycle. Defaults to [AtomicAnimations.shimmer].
  final Duration duration;

  /// Controls whether the shimmer animation is active. Defaults to true.
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

    return RepaintBoundary(
      child: AnimatedBuilder(
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
      ),
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

class _ShimmerSlideTransform extends GradientTransform {
  const _ShimmerSlideTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// A widget that displays a list of shimmer placeholders.
///
/// The [AtomicShimmerList] is useful for indicating that a list of items
/// is loading, providing a smooth transition before the actual content appears.
///
/// Features:
/// - Customizable number of shimmer items.
/// - Adjustable item height and spacing.
/// - Supports vertical and horizontal scroll directions.
/// - Optional padding for the list.
///
/// Example usage:
/// ```dart
/// AtomicShimmerList(
///   itemCount: 3,
///   itemHeight: 120,
///   spacing: 10,
///   scrollDirection: Axis.vertical,
/// )
/// ```
class AtomicShimmerList extends StatelessWidget {
  /// Creates an [AtomicShimmerList].
  ///
  /// [itemCount] is the number of shimmer items to display. Defaults to 5.
  /// [itemHeight] is the height of each shimmer item. Defaults to 80.
  /// [spacing] is the spacing between shimmer items. Defaults to 16.
  /// [padding] is the internal padding of the list.
  /// [scrollDirection] determines the scroll direction of the list. Defaults to [Axis.vertical].
  const AtomicShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.spacing = 16,
    this.padding,
    this.scrollDirection = Axis.vertical,
  });

  /// The number of shimmer items to display. Defaults to 5.
  final int itemCount;

  /// The height of each shimmer item. Defaults to 80.
  final double itemHeight;

  /// The spacing between shimmer items. Defaults to 16.
  final double spacing;

  /// The internal padding of the list.
  final EdgeInsets? padding;

  /// The scroll direction of the list. Defaults to [Axis.vertical].
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

/// A widget that displays a shimmer placeholder for a card-like layout.
///
/// The [AtomicShimmerCard] provides a structured shimmer effect that mimics
/// the layout of a typical card with an avatar, title, subtitle, and action.
/// It's useful for indicating that card content is loading.
///
/// Features:
/// - Customizable visibility of avatar, title, subtitle, and action placeholders.
/// - Integrates with the theme for consistent spacing.
///
/// Example usage:
/// ```dart
/// AtomicShimmerCard(
///   showAvatar: true,
///   showTitle: true,
///   showSubtitle: true,
///   showAction: false,
/// )
/// ```
class AtomicShimmerCard extends StatelessWidget {
  /// Creates an [AtomicShimmerCard].
  ///
  /// [showAvatar] controls the visibility of the avatar placeholder. Defaults to true.
  /// [showTitle] controls the visibility of the title placeholder. Defaults to true.
  /// [showSubtitle] controls the visibility of the subtitle placeholder. Defaults to true.
  /// [showAction] controls the visibility of the action button placeholder. Defaults to false.
  const AtomicShimmerCard({
    super.key,
    this.showAvatar = true,
    this.showTitle = true,
    this.showSubtitle = true,
    this.showAction = false,
  });

  /// Controls the visibility of the avatar placeholder. Defaults to true.
  final bool showAvatar;

  /// Controls the visibility of the title placeholder. Defaults to true.
  final bool showTitle;

  /// Controls the visibility of the subtitle placeholder. Defaults to true.
  final bool showSubtitle;

  /// Controls the visibility of the action button placeholder. Defaults to false.
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
