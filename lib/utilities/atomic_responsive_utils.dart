import 'package:flutter/material.dart';

class AtomicResponsiveUtils {
  static const double mobileBreakpoint = 600;    // Phones (portrait)
  static const double tabletBreakpoint = 905;    // Small tablets (portrait)
  static const double desktopBreakpoint = 1240;  // Desktop/Large tablets (landscape)
  static const double largeDesktopBreakpoint = 1440; // Large desktop screens

  static const double shortScreenBreakpoint = 700;   // Short screens (small phones)
  static const double mediumScreenBreakpoint = 800;  // Medium screens (most phones)
  static const double tallScreenBreakpoint = 900;    // Tall screens (large phones/tablets)

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= desktopBreakpoint && width < largeDesktopBreakpoint;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  static bool isShortScreen(BuildContext context) {
    return MediaQuery.of(context).size.height < shortScreenBreakpoint;
  }

  static bool isMediumScreen(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height >= shortScreenBreakpoint && height < tallScreenBreakpoint;
  }

  static bool isTallScreen(BuildContext context) {
    return MediaQuery.of(context).size.height >= tallScreenBreakpoint;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidthFraction(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.width * fraction;
  }

  static double screenHeightFraction(BuildContext context, double fraction) {
    return MediaQuery.of(context).size.height * fraction;
  }

  static EdgeInsets safeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double bottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static bool hasBottomNotch(BuildContext context) {
    return MediaQuery.of(context).padding.bottom > 0;
  }

  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop(context) && largeDesktop != null) return largeDesktop;
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }

  static double responsiveSpacing(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 24.0,
    double desktop = 32.0,
  }) {
    return responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  static double responsiveFontSize(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 18.0,
    double desktop = 20.0,
  }) {
    return responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  static EdgeInsets responsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return responsiveValue(
      context,
      mobile: mobile ?? const EdgeInsets.all(16.0),
      tablet: tablet ?? const EdgeInsets.all(24.0),
      desktop: desktop ?? const EdgeInsets.all(32.0),
    );
  }

  static EdgeInsets responsiveMargin(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    return responsiveValue(
      context,
      mobile: mobile ?? const EdgeInsets.all(8.0),
      tablet: tablet ?? const EdgeInsets.all(16.0),
      desktop: desktop ?? const EdgeInsets.all(24.0),
    );
  }

  static double responsiveWidth(
    BuildContext context, {
    double mobileRatio = 1.0,
    double tabletRatio = 0.8,
    double desktopRatio = 0.6,
    double? maxWidth,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width;

    if (isDesktop(context)) {
      width = screenWidth * desktopRatio;
    } else if (isTablet(context)) {
      width = screenWidth * tabletRatio;
    } else {
      width = screenWidth * mobileRatio;
    }

    if (maxWidth != null && width > maxWidth) {
      width = maxWidth;
    }

    return width;
  }

  static int responsiveColumns(BuildContext context) {
    if (isLargeDesktop(context)) return 4;
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static double getTextScaleFactor(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return textScaleFactor.clamp(0.8, 1.3);
  }

  static AtomicDeviceCategory getDeviceCategory(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    
    if (shortestSide < 600) {
      return AtomicDeviceCategory.mobile;
    } else if (shortestSide < 905) {
      return AtomicDeviceCategory.tablet;
    } else {
      return AtomicDeviceCategory.desktop;
    }
  }

  static bool shouldUseDrawer(BuildContext context) {
    return isMobile(context) || (isTablet(context) && isPortrait(context));
  }

  static bool shouldShowSidebar(BuildContext context) {
    return isDesktop(context) || (isTablet(context) && isLandscape(context));
  }

  static bool shouldUseBottomNavigation(BuildContext context) {
    return isMobile(context);
  }

  static bool shouldUseTabBar(BuildContext context) {
    return isTablet(context) || isDesktop(context);
  }

  static double getDialogWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: screenWidth(context) * 0.9,
      tablet: 400.0,
      desktop: 500.0,
    );
  }

  static double getCardWidth(BuildContext context, {int columns = 1}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = responsiveSpacing(context);
    final totalSpacing = spacing * (columns + 1);
    return (screenWidth - totalSpacing) / columns;
  }
}

enum AtomicDeviceCategory {
  mobile,
  tablet,
  desktop,
}

extension AtomicResponsiveExtensions on BuildContext {
  bool get isMobile => AtomicResponsiveUtils.isMobile(this);
  bool get isTablet => AtomicResponsiveUtils.isTablet(this);
  bool get isDesktop => AtomicResponsiveUtils.isDesktop(this);
  bool get isShortScreen => AtomicResponsiveUtils.isShortScreen(this);
  bool get isTallScreen => AtomicResponsiveUtils.isTallScreen(this);
  bool get isPortrait => AtomicResponsiveUtils.isPortrait(this);
  bool get isLandscape => AtomicResponsiveUtils.isLandscape(this);
  
  Size get screenSize => AtomicResponsiveUtils.screenSize(this);
  double get screenWidth => AtomicResponsiveUtils.screenWidth(this);
  double get screenHeight => AtomicResponsiveUtils.screenHeight(this);
  
  AtomicDeviceCategory get deviceCategory => AtomicResponsiveUtils.getDeviceCategory(this);
} 