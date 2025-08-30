import 'dart:async';

import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/atoms/icons/atomic_icon.dart';

/// A utility class for displaying temporary, non-intrusive messages to the user.
///
/// The [AtomicToast] provides a simple way to show feedback messages (success,
/// error, warning, info) that appear briefly and then disappear. It supports
/// various positions, durations, and customizable content.
///
/// Features:
/// - Static methods for easy display of toasts.
/// - Multiple variants ([AtomicToastVariant]) for different message types.
/// - Customizable position ([AtomicToastPosition]) (top, bottom, center).
/// - Adjustable display duration.
/// - Optional title, icon, and tap callback.
/// - Optional close button for user dismissal.
/// - Swipe to dismiss functionality.
///
/// Example usage:
/// ```dart
/// // Show a success toast
/// AtomicToast.success(
///   context: context,
///   message: 'Item added to cart!',
///   title: 'Success',
/// );
///
/// // Show a custom info toast at the top
/// AtomicToast.show(
///   context: context,
///   message: 'New update available.',
///   icon: Icons.system_update,
///   variant: AtomicToastVariant.info,
///   position: AtomicToastPosition.top,
///   duration: const Duration(seconds: 5),
///   showCloseButton: true,
///   onTap: () {
///     print('Toast tapped!');
///   },
/// );
/// ```
class AtomicToast {
  static OverlayEntry? _currentToast;

  /// Displays a customizable toast message.
  ///
  /// [context] is the BuildContext to show the toast in.
  /// [message] is the main text content of the toast.
  /// [title] is an optional bold title displayed above the message.
  /// [icon] is an optional leading icon for the toast.
  /// [variant] specifies the toast's visual style. Defaults to [AtomicToastVariant.info].
  /// [position] defines where the toast appears on the screen. Defaults to [AtomicToastPosition.bottom].
  /// [duration] is how long the toast remains visible. Defaults to 3 seconds. Set to [Duration.zero] for infinite.
  /// [onTap] is the callback function executed when the toast is tapped.
  /// [onDismiss] is the callback function executed when the toast is dismissed (either automatically or by user).
  /// [showCloseButton] if true, displays a close button on the toast. Defaults to false.
  /// [width] specifies a fixed width for the toast. If null, it adapts to content up to maxWidth.
  /// [margin] is the external margin around the toast.
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
    dismiss(); // Dismiss any existing toast before showing a new one.

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

  /// Displays a success-themed toast message.
  ///
  /// Defaults to [Icons.check_circle] as the icon and [AtomicToastVariant.success].
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

  /// Displays an error-themed toast message.
  ///
  /// Defaults to [Icons.error] as the icon and [AtomicToastVariant.error].
  /// Includes a close button by default.
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

  /// Displays a warning-themed toast message.
  ///
  /// Defaults to [Icons.warning] as the icon and [AtomicToastVariant.warning].
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

  /// Displays an info-themed toast message.
  ///
  /// Defaults to [Icons.info] as the icon and [AtomicToastVariant.info].
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

  /// Dismisses the currently displayed toast, if any.
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
          ? mediaQuery.padding.bottom +
              (widget.margin?.bottom ?? theme.spacing.md)
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

/// Defines the visual variants for an [AtomicToast].
enum AtomicToastVariant {
  /// A success-themed toast.
  success,

  /// An error-themed toast.
  error,

  /// A warning-themed toast.
  warning,

  /// An informational toast.
  info,

  /// A neutral-themed toast.
  neutral,
}

/// Defines the possible positions for an [AtomicToast] on the screen.
enum AtomicToastPosition {
  /// Positions the toast at the top of the screen.
  top,

  /// Positions the toast at the bottom of the screen.
  bottom,

  /// Positions the toast in the center of the screen.
  center,
}
