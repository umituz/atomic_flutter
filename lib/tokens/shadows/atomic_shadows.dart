import 'package:flutter/material.dart';
import '../colors/atomic_colors.dart';

class AtomicShadows {
  AtomicShadows._();

  
  static const List<BoxShadow> none = [];

  static List<BoxShadow> get xs => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get sm => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get md => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get lg => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get xl => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get xxl => [
    BoxShadow(
      color: AtomicColors.shadowColor,
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];

  
  static List<BoxShadow> get button => sm;
  
  static List<BoxShadow> get card => md;
  
  static List<BoxShadow> get modal => xl;
  
  static List<BoxShadow> get appBar => sm;
  
  static List<BoxShadow> get fab => lg;

  
  static List<BoxShadow> get inner => [
    BoxShadow(
      color: AtomicColors.gray900.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];
  
  static List<BoxShadow> colored(Color color, {double opacity = 0.3}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> glow(Color color, {double opacity = 0.4, double blur = 24}) => [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      offset: Offset.zero,
      spreadRadius: 2,
    ),
  ];

  
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