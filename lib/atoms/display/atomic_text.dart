import 'package:flutter/material.dart';
import 'package:atomic_flutter/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter/themes/atomic_theme_data.dart';

class AtomicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool? softWrap;
  final int? maxLines;
  final double? lineHeight;
  final AtomicTextStyle? atomicStyle;

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

enum AtomicTextStyle {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
} 