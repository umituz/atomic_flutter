import 'package:flutter/material.dart';
import '../../tokens/colors/atomic_colors.dart';

/// Atomic Loader Component
/// Customizable loading indicator
class AtomicLoader extends StatelessWidget {
  const AtomicLoader({
    super.key,
    this.size = AtomicLoaderSize.medium,
    this.color,
    this.strokeWidth,
    this.value,
  });

  final AtomicLoaderSize size;
  final Color? color;
  final double? strokeWidth;
  final double? value;

  @override
  Widget build(BuildContext context) {
    final dimension = _getSize();
    final stroke = strokeWidth ?? _getStrokeWidth();

    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: stroke,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AtomicColors.primary,
        ),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case AtomicLoaderSize.small:
        return 16;
      case AtomicLoaderSize.medium:
        return 24;
      case AtomicLoaderSize.large:
        return 36;
      case AtomicLoaderSize.huge:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case AtomicLoaderSize.small:
        return 2;
      case AtomicLoaderSize.medium:
        return 3;
      case AtomicLoaderSize.large:
        return 4;
      case AtomicLoaderSize.huge:
        return 5;
    }
  }
}

/// Loader size options
enum AtomicLoaderSize {
  small,
  medium,
  large,
  huge,
} 