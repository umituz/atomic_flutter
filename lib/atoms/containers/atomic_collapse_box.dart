import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter/atoms/containers/atomic_card.dart';
import 'package:atomic_flutter/atoms/icons/atomic_icon.dart';

class AtomicCollapseBox extends StatefulWidget {
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

  final Widget child;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool showBorder;
  final Duration animationDuration;
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