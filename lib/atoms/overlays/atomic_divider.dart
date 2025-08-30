import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';

/// A customizable divider component for separating content.
///
/// The [AtomicDivider] provides a visual separation between elements,
/// supporting both horizontal and vertical orientations, various styles
/// (solid, dashed, dotted), and optional text in the middle for horizontal dividers.
///
/// Features:
/// - Customizable thickness and color.
/// - Adjustable indent and end indent.
/// - Supports horizontal ([AtomicDividerOrientation.horizontal]) and vertical ([AtomicDividerOrientation.vertical]) orientations.
/// - Three visual variants ([AtomicDividerVariant]): solid, dashed, and dotted.
/// - Optional text label in the middle of horizontal dividers.
/// - Customizable margin.
///
/// Example usage:
/// ```dart
/// // Horizontal solid divider
/// AtomicDivider(
///   thickness: 2,
///   color: Colors.grey,
///   margin: EdgeInsets.symmetric(vertical: 16),
/// )
///
/// // Horizontal divider with text
/// AtomicDivider(
///   text: 'OR',
///   variant: AtomicDividerVariant.dashed,
/// )
///
/// // Vertical divider
/// SizedBox(
///   height: 50,
///   child: AtomicDivider(
///     orientation: AtomicDividerOrientation.vertical,
///     thickness: 1,
///     color: Colors.blue,
///   ),
/// )
/// ```
class AtomicDivider extends StatelessWidget {
  /// Creates an [AtomicDivider] widget.
  ///
  /// [thickness] is the thickness of the divider line. Defaults to 1.
  /// [color] is the color of the divider. Defaults to [AtomicColors.dividerColor].
  /// [indent] is the amount of empty space to the leading edge of the divider.
  /// [endIndent] is the amount of empty space to the trailing edge of the divider.
  /// [margin] is the external margin around the divider.
  /// [orientation] specifies whether the divider is horizontal or vertical. Defaults to [AtomicDividerOrientation.horizontal].
  /// [variant] defines the visual style of the divider. Defaults to [AtomicDividerVariant.solid].
  /// [text] is an optional text label to display in the middle of a horizontal divider.s
  /// [textStyle] is the [TextStyle] for the text label.
  const AtomicDivider({
    super.key,
    this.thickness = 1,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
    this.margin,
    this.orientation = AtomicDividerOrientation.horizontal,
    this.variant = AtomicDividerVariant.solid,
    this.text,
    this.textStyle,
  });

  /// The thickness of the divider line. Defaults to 1.
  final double thickness;

  /// The color of the divider. Defaults to [AtomicColors.dividerColor].
  final Color? color;

  /// The amount of empty space to the leading edge of the divider.
  final double indent;

  /// The amount of empty space to the trailing edge of the divider.
  final double endIndent;

  /// The external margin around the divider.
  final EdgeInsets? margin;

  /// Specifies whether the divider is horizontal or vertical. Defaults to [AtomicDividerOrientation.horizontal].
  final AtomicDividerOrientation orientation;

  /// Defines the visual style of the divider. Defaults to [AtomicDividerVariant.solid].
  final AtomicDividerVariant variant;

  /// An optional text label to display in the middle of a horizontal divider.
  final String? text;

  /// The [TextStyle] for the text label.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AtomicColors.dividerColor;

    if (text != null && orientation == AtomicDividerOrientation.horizontal) {
      return Container(
        margin: margin,
        child: Row(
          children: [
            Expanded(child: _buildDivider(dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AtomicSpacing.md),
              child: Text(
                text!,
                style: textStyle ??
                    const TextStyle(
                      color: AtomicColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Expanded(child: _buildDivider(dividerColor)),
          ],
        ),
      );
    }

    return Container(
      margin: margin,
      child: _buildDivider(dividerColor),
    );
  }

  Widget _buildDivider(Color dividerColor) {
    if (orientation == AtomicDividerOrientation.horizontal) {
      return Container(
        margin: EdgeInsets.only(left: indent, right: endIndent),
        height: thickness,
        decoration: _getDecoration(dividerColor),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: indent, bottom: endIndent),
        width: thickness,
        decoration: _getDecoration(dividerColor),
      );
    }
  }

  BoxDecoration _getDecoration(Color dividerColor) {
    switch (variant) {
      case AtomicDividerVariant.solid:
        return BoxDecoration(color: dividerColor);
      case AtomicDividerVariant.dashed:
        return BoxDecoration(
          border: orientation == AtomicDividerOrientation.horizontal
              ? Border(
                  bottom: BorderSide(
                    color: dividerColor,
                    width: thickness,
                    style: BorderStyle.solid,
                  ),
                )
              : Border(
                  right: BorderSide(
                    color: dividerColor,
                    width: thickness,
                    style: BorderStyle.solid,
                  ),
                ),
        );
      case AtomicDividerVariant.dotted:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [dividerColor, Colors.transparent],
            stops: const [0.5, 0.5],
            tileMode: TileMode.repeated,
            begin: orientation == AtomicDividerOrientation.horizontal
                ? Alignment.centerLeft
                : Alignment.topCenter,
            end: orientation == AtomicDividerOrientation.horizontal
                ? Alignment.centerRight
                : Alignment.bottomCenter,
          ),
        );
    }
  }
}

/// Defines the orientation for an [AtomicDivider].
enum AtomicDividerOrientation {
  /// A horizontal divider.
  horizontal,

  /// A vertical divider.
  vertical,
}

/// Defines the visual variants for an [AtomicDivider].
enum AtomicDividerVariant {
  /// A solid line divider.
  solid,

  /// A dashed line divider.
  dashed,

  /// A dotted line divider.
  dotted,
}
