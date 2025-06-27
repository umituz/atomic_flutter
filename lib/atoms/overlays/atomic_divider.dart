import 'package:flutter/material.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/spacing/atomic_spacing.dart';

/// Atomic Divider Component
/// Visual separator with customizable styling
class AtomicDivider extends StatelessWidget {
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

  final double thickness;
  final Color? color;
  final double indent;
  final double endIndent;
  final EdgeInsets? margin;
  final AtomicDividerOrientation orientation;
  final AtomicDividerVariant variant;
  final String? text;
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
                style: textStyle ?? const TextStyle(
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

/// Divider orientation options
enum AtomicDividerOrientation {
  horizontal,
  vertical,
}

/// Divider variant options
enum AtomicDividerVariant {
  solid,
  dashed,
  dotted,
} 