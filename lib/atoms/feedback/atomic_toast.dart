import 'dart:async';

import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/themes/atomic_theme_data.dart';
import 'package:atomic_flutter/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter/atoms/icons/atomic_icon.dart';

class AtomicToast {
  static OverlayEntry? _currentToast;

  static void show({
    required BuildContext context,
    required String message,
    String? title,
    IconData? icon,
    AtomicToastVariant variant = AtomicToastVariant.info,
    AtomicToastPosition position = AtomicToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    bool showCloseButton = false,
    double? width,
    EdgeInsets? margin,
  }) {
    dismiss();

    final overlay = Overlay.of(context);
    final theme = AtomicTheme.of(context);

    _currentToast = OverlayEntry(
      builder: (context) => _AtomicToastWidget(
        message: message,
        title: title,
        icon: icon,
        variant: variant,
        position: position,
        duration: duration,
        onTap: onTap,
        onDismiss: () {
          dismiss();
          onDismiss?.call();
        },
        showCloseButton: showCloseButton,
        width: width,
        margin: margin,
        theme: theme,
      ),
    );

    overlay.insert(_currentToast!);
  }

  static void success({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      icon: Icons.check_circle,
      variant: AtomicToastVariant.success,
      duration: duration,
    );
  }

  static void error({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      icon: Icons.error,
      variant: AtomicToastVariant.error,
      duration: duration,
      showCloseButton: true,
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      icon: Icons.warning,
      variant: AtomicToastVariant.warning,
      duration: duration,
    );
  }

  static void info({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      title: title,
      icon: Icons.info,
      variant: AtomicToastVariant.info,
      duration: duration,
    );
  }

  static void dismiss() {
    _currentToast?.remove();
    _currentToast = null;
  }
}

class _AtomicToastWidget extends StatefulWidget {
  const _AtomicToastWidget({
    required this.message,
    required this.variant,
    required this.position,
    required this.duration,
    required this.theme,
    this.title,
    this.icon,
    this.onTap,
    this.onDismiss,
    this.showCloseButton = false,
    this.width,
    this.margin,
  });

  final String message;
  final String? title;
  final IconData? icon;
  final AtomicToastVariant variant;
  final AtomicToastPosition position;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool showCloseButton;
  final double? width;
  final EdgeInsets? margin;
  final AtomicThemeData theme;

  @override
  State<_AtomicToastWidget> createState() => _AtomicToastWidgetState();
}

class _AtomicToastWidgetState extends State<_AtomicToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AtomicAnimations.normal,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: AtomicAnimations.decelerateEasing,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: _getStartOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AtomicAnimations.decelerateEasing,
    ));

    _controller.forward();

    if (widget.duration != Duration.zero) {
      _dismissTimer = Timer(widget.duration, _dismiss);
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Offset _getStartOffset() {
    switch (widget.position) {
      case AtomicToastPosition.top:
        return const Offset(0, -1);
      case AtomicToastPosition.bottom:
        return const Offset(0, 1);
      case AtomicToastPosition.center:
        return const Offset(0, 0);
    }
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = widget.theme;

    return Positioned(
      top: widget.position == AtomicToastPosition.top
          ? mediaQuery.padding.top + (widget.margin?.top ?? theme.spacing.md)
          : widget.position == AtomicToastPosition.center
              ? mediaQuery.size.height / 2 - 50
              : null,
      bottom: widget.position == AtomicToastPosition.bottom
          ? mediaQuery.padding.bottom + (widget.margin?.bottom ?? theme.spacing.md)
          : widget.position == AtomicToastPosition.center
              ? mediaQuery.size.height / 2 - 50
              : null,
      left: widget.margin?.left ?? theme.spacing.md,
      right: widget.margin?.right ?? theme.spacing.md,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.onTap,
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null &&
                      details.primaryVelocity!.abs() > 100) {
                    _dismiss();
                  }
                },
                child: Container(
                  width: widget.width,
                  constraints: BoxConstraints(
                    maxWidth: mediaQuery.size.width - 
                             (widget.margin?.horizontal ?? theme.spacing.md * 2),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.md,
                    vertical: theme.spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(),
                    borderRadius: AtomicBorders.md,
                    boxShadow: AtomicShadows.lg,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        AtomicIcon(
                          icon: widget.icon!,
                          color: _getContentColor(),
                          size: AtomicIconSize.medium,
                        ),
                        SizedBox(width: theme.spacing.sm),
                      ],
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.title != null) ...[
                              Text(
                                widget.title!,
                                style: theme.typography.labelLarge.copyWith(
                                  color: _getContentColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: theme.spacing.xxs),
                            ],
                            Text(
                              widget.message,
                              style: theme.typography.bodyMedium.copyWith(
                                color: _getContentColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.showCloseButton) ...[
                        SizedBox(width: theme.spacing.sm),
                        GestureDetector(
                          onTap: _dismiss,
                          child: AtomicIcon(
                            icon: Icons.close,
                            color: _getContentColor(),
                            size: AtomicIconSize.small,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.variant) {
      case AtomicToastVariant.success:
        return widget.theme.colors.success;
      case AtomicToastVariant.error:
        return widget.theme.colors.error;
      case AtomicToastVariant.warning:
        return widget.theme.colors.warning;
      case AtomicToastVariant.info:
        return widget.theme.colors.info;
      case AtomicToastVariant.neutral:
        return widget.theme.colors.gray800;
    }
  }

  Color _getContentColor() {
    switch (widget.variant) {
      case AtomicToastVariant.warning:
        return widget.theme.colors.gray900;
      default:
        return widget.theme.colors.textInverse;
    }
  }
}

enum AtomicToastVariant {
  success,
  error,
  warning,
  info,
  neutral,
}

enum AtomicToastPosition {
  top,
  bottom,
  center,
}
