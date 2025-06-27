import 'package:flutter/material.dart';
import '../colors/atomic_colors.dart';

/// Atomic Design System Shadow Tokens
/// Material Design elevation system
class AtomicShadows {
  // Private constructor to prevent instantiation
  AtomicShadows._();

  // ===== SHADOW LEVELS =====
  
  /// No shadow (elevation 0)
  static const List<BoxShadow> none = [];

  /// Extra small shadow (elevation 1)
  static List<BoxShadow> get xs => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// Small shadow (elevation 2)
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium shadow (elevation 4)
  static List<BoxShadow> get md => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// Large shadow (elevation 8)
  static List<BoxShadow> get lg => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  /// Extra large shadow (elevation 12)
  static List<BoxShadow> get xl => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  /// Extra extra large shadow (elevation 16)
  static List<BoxShadow> get xxl => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];

  // ===== COMPONENT SHADOWS =====
  
  /// Button shadow
  static List<BoxShadow> get button => sm;
  
  /// Card shadow
  static List<BoxShadow> get card => md;
  
  /// Modal shadow
  static List<BoxShadow> get modal => xl;
  
  /// App bar shadow
  static List<BoxShadow> get appBar => sm;
  
  /// FAB shadow
  static List<BoxShadow> get fab => lg;

  // ===== SPECIAL SHADOWS =====
  
  /// Inner shadow (inset)
  static List<BoxShadow> get inner => [
    BoxShadow(
      color: AtomicColors.gray900.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];
  
  /// Colored shadow
  static List<BoxShadow> colored(Color color, {double opacity = 0.3}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  /// Glow effect
  static List<BoxShadow> glow(Color color, {double opacity = 0.4, double blur = 24}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      offset: Offset.zero,
      spreadRadius: 2,
    ),
  ];

  // ===== ELEVATION HELPERS =====
  
  /// Get shadow by elevation level (Material Design)
  static List<BoxShadow> elevation(double elevation) {
    if (elevation <= 0) return none;
    if (elevation <= 1) return xs;
    if (elevation <= 2) return sm;
    if (elevation <= 4) return md;
    if (elevation <= 8) return lg;
    if (elevation <= 12) return xl;
    return xxl;
  }
} 