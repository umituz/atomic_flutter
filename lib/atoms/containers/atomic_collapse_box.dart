import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/atoms/containers/atomic_card.dart';
import 'package:atomic_flutter_kit/atoms/icons/atomic_icon.dart';

/// A collapsible box widget that expands and collapses its content with animation.
///
/// The [AtomicCollapseBox] provides a visually appealing way to hide and show
/// content. It features a title, optional subtitle and icon, and customizable
/// appearance and animation.
///
/// Features:
/// - Animated expansion and collapse of content.
/// - Customizable title, subtitle, and leading icon.
/// - Optional callback for expansion state changes.
/// - Customizable background color, border radius, padding, and margin.
/// - Option to show or hide a border.
/// - Control over animation duration and curve.
///
/// Example usage:
/// ```dart
/// AtomicCollapseBox(
///   title: 'Section Title',
///   subtitle: 'Click to expand',
///   icon: Icons.info_outline,
///   initiallyExpanded: false,
///   onExpansionChanged: (expanded) {
///     print('Expanded: $expanded');
///   },
///   child: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Text('This is the collapsible content.'),
///   ),
/// )
/// ```
class AtomicCollapseBox extends StatefulWidget {
  /// Creates an [AtomicCollapseBox].
  ///
  /// [child] is the content to be displayed when the box is expanded.
  /// [title] is the primary text displayed in the header of the collapse box.
  /// [subtitle] is an optional secondary text displayed below the title.
  /// [icon] is an optional leading icon displayed in the header.
  /// [initiallyExpanded] determines if the box is expanded by default. Defaults to false.
  /// [onExpansionChanged] is a callback function that is called when the expansion state changes.
  /// [backgroundColor] is the background color of the collapse box.
  /// [borderRadius] is the border radius of the collapse box.
  /// [padding] is the internal padding of the header.
  /// [margin] is the external margin around the collapse box.
  /// [showBorder] determines if a border should be displayed around the box. Defaults to true.
  /// [animationDuration] is the duration of the expansion/collapse animation. Defaults to [AtomicAnimations.normal].
  /// [animationCurve] is the curve used for the expansion/collapse animation. Defaults to [AtomicAnimations.standardEasing].
  const AtomicCollapseBox({
    super.key,
    required this.child,
    required this.title,
    this.subtitle,
    this.icon,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.showBorder = true,
    this.animationDuration = AtomicAnimations.normal,
    this.animationCurve = AtomicAnimations.standardEasing,
  });

  /// The content to be displayed when the box is expanded.
  final Widget child;

  /// The primary text displayed in the header of the collapse box.
  final String title;

  /// An optional secondary text displayed below the title.
  final String? subtitle;

  /// An optional leading icon displayed in the header.
  final IconData? icon;

  /// Determines if the box is expanded by default. Defaults to false.
  final bool initiallyExpanded;

  /// A callback function that is called when the expansion state changes.
  final ValueChanged<bool>? onExpansionChanged;

  /// The background color of the collapse box.
  final Color? backgroundColor;

  /// The border radius of the collapse box.
  final BorderRadius? borderRadius;

  /// The internal padding of the header.
  final EdgeInsets? padding;

  /// The external margin around the collapse box.
  final EdgeInsets? margin;

  /// Determines if a border should be displayed around the box. Defaults to true.
  final bool showBorder;

  /// The duration of the expansion/collapse animation. Defaults to [AtomicAnimations.normal].
  final Duration animationDuration;

  /// The curve used for the expansion/collapse animation. Defaults to [AtomicAnimations.standardEasing].
  final Curve animationCurve;

  @override
  State<AtomicCollapseBox> createState() => _AtomicCollapseBoxState();
}

class _AtomicCollapseBoxState extends State<AtomicCollapseBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _iconTurns = _controller.drive(
      Tween<double>(begin: 0.0, end: 0.5).chain(
        CurveTween(curve: widget.animationCurve),
      ),
    );
    _heightFactor = _controller.drive(
      CurveTween(curve: widget.animationCurve),
    );
    _isExpanded = widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final closed = !_isExpanded && _controller.isDismissed;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AtomicCard(
          margin: widget.margin,
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius,
          border: widget.showBorder
              ? Border.all(
                  color: theme.colors.gray200,
                  width: 1,
                )
              : null,
          shadow: AtomicCardShadow.none,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _handleTap,
                borderRadius: widget.borderRadius ?? AtomicBorders.card,
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(theme.spacing.md),
                  child: Row(
                    children: [
                      if (widget.icon != null) ...[
                        AtomicIcon(
                          icon: widget.icon!,
                          color: theme.colors.primary,
                          size: AtomicIconSize.medium,
                        ),
                        SizedBox(width: theme.spacing.sm),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: theme.typography.titleMedium.copyWith(
                                color: theme.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              SizedBox(height: theme.spacing.xxs),
                              Text(
                                widget.subtitle!,
                                style: theme.typography.bodySmall.copyWith(
                                  color: theme.colors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      RotationTransition(
                        turns: _iconTurns,
                        child: AtomicIcon(
                          icon: Icons.expand_more,
                          color: theme.colors.textSecondary,
                          size: AtomicIconSize.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      child: closed ? null : widget.child,
    );
  }
}
