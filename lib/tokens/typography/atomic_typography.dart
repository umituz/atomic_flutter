import 'package:flutter/material.dart';
import 'package:atomic_flutter/tokens/colors/atomic_colors.dart';

class AtomicTypography {
  AtomicTypography._();

  static const String fontFamily = 'Roboto';
  static const String monospaceFontFamily = 'RobotoMono';

  static const FontWeight thin = FontWeight.w100;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: regular,
    letterSpacing: -0.25,
    height: 1.12,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.16,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.22,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.25,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.29,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: regular,
    letterSpacing: 0,
    height: 1.33,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: medium,
    letterSpacing: 0,
    height: 1.27,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
  
  static TextStyle get displayLargePrimary => displayLarge.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get displayMediumPrimary => displayMedium.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get displaySmallPrimary => displaySmall.copyWith(color: AtomicColors.textPrimary);
  
  static TextStyle get headlineLargePrimary => headlineLarge.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get headlineMediumPrimary => headlineMedium.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get headlineSmallPrimary => headlineSmall.copyWith(color: AtomicColors.textPrimary);
  
  static TextStyle get titleLargePrimary => titleLarge.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get titleMediumPrimary => titleMedium.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get titleSmallPrimary => titleSmall.copyWith(color: AtomicColors.textPrimary);
  
  static TextStyle get bodyLargePrimary => bodyLarge.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get bodyMediumPrimary => bodyMedium.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get bodySmallPrimary => bodySmall.copyWith(color: AtomicColors.textPrimary);
  
  static TextStyle get bodyLargeSecondary => bodyLarge.copyWith(color: AtomicColors.textSecondary);
  static TextStyle get bodyMediumSecondary => bodyMedium.copyWith(color: AtomicColors.textSecondary);
  static TextStyle get bodySmallSecondary => bodySmall.copyWith(color: AtomicColors.textSecondary);
  
  static TextStyle get labelLargePrimary => labelLarge.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get labelMediumPrimary => labelMedium.copyWith(color: AtomicColors.textPrimary);
  static TextStyle get labelSmallPrimary => labelSmall.copyWith(color: AtomicColors.textPrimary);
} 