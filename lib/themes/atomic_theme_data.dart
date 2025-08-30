import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/tokens/typography/atomic_typography.dart';
import 'package:atomic_flutter_kit/tokens/spacing/atomic_spacing.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/animations/atomic_animations.dart';

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

  static AtomicThemeData get defaultTheme => const AtomicThemeData(
    name: 'Default',
    colors: AtomicColorScheme.defaultScheme,
  );

  AtomicThemeData copyWith({
    String? name,
    AtomicColorScheme? colors,
    AtomicTypographyTheme? typography,
    AtomicSpacingTheme? spacing,
    AtomicShadowsTheme? shadows,
    AtomicBordersTheme? borders,
    AtomicAnimationsTheme? animations,
  }) {
    return AtomicThemeData(
      name: name ?? this.name,
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      shadows: shadows ?? this.shadows,
      borders: borders ?? this.borders,
      animations: animations ?? this.animations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicThemeData &&
        other.name == name &&
        other.colors == colors &&
        other.typography == typography &&
        other.spacing == spacing &&
        other.shadows == shadows &&
        other.borders == borders &&
        other.animations == animations;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      colors,
      typography,
      spacing,
      shadows,
      borders,
      animations,
    );
  }

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

  AtomicColorScheme copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondary,
    Color? secondaryLight,
    Color? secondaryDark,
    Color? accent,
    Color? accentLight,
    Color? accentDark,
    Color? background,
    Color? backgroundSecondary,
    Color? surface,
    Color? surfaceSecondary,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textInverse,
    Color? success,
    Color? successLight,
    Color? successDark,
    Color? warning,
    Color? warningLight,
    Color? warningDark,
    Color? error,
    Color? errorLight,
    Color? errorDark,
    Color? info,
    Color? infoLight,
    Color? infoDark,
    Color? gray50,
    Color? gray100,
    Color? gray200,
    Color? gray300,
    Color? gray400,
    Color? gray500,
    Color? gray600,
    Color? gray700,
    Color? gray800,
    Color? gray900,
  }) {
    return AtomicColorScheme(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondary: secondary ?? this.secondary,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      accentDark: accentDark ?? this.accentDark,
      background: background ?? this.background,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      surface: surface ?? this.surface,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textInverse: textInverse ?? this.textInverse,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      successDark: successDark ?? this.successDark,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      warningDark: warningDark ?? this.warningDark,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      errorDark: errorDark ?? this.errorDark,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      infoDark: infoDark ?? this.infoDark,
      gray50: gray50 ?? this.gray50,
      gray100: gray100 ?? this.gray100,
      gray200: gray200 ?? this.gray200,
      gray300: gray300 ?? this.gray300,
      gray400: gray400 ?? this.gray400,
      gray500: gray500 ?? this.gray500,
      gray600: gray600 ?? this.gray600,
      gray700: gray700 ?? this.gray700,
      gray800: gray800 ?? this.gray800,
      gray900: gray900 ?? this.gray900,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicColorScheme &&
        other.primary == primary &&
        other.secondary == secondary &&
        other.accent == accent &&
        other.background == background &&
        other.surface == surface &&
        other.textPrimary == textPrimary;
  }

  @override
  int get hashCode {
    return Object.hash(
      primary,
      secondary,
      accent,
      background,
      surface,
      textPrimary,
    );
  }

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

class AtomicShadowsTheme {
  const AtomicShadowsTheme();
}

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