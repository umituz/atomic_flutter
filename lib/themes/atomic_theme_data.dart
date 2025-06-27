import 'package:flutter/material.dart';
import '../tokens/colors/atomic_colors.dart';
import '../tokens/typography/atomic_typography.dart';
import '../tokens/spacing/atomic_spacing.dart';
import '../tokens/shadows/atomic_shadows.dart';
import '../tokens/borders/atomic_borders.dart';
import '../tokens/animations/atomic_animations.dart';

/// Atomic Theme Data
/// Holds all theme configuration for an atomic design system
class AtomicThemeData {
  const AtomicThemeData({
    required this.name,
    required this.colors,
    this.typography = const AtomicTypographyTheme(),
    this.spacing = const AtomicSpacingTheme(),
    this.shadows = const AtomicShadowsTheme(),
    this.borders = const AtomicBordersTheme(),
    this.animations = const AtomicAnimationsTheme(),
  });

  final String name;
  final AtomicColorScheme colors;
  final AtomicTypographyTheme typography;
  final AtomicSpacingTheme spacing;
  final AtomicShadowsTheme shadows;
  final AtomicBordersTheme borders;
  final AtomicAnimationsTheme animations;

  /// Default theme
  static AtomicThemeData get defaultTheme => AtomicThemeData(
    name: 'Default',
    colors: AtomicColorScheme.defaultScheme,
  );

  /// Create Material Theme from Atomic Theme
  ThemeData toMaterialTheme({Brightness brightness = Brightness.light}) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ).copyWith(
        primary: colors.primary,
        onPrimary: colors.textInverse,
        secondary: colors.secondary,
        onSecondary: colors.textInverse,
        error: colors.error,
        onError: colors.textInverse,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: typography.headlineSmall.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textInverse,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.buttonPaddingX,
            vertical: spacing.buttonPaddingY,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borders.button,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borders.card,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.gray100,
        border: OutlineInputBorder(
          borderRadius: borders.input,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borders.input,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borders.input,
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borders.input,
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.inputPaddingX,
          vertical: spacing.inputPaddingY,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: typography.displayLarge.copyWith(color: colors.textPrimary),
        displayMedium: typography.displayMedium.copyWith(color: colors.textPrimary),
        displaySmall: typography.displaySmall.copyWith(color: colors.textPrimary),
        headlineLarge: typography.headlineLarge.copyWith(color: colors.textPrimary),
        headlineMedium: typography.headlineMedium.copyWith(color: colors.textPrimary),
        headlineSmall: typography.headlineSmall.copyWith(color: colors.textPrimary),
        titleLarge: typography.titleLarge.copyWith(color: colors.textPrimary),
        titleMedium: typography.titleMedium.copyWith(color: colors.textPrimary),
        titleSmall: typography.titleSmall.copyWith(color: colors.textPrimary),
        bodyLarge: typography.bodyLarge.copyWith(color: colors.textPrimary),
        bodyMedium: typography.bodyMedium.copyWith(color: colors.textPrimary),
        bodySmall: typography.bodySmall.copyWith(color: colors.textSecondary),
        labelLarge: typography.labelLarge.copyWith(color: colors.textPrimary),
        labelMedium: typography.labelMedium.copyWith(color: colors.textPrimary),
        labelSmall: typography.labelSmall.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

/// Atomic Color Scheme
/// Defines all colors for a theme
class AtomicColorScheme {
  const AtomicColorScheme({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.accent,
    required this.accentLight,
    required this.accentDark,
    required this.background,
    required this.backgroundSecondary,
    required this.surface,
    required this.surfaceSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textInverse,
    required this.success,
    required this.successLight,
    required this.successDark,
    required this.warning,
    required this.warningLight,
    required this.warningDark,
    required this.error,
    required this.errorLight,
    required this.errorDark,
    required this.info,
    required this.infoLight,
    required this.infoDark,
    required this.gray50,
    required this.gray100,
    required this.gray200,
    required this.gray300,
    required this.gray400,
    required this.gray500,
    required this.gray600,
    required this.gray700,
    required this.gray800,
    required this.gray900,
  });

  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color accent;
  final Color accentLight;
  final Color accentDark;
  final Color background;
  final Color backgroundSecondary;
  final Color surface;
  final Color surfaceSecondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color textInverse;
  final Color success;
  final Color successLight;
  final Color successDark;
  final Color warning;
  final Color warningLight;
  final Color warningDark;
  final Color error;
  final Color errorLight;
  final Color errorDark;
  final Color info;
  final Color infoLight;
  final Color infoDark;
  final Color gray50;
  final Color gray100;
  final Color gray200;
  final Color gray300;
  final Color gray400;
  final Color gray500;
  final Color gray600;
  final Color gray700;
  final Color gray800;
  final Color gray900;

  /// Default color scheme
  static const AtomicColorScheme defaultScheme = AtomicColorScheme(
    primary: AtomicColors.primary,
    primaryLight: AtomicColors.primaryLight,
    primaryDark: AtomicColors.primaryDark,
    secondary: AtomicColors.secondary,
    secondaryLight: AtomicColors.secondaryLight,
    secondaryDark: AtomicColors.secondaryDark,
    accent: AtomicColors.accent,
    accentLight: AtomicColors.accentLight,
    accentDark: AtomicColors.accentDark,
    background: AtomicColors.background,
    backgroundSecondary: AtomicColors.backgroundSecondary,
    surface: AtomicColors.surface,
    surfaceSecondary: AtomicColors.surfaceSecondary,
    textPrimary: AtomicColors.textPrimary,
    textSecondary: AtomicColors.textSecondary,
    textTertiary: AtomicColors.textTertiary,
    textDisabled: AtomicColors.textDisabled,
    textInverse: AtomicColors.textInverse,
    success: AtomicColors.success,
    successLight: AtomicColors.successLight,
    successDark: AtomicColors.successDark,
    warning: AtomicColors.warning,
    warningLight: AtomicColors.warningLight,
    warningDark: AtomicColors.warningDark,
    error: AtomicColors.error,
    errorLight: AtomicColors.errorLight,
    errorDark: AtomicColors.errorDark,
    info: AtomicColors.info,
    infoLight: AtomicColors.infoLight,
    infoDark: AtomicColors.infoDark,
    gray50: AtomicColors.gray50,
    gray100: AtomicColors.gray100,
    gray200: AtomicColors.gray200,
    gray300: AtomicColors.gray300,
    gray400: AtomicColors.gray400,
    gray500: AtomicColors.gray500,
    gray600: AtomicColors.gray600,
    gray700: AtomicColors.gray700,
    gray800: AtomicColors.gray800,
    gray900: AtomicColors.gray900,
  );
}

/// Typography Theme
class AtomicTypographyTheme {
  const AtomicTypographyTheme({
    this.displayLarge = AtomicTypography.displayLarge,
    this.displayMedium = AtomicTypography.displayMedium,
    this.displaySmall = AtomicTypography.displaySmall,
    this.headlineLarge = AtomicTypography.headlineLarge,
    this.headlineMedium = AtomicTypography.headlineMedium,
    this.headlineSmall = AtomicTypography.headlineSmall,
    this.titleLarge = AtomicTypography.titleLarge,
    this.titleMedium = AtomicTypography.titleMedium,
    this.titleSmall = AtomicTypography.titleSmall,
    this.bodyLarge = AtomicTypography.bodyLarge,
    this.bodyMedium = AtomicTypography.bodyMedium,
    this.bodySmall = AtomicTypography.bodySmall,
    this.labelLarge = AtomicTypography.labelLarge,
    this.labelMedium = AtomicTypography.labelMedium,
    this.labelSmall = AtomicTypography.labelSmall,
  });

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
}

/// Spacing Theme
class AtomicSpacingTheme {
  const AtomicSpacingTheme({
    this.unit = AtomicSpacing.unit,
    this.xxs = AtomicSpacing.xxs,
    this.xs = AtomicSpacing.xs,
    this.sm = AtomicSpacing.sm,
    this.md = AtomicSpacing.md,
    this.lg = AtomicSpacing.lg,
    this.xl = AtomicSpacing.xl,
    this.xxl = AtomicSpacing.xxl,
    this.xxxl = AtomicSpacing.xxxl,
    this.huge = AtomicSpacing.huge,
    this.buttonPaddingX = AtomicSpacing.buttonPaddingX,
    this.buttonPaddingY = AtomicSpacing.buttonPaddingY,
    this.cardPadding = AtomicSpacing.cardPadding,
    this.inputPaddingX = AtomicSpacing.inputPaddingX,
    this.inputPaddingY = AtomicSpacing.inputPaddingY,
  });

  final double unit;
  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
  final double xxxl;
  final double huge;
  final double buttonPaddingX;
  final double buttonPaddingY;
  final double cardPadding;
  final double inputPaddingX;
  final double inputPaddingY;
}

/// Shadows Theme
class AtomicShadowsTheme {
  const AtomicShadowsTheme();
  // Shadows are generated dynamically based on colors
}

/// Borders Theme
class AtomicBordersTheme {
  const AtomicBordersTheme({
    this.radiusXs = AtomicBorders.radiusXs,
    this.radiusSm = AtomicBorders.radiusSm,
    this.radiusMd = AtomicBorders.radiusMd,
    this.radiusLg = AtomicBorders.radiusLg,
    this.radiusXl = AtomicBorders.radiusXl,
    this.radiusXxl = AtomicBorders.radiusXxl,
    this.radiusFull = AtomicBorders.radiusFull,
    this.button = AtomicBorders.button,
    this.card = AtomicBorders.card,
    this.input = AtomicBorders.input,
    this.modal = AtomicBorders.modal,
  });

  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radiusXxl;
  final double radiusFull;
  final BorderRadius button;
  final BorderRadius card;
  final BorderRadius input;
  final BorderRadius modal;
}

/// Animations Theme
class AtomicAnimationsTheme {
  const AtomicAnimationsTheme({
    this.fast = AtomicAnimations.fast,
    this.normal = AtomicAnimations.normal,
    this.slow = AtomicAnimations.slow,
    this.buttonCurve = AtomicAnimations.buttonCurve,
    this.modalCurve = AtomicAnimations.modalCurve,
    this.pageCurve = AtomicAnimations.pageCurve,
  });

  final Duration fast;
  final Duration normal;
  final Duration slow;
  final Curve buttonCurve;
  final Curve modalCurve;
  final Curve pageCurve;
} 