import '../tokens/spacing/atomic_spacing.dart';

/// Legacy Dimension Resource for backward compatibility
/// Maps old dimension names to new atomic spacing system
/// 
/// @deprecated Use AtomicSpacing instead for new code
class DimensionResource {
  // Private constructor to prevent instantiation
  DimensionResource._();

  // Map legacy dimensions to atomic spacing
  static const double xxsmallPadding = 4.0; // Custom size
  static const double xsmallPadding = 6.0; // Custom size
  static const double smallPadding = AtomicSpacing.xs; // 8.0
  static const double xmediumPadding = 10.0; // Custom size
  static const double mediumPadding = AtomicSpacing.sm; // 12.0
  static const double largePadding = AtomicSpacing.md; // 16.0
  static const double xlargePadding = AtomicSpacing.lg; // 20.0
  static const double xxlargePadding = AtomicSpacing.xl; // 24.0
  static const double xxxlargePadding = 28.0; // Custom size
  static const double xxxxlargePadding = AtomicSpacing.xxl; // 32.0
  static const double xxxxxlargePadding = 36.0; // Custom size
}

/// Extended atomic spacing with legacy dimensions
/// Use this class to access both new atomic spacing and legacy dimensions
class AtomicSpacingExtended {
  // Private constructor to prevent instantiation
  AtomicSpacingExtended._();

  // Additional legacy spacing values not in atomic system
  static const double xxsmall = 4.0;
  static const double xsmall = 6.0;
  static const double xmedium = 10.0;
  static const double xxxlarge = 28.0;
  static const double xxxxxlarge = 36.0;

  // Convenience methods for legacy naming
  static const double xxs = xxsmall;
  static const double xs6 = xsmall; // To differentiate from AtomicSpacing.xs (8.0)
  static const double xm = xmedium;
  static const double xxxl = xxxlarge;
  static const double xxxxxl = xxxxxlarge;
} 