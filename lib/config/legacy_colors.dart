import 'package:flutter/material.dart';
import '../tokens/colors/atomic_colors.dart';

/// Legacy Color Resource for backward compatibility
/// @deprecated Use AtomicColors instead for new code
class ColorResource {
  // Legacy colors - use AtomicColors for new code
  static const Color primary = Color(0xff00a4a6);
  static const Color danger = AtomicColors.error;
  static const Color success = Color(0xff02C24F);
  static const Color warning = Color(0xffFFD600);
  static const Color info = Color(0xff00C0DA);
  static const Color gray = Color(0xff636E7E);
  static const Color border = Color(0xffDCE6F2);
  static const Color dark = Color(0xff0C1016);
  static const Color light = Color(0xffF3F6FA);
  static const Color lighter = Color(0xffF9FBFF);
  static const Color white = AtomicColors.background;

  // Opacity variants
  static Color get primaryOpacity => primary.withValues(alpha: 0.12);
  static Color get dangerOpacity => danger.withValues(alpha: 0.12);
  static Color get successOpacity => success.withValues(alpha: 0.12);
  static Color get warningOpacity => warning.withValues(alpha: 0.12);
  static Color get infoOpacity => info.withValues(alpha: 0.12);
  static Color get grayOpacity => Color.fromRGBO(51, 57, 66, 0.06);
  static Color get borderOpacity => Color.fromRGBO(234, 239, 245, 0.12);
  static Color get darkOpacity => dark.withValues(alpha: 0.12);
  static Color get lightOpacity => light.withValues(alpha: 0.12);
  static Color get whiteOpacity => white.withValues(alpha: 0.12);

  static Map<String, dynamic> toMap() {
    return {
      'primary': primary,
      'danger': danger,
      'success': success,
      'warning': warning,
      'info': info,
      'gray': gray,
      'white': white,
    };
  }
} 