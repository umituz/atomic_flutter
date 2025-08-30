import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';

/// A customizable circular loading indicator.
///
/// The [AtomicLoader] widget provides a visual cue that an operation is in progress.
/// It's a wrapper around Flutter's [CircularProgressIndicator] with predefined
/// sizes and customizable color and stroke width.
///
/// Features:
/// - Four predefined sizes ([AtomicLoaderSize]).
/// - Customizable color.
/// - Adjustable stroke width.
/// - Support for determinate progress indication.
///
/// Example usage:
/// ```dart
/// // Indeterminate loader
/// AtomicLoader(
///   size: AtomicLoaderSize.medium,
///   color: Colors.blue,
/// )
///
/// // Determinate loader
/// AtomicLoader(
///   size: AtomicLoaderSize.large,
///   value: 0.75, // 75% complete
///   color: Colors.green,
/// )
/// ```
class AtomicLoader extends StatelessWidget {
  /// Creates an [AtomicLoader] widget.
  ///
  /// [size] defines the overall size of the loader. Defaults to [AtomicLoaderSize.medium].
  /// [color] is the color of the progress indicator. Defaults to [AtomicColors.primary].
  /// [strokeWidth] is the width of the progress indicator's stroke.
  /// [value] is the progress value (0.0 to 1.0) for a determinate indicator.
  /// If null, the indicator is indeterminate.
  const AtomicLoader({
    super.key,
    this.size = AtomicLoaderSize.medium,
    this.color,
    this.strokeWidth,
    this.value,
  });

  /// The size of the loader. Defaults to [AtomicLoaderSize.medium].
  final AtomicLoaderSize size;

  /// The color of the progress indicator. Defaults to [AtomicColors.primary].
  final Color? color;

  /// The width of the progress indicator's stroke.
  final double? strokeWidth;

  /// The progress value (0.0 to 1.0) for a determinate indicator.
  /// If null, the indicator is indeterminate.
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

/// Defines the predefined sizes for an [AtomicLoader].
enum AtomicLoaderSize {
  /// A small loader.
  small,

  /// A medium-sized loader.
  medium,

  /// A large loader.
  large,

  /// A very large loader.
  huge,
}
