import 'package:flutter/material.dart';

/// A customizable icon-only button component following atomic design principles.
///
/// The [AtomicIconButton] provides a compact and versatile button solution
/// for actions represented solely by an icon. It supports various visual variants,
/// sizes, loading states, and tooltips for enhanced user experience.
///
/// Features:
/// - Multiple variants (filled, outlined, ghost, subtle)
/// - Three sizes (small, medium, large)
/// - Loading state with animated indicator
/// - Optional tooltip for accessibility and clarity
/// - Customizable icon and background colors
/// - Smooth animations and hover effects
///
/// Example usage:
/// ```dart
/// AtomicIconButton(
///   icon: Icons.settings,
///   onPressed: () => _openSettings(),
///   variant: AtomicIconButtonVariant.filled,
///   size: AtomicIconButtonSize.large,
///   tooltip: 'Open Settings',
/// )
/// ```
class AtomicIconButton extends StatefulWidget {
  const AtomicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = AtomicIconButtonVariant.ghost,
    this.size = AtomicIconButtonSize.medium,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.isLoading = false,
    this.isDisabled = false,
  });

  /// The icon to display within the button.
  final IconData icon;

  /// The callback function executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The visual variant of the icon button. Defaults to [AtomicIconButtonVariant.ghost].
  final AtomicIconButtonVariant variant;

  /// The size of the icon button. Defaults to [AtomicIconButtonSize.medium].
  final AtomicIconButtonSize size;

  /// The color of the icon. If null, the color is determined by the [variant].
  final Color? color;

  /// The background color of the button. If null, the color is determined by the [variant].
  final Color? backgroundColor;

  /// An optional text to display when the button is long-pressed or hovered over.
  final String? tooltip;

  /// If true, a loading indicator is shown instead of the icon. Defaults to false.
  final bool isLoading;

  /// If true, the button is disabled and cannot be pressed. Defaults to false.
  final bool isDisabled;

  @override
  State<AtomicIconButton> createState() => _AtomicIconButtonState();
}

/// Defines the visual variants of an [AtomicIconButton].
enum AtomicIconButtonVariant {
  /// A solid button with a filled background.
  filled,

  /// A button with a transparent background and a border.
  outlined,

  /// A button with no background or border, typically for subtle actions.
  ghost,

  /// A button with a subtle background tint, often used for less prominent actions.
  subtle,
}

/// Defines the size variants of an [AtomicIconButton].
enum AtomicIconButtonSize {
  /// A small icon button, suitable for compact UIs.
  small,

  /// A medium-sized icon button, the default size.
  medium,

  /// A large icon button, suitable for prominent actions.
  large,
}

class _AtomicIconButtonState extends State<AtomicIconButton> 
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        width: _getButtonSize(),
        height: _getButtonSize(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.backgroundColor,
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    Widget iconButton = Container(
      width: _getButtonSize(),
      height: _getButtonSize(),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBackgroundColor(),
        border: _getBorder(),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_getButtonSize() / 2),
          onTap: widget.isDisabled ? null : widget.onPressed,
          child: Center(
            child: Icon(
              widget.icon,
              size: _getIconSize(),
              color: _getIconColor(),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: iconButton,
      );
    }

    return iconButton;
  }

  double _getButtonSize() {
    switch (widget.size) {
      case AtomicIconButtonSize.small:
        return 32;
      case AtomicIconButtonSize.medium:
        return 40;
      case AtomicIconButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AtomicIconButtonSize.small:
        return 16;
      case AtomicIconButtonSize.medium:
        return 20;
      case AtomicIconButtonSize.large:
        return 24;
    }
  }

  Color? _getBackgroundColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor;
    if (widget.isDisabled) return Colors.grey.shade300;

    switch (widget.variant) {
      case AtomicIconButtonVariant.filled:
        return Theme.of(context).primaryColor;
      case AtomicIconButtonVariant.outlined:
        return Colors.transparent;
      case AtomicIconButtonVariant.ghost:
        return Colors.transparent;
      case AtomicIconButtonVariant.subtle:
        return Theme.of(context).primaryColor.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    if (widget.color != null) return widget.color!;
    if (widget.isDisabled) return Colors.grey.shade600;

    switch (widget.variant) {
      case AtomicIconButtonVariant.filled:
        return Colors.white;
      case AtomicIconButtonVariant.outlined:
        return Theme.of(context).primaryColor;
      case AtomicIconButtonVariant.ghost:
        return Theme.of(context).iconTheme.color ?? Colors.black;
      case AtomicIconButtonVariant.subtle:
        return Theme.of(context).primaryColor;
    }
  }

  Border? _getBorder() {
    if (widget.variant == AtomicIconButtonVariant.outlined) {
      return Border.all(
        color: widget.isDisabled 
          ? Colors.grey.shade300 
          : Theme.of(context).primaryColor,
        width: 1,
      );
    }
    return null;
  }
}
