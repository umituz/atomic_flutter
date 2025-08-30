import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';

/// A customizable text widget that integrates with the Atomic Design System's typography.
///
/// The [AtomicText] widget provides a convenient way to display text with predefined
/// typographic styles from the application's theme. It supports all standard
/// [Text] widget properties and offers named constructors for quick access to
/// common text styles (e.g., `displayLarge`, `bodyMedium`).
///
/// Features:
/// - Automatic application of theme typography.
/// - Named constructors for all Material Design 3 text styles.
/// - Customizable [TextStyle] to override or merge with theme styles.
/// - Support for text alignment, overflow, soft wrap, and max lines.
/// - Adjustable line height.
///
/// Example usage:
/// ```dart
/// // Using a named constructor for a predefined style
/// AtomicText.headlineLarge(
///   'Welcome to Atomic Kit!',
///   textAlign: TextAlign.center,
/// )
///
/// // Using the default constructor with a custom style
/// AtomicText(
///   'Custom Text',
///   style: TextStyle(
///     fontSize: 20,
///     fontWeight: FontWeight.bold,
///     color: Colors.purple,
///   ),
/// )
/// ```
class AtomicText extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The style to use for the text.
  ///
  /// If [atomicStyle] is provided, this style will be merged with the
  /// corresponding theme typography style.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// Whether the text should break across multiple lines.
  final bool? softWrap;

  /// The maximum number of lines for the text to span.
  final int? maxLines;

  /// The height of the text lines, as a multiple of the font size.
  final double? lineHeight;

  /// The predefined Atomic Design System text style to apply.
  ///
  /// If null, [AtomicTextStyle.bodyMedium] will be used as a default.
  final AtomicTextStyle? atomicStyle;

  /// Creates an [AtomicText] widget.
  ///
  /// [text] is the string to display.
  /// [style] is an optional [TextStyle] to apply, which will be merged with
  /// the style derived from [atomicStyle] or the default bodyMedium.
  /// [textAlign], [overflow], [softWrap], [maxLines], and [lineHeight]
  /// are standard [Text] properties.
  /// [atomicStyle] specifies a predefined typography style from the theme.
  const AtomicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
    this.atomicStyle,
  });

  /// Creates an [AtomicText] with the `displayLarge` style from the theme.
  const AtomicText.displayLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.displayLarge;

  /// Creates an [AtomicText] with the `displayMedium` style from the theme.
  const AtomicText.displayMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.displayMedium;

  /// Creates an [AtomicText] with the `displaySmall` style from the theme.
  const AtomicText.displaySmall(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.displaySmall;

  /// Creates an [AtomicText] with the `headlineLarge` style from the theme.
  const AtomicText.headlineLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.headlineLarge;

  /// Creates an [AtomicText] with the `headlineMedium` style from the theme.
  const AtomicText.headlineMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.headlineMedium;

  /// Creates an [AtomicText] with the `headlineSmall` style from the theme.
  const AtomicText.headlineSmall(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.headlineSmall;

  /// Creates an [AtomicText] with the `titleLarge` style from the theme.
  const AtomicText.titleLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.titleLarge;

  /// Creates an [AtomicText] with the `titleMedium` style from the theme.
  const AtomicText.titleMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.titleMedium;

  /// Creates an [AtomicText] with the `titleSmall` style from the theme.
  const AtomicText.titleSmall(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.titleSmall;

  /// Creates an [AtomicText] with the `bodyLarge` style from the theme.
  const AtomicText.bodyLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.bodyLarge;

  /// Creates an [AtomicText] with the `bodyMedium` style from the theme.
  const AtomicText.bodyMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.bodyMedium;

  /// Creates an [AtomicText] with the `bodySmall` style from the theme.
  const AtomicText.bodySmall(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.bodySmall;

  /// Creates an [AtomicText] with the `labelLarge` style from the theme.
  const AtomicText.labelLarge(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.labelLarge;

  /// Creates an [AtomicText] with the `labelMedium` style from the theme.
  const AtomicText.labelMedium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.labelMedium;

  /// Creates an [AtomicText] with the `labelSmall` style from the theme.
  const AtomicText.labelSmall(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.softWrap,
    this.maxLines,
    this.lineHeight,
  }) : atomicStyle = AtomicTextStyle.labelSmall;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.maybeOf(context);
    final typography = theme?.typography ?? const AtomicTypographyTheme();

    TextStyle baseStyle;

    switch (atomicStyle) {
      case AtomicTextStyle.displayLarge:
        baseStyle = typography.displayLarge;
        break;
      case AtomicTextStyle.displayMedium:
        baseStyle = typography.displayMedium;
        break;
      case AtomicTextStyle.displaySmall:
        baseStyle = typography.displaySmall;
        break;
      case AtomicTextStyle.headlineLarge:
        baseStyle = typography.headlineLarge;
        break;
      case AtomicTextStyle.headlineMedium:
        baseStyle = typography.headlineMedium;
        break;
      case AtomicTextStyle.headlineSmall:
        baseStyle = typography.headlineSmall;
        break;
      case AtomicTextStyle.titleLarge:
        baseStyle = typography.titleLarge;
        break;
      case AtomicTextStyle.titleMedium:
        baseStyle = typography.titleMedium;
        break;
      case AtomicTextStyle.titleSmall:
        baseStyle = typography.titleSmall;
        break;
      case AtomicTextStyle.bodyLarge:
        baseStyle = typography.bodyLarge;
        break;
      case AtomicTextStyle.bodyMedium:
        baseStyle = typography.bodyMedium;
        break;
      case AtomicTextStyle.bodySmall:
        baseStyle = typography.bodySmall;
        break;
      case AtomicTextStyle.labelLarge:
        baseStyle = typography.labelLarge;
        break;
      case AtomicTextStyle.labelMedium:
        baseStyle = typography.labelMedium;
        break;
      case AtomicTextStyle.labelSmall:
        baseStyle = typography.labelSmall;
        break;
      case null:
        baseStyle = typography.bodyMedium;
        break;
    }

    if (lineHeight != null) {
      baseStyle = baseStyle.copyWith(height: lineHeight);
    }

    final effectiveStyle = style != null ? baseStyle.merge(style) : baseStyle;

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
    );
  }
}

/// Defines the predefined text styles available in the Atomic Design System.
///
/// These styles correspond to the Material Design 3 typography scale.
enum AtomicTextStyle {
  /// Display Large text style.
  displayLarge,

  /// Display Medium text style.
  displayMedium,

  /// Display Small text style.
  displaySmall,

  /// Headline Large text style.
  headlineLarge,

  /// Headline Medium text style.
  headlineMedium,

  /// Headline Small text style.
  headlineSmall,

  /// Title Large text style.
  titleLarge,

  /// Title Medium text style.
  titleMedium,

  /// Title Small text style.
  titleSmall,

  /// Body Large text style.
  bodyLarge,

  /// Body Medium text style.
  bodyMedium,

  /// Body Small text style.
  bodySmall,

  /// Label Large text style.
  labelLarge,

  /// Label Medium text style.
  labelMedium,

  /// Label Small text style.
  labelSmall,
}
