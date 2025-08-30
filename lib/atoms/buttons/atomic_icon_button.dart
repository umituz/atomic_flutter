import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';

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
