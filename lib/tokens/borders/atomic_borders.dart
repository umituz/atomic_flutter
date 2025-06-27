import 'package:flutter/material.dart';
import '../colors/atomic_colors.dart';

/// Atomic Design System Border Tokens
class AtomicBorders {
  // Private constructor to prevent instantiation
  AtomicBorders._();

  // ===== BORDER RADIUS =====
  static const double radiusNone = 0;
  static const double radiusXs = 2;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusXxl = 24;
  static const double radiusFull = 9999;

  // BorderRadius helpers
  static const BorderRadius none = BorderRadius.zero;
  static const BorderRadius xs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius md = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius full = BorderRadius.all(Radius.circular(radiusFull));

  // Component-specific radius
  static const BorderRadius button = md;
  static const BorderRadius card = lg;
  static const BorderRadius input = md;
  static const BorderRadius modal = xl;
  static const BorderRadius chip = full;
  static const BorderRadius avatar = full;

  // ===== BORDER WIDTH =====
  static const double widthNone = 0;
  static const double widthThin = 1;
  static const double widthMedium = 2;
  static const double widthThick = 3;
  static const double widthExtraThick = 4;

  // ===== BORDER STYLES =====
  
  /// Default border
  static Border get defaultBorder => Border.all(
    color: AtomicColors.gray300,
    width: widthThin,
  );

  /// Primary border
  static Border get primaryBorder => Border.all(
    color: AtomicColors.primary,
    width: widthThin,
  );

  /// Secondary border
  static Border get secondaryBorder => Border.all(
    color: AtomicColors.secondary,
    width: widthThin,
  );

  /// Error border
  static Border get errorBorder => Border.all(
    color: AtomicColors.error,
    width: widthThin,
  );

  /// Success border
  static Border get successBorder => Border.all(
    color: AtomicColors.success,
    width: widthThin,
  );

  /// Disabled border
  static Border get disabledBorder => Border.all(
    color: AtomicColors.gray200,
    width: widthThin,
  );

  // ===== BORDER SIDE =====
  
  static const BorderSide noneSide = BorderSide.none;
  
  static BorderSide get defaultSide => BorderSide(
    color: AtomicColors.gray300,
    width: widthThin,
  );

  static BorderSide get primarySide => BorderSide(
    color: AtomicColors.primary,
    width: widthThin,
  );

  static BorderSide get secondarySide => BorderSide(
    color: AtomicColors.secondary,
    width: widthThin,
  );

  static BorderSide get errorSide => BorderSide(
    color: AtomicColors.error,
    width: widthThin,
  );

  static BorderSide get successSide => BorderSide(
    color: AtomicColors.success,
    width: widthThin,
  );

  // ===== OUTLINED INPUT BORDER =====
  
  static OutlineInputBorder get inputDefaultBorder => OutlineInputBorder(
    borderRadius: input,
    borderSide: defaultSide,
  );

  static OutlineInputBorder get inputFocusedBorder => OutlineInputBorder(
    borderRadius: input,
    borderSide: primarySide,
  );

  static OutlineInputBorder get inputErrorBorder => OutlineInputBorder(
    borderRadius: input,
    borderSide: errorSide,
  );

  static OutlineInputBorder get inputSuccessBorder => OutlineInputBorder(
    borderRadius: input,
    borderSide: successSide,
  );

  static OutlineInputBorder get inputDisabledBorder => OutlineInputBorder(
    borderRadius: input,
    borderSide: BorderSide(
      color: AtomicColors.gray200,
      width: widthThin,
    ),
  );

  // ===== HELPER METHODS =====
  
  /// Create custom border with color
  static Border border({
    Color color = AtomicColors.gray300,
    double width = widthThin,
  }) {
    return Border.all(color: color, width: width);
  }

  /// Create custom border radius
  static BorderRadius radius(double value) {
    return BorderRadius.circular(value);
  }

  /// Create custom border side
  static BorderSide side({
    Color color = AtomicColors.gray300,
    double width = widthThin,
  }) {
    return BorderSide(color: color, width: width);
  }
} 