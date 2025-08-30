import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';

/// A customizable icon widget that integrates with the Atomic Design System.
///
/// The [AtomicIcon] widget provides a convenient way to display icons with
/// predefined sizes and customizable colors. It's a wrapper around Flutter's
/// [Icon] widget, ensuring consistent icon styling across the application.
///
/// Features:
/// - Five predefined sizes ([AtomicIconSize]).
/// - Customizable color.
/// - Support for semantic labels for accessibility.
///
/// Example usage:
/// ```dart
/// AtomicIcon(
///   icon: Icons.star,
///   size: AtomicIconSize.large,
///   color: Colors.amber,
///   semanticLabel: 'Favorite star',
/// )
/// ```
class AtomicIcon extends StatelessWidget {
  /// Creates an [AtomicIcon] widget.
  ///
  /// [icon] is the icon to display.
  /// [size] defines the overall size of the icon. Defaults to [AtomicIconSize.medium].
  /// [color] is the color of the icon. Defaults to [AtomicColors.textPrimary].
  /// [semanticLabel] is a semantic label for accessibility purposes.
  const AtomicIcon({
    super.key,
    required this.icon,
    this.size = AtomicIconSize.medium,
    this.color,
    this.semanticLabel,
  });

  /// The icon to display.
  final IconData icon;

  /// The size of the icon. Defaults to [AtomicIconSize.medium].
  final AtomicIconSize size;

  /// The color of the icon. Defaults to [AtomicColors.textPrimary].
  final Color? color;

  /// A semantic label for accessibility purposes.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: _getSize(),
      color: color ?? AtomicColors.textPrimary,
      semanticLabel: semanticLabel,
    );
  }

  double _getSize() {
    switch (size) {
      case AtomicIconSize.tiny:
        return 12;
      case AtomicIconSize.small:
        return 16;
      case AtomicIconSize.medium:
        return 20;
      case AtomicIconSize.large:
        return 24;
      case AtomicIconSize.huge:
        return 32;
    }
  }
}

/// Defines the predefined sizes for an [AtomicIcon].
enum AtomicIconSize {
  /// A very small icon (12x12).
  tiny,

  /// A small icon (16x16).
  small,

  /// A medium-sized icon (20x20), often used as a default.
  medium,

  /// A large icon (24x24).
  large,

  /// A very large icon (32x32).
  huge,
}
