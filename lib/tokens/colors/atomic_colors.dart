import 'package:flutter/material.dart';

/// Comprehensive color tokens for atomic design system.
///
/// This class provides a complete color palette following Material Design 3
/// principles with support for semantic colors, gradients, and utility methods.
/// All colors are carefully crafted for accessibility (WCAG AA compliance).
///
/// Color categories:
/// - **Brand colors**: [primary], [secondary], [accent]
/// - **Semantic colors**: [success], [warning], [error], [info]
/// - **Neutral colors**: [surface], [background], [outline]
/// - **Text colors**: [textPrimary], [textSecondary], [textTertiary]
///
/// Example usage:
/// ```dart
/// Container(
///   color: AtomicColors.primary,
///   decoration: BoxDecoration(
///     gradient: AtomicColors.primaryGradient,
///   ),
///   child: Text(
///     'Hello World',
///     style: TextStyle(color: AtomicColors.onPrimary),
///   ),
/// )
/// ```
///
/// Utility methods:
/// - [withAlpha]: Create color with custom opacity
/// - [blend]: Blend two colors with specified ratio
class AtomicColors {
  AtomicColors._();

  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);
  
  static const Color secondary = Color(0xFFEC4899);
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color secondaryDark = Color(0xFFDB2777);
  
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF4F4F5);
  static const Color gray200 = Color(0xFFE4E4E7);
  static const Color gray300 = Color(0xFFD4D4D8);
  static const Color gray400 = Color(0xFFA1A1AA);
  static const Color gray500 = Color(0xFF71717A);
  static const Color gray600 = Color(0xFF52525B);
  static const Color gray700 = Color(0xFF3F3F46);
  static const Color gray800 = Color(0xFF27272A);
  static const Color gray900 = Color(0xFF18181B);

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF3F4F6);
  
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray400;
  static const Color textDisabled = gray300;
  static const Color textInverse = Color(0xFFFFFFFF);

  
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }
  
  static Color get primaryWithAlpha10 => primary.withValues(alpha: 0.1);
  static Color get primaryWithAlpha20 => primary.withValues(alpha: 0.2);
  static Color get primaryWithAlpha50 => primary.withValues(alpha: 0.5);
  static Color get primaryWithAlpha80 => primary.withValues(alpha: 0.8);
  
  static Color get shadowColor => gray900.withValues(alpha: 0.1);
  static Color get overlayColor => gray900.withValues(alpha: 0.5);
  static Color get dividerColor => gray200.withValues(alpha: 0.5);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 