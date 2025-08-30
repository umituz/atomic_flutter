import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';

import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

/// A customizable body component for bottom sheets or other overlay panels.
///
/// The [AtomicCustomSheetBody] provides a flexible container for content
/// that typically appears in a bottom sheet. It includes options for
/// background color, border radius, padding, height constraints, and a
/// draggable indicator.
///
/// Features:
/// - Customizable background color and border radius.
/// - Adjustable padding for content.
/// - Control over minimum and maximum height.
/// - Optional drag indicator at the top.
/// - Customizable drag indicator color.
/// - Option to make the content scrollable.
///
/// Example usage:
/// ```dart
/// AtomicCustomSheetBody(
///   backgroundColor: Colors.blue.shade50,
///   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
///   minHeight: 200,
///   maxHeight: 400,
///   showDragIndicator: true,
///   child: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Column(
///       mainAxisSize: MainAxisSize.min,
///       children: [
///         Text(
///           'Sheet Content',
///           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
///         ),
///         SizedBox(height: 10),
///         Text('This is some custom content inside the sheet body.'),
///         // ... more content
///       ],
///     ),
///   ),
/// )
/// ```
class AtomicCustomSheetBody extends StatelessWidget {
  /// Creates an [AtomicCustomSheetBody] widget.
  ///
  /// [child] is the content to be displayed within the sheet body.
  /// [backgroundColor] is the background color of the sheet.
  /// [borderRadius] is the border radius of the sheet.
  /// [padding] is the internal padding for the content.
  /// [minHeight] is the minimum height of the sheet.
  /// [maxHeight] is the maximum height of the sheet.
  /// [showDragIndicator] if true, a drag indicator is displayed at the top. Defaults to true.
  /// [dragIndicatorColor] is the color of the drag indicator.
  /// [scrollable] if true, the child content will be wrapped in a [SingleChildScrollView]. Defaults to true.
  const AtomicCustomSheetBody({
    super.key,
    this.child,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.maxHeight,
    this.showDragIndicator = true,
    this.dragIndicatorColor,
    this.scrollable = true,
  });

  /// The content to be displayed within the sheet body.
  final Widget? child;

  /// The background color of the sheet.
  final Color? backgroundColor;

  /// The border radius of the sheet. Defaults to a large top border radius.
  final BorderRadius? borderRadius;

  /// The internal padding for the content.
  final EdgeInsetsGeometry? padding;

  /// The minimum height of the sheet.
  final double? minHeight;

  /// The maximum height of the sheet.
  final double? maxHeight;

  /// If true, a drag indicator is displayed at the top. Defaults to true.
  final bool showDragIndicator;

  /// The color of the drag indicator.
  final Color? dragIndicatorColor;

  /// If true, the child content will be wrapped in a [SingleChildScrollView]. Defaults to true.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final content = Container(
      constraints: BoxConstraints(
        minHeight: minHeight ?? screenHeight * 0.2,
        maxHeight: maxHeight ?? screenHeight * 0.9,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.surface,
        borderRadius: borderRadius ??
            const BorderRadius.vertical(
              top: Radius.circular(AtomicBorders.radiusLg),
            ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragIndicator) _buildDragIndicator(theme),
          Flexible(
            child: scrollable
                ? SingleChildScrollView(
                    padding: padding ?? EdgeInsets.all(theme.spacing.lg),
                    physics: const BouncingScrollPhysics(),
                    child: child ?? const SizedBox.shrink(),
                  )
                : Padding(
                    padding: padding ?? EdgeInsets.all(theme.spacing.lg),
                    child: child ?? const SizedBox.shrink(),
                  ),
          ),
        ],
      ),
    );

    return AnimatedContainer(
      duration: AtomicAnimations.normal,
      child: content,
    );
  }

  Widget _buildDragIndicator(AtomicThemeData theme) {
    return Container(
      margin: EdgeInsets.only(top: theme.spacing.sm),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: dragIndicatorColor ?? theme.colors.gray300,
        borderRadius: AtomicBorders.full,
      ),
    );
  }
}
