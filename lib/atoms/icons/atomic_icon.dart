import 'package:flutter/material.dart';
import '../../tokens/colors/atomic_colors.dart';

/// Atomic Icon Component
/// Standardized icon component with consistent sizing and colors
class AtomicIcon extends StatelessWidget {
  const AtomicIcon({
    super.key,
    required this.icon,
    this.size = AtomicIconSize.medium,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final AtomicIconSize size;
  final Color? color;
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

/// Icon size options
enum AtomicIconSize {
  tiny,
  small,
  medium,
  large,
  huge,
} 