import 'package:flutter/material.dart';

/// Atomic Design System Responsive Utilities
/// Standardized breakpoints and responsive helpers
class AtomicResponsive {
  // Private constructor to prevent instantiation
  AtomicResponsive._();

  // ===== BREAKPOINTS =====
  static const double mobileSmall = 320;  // iPhone SE
  static const double mobile = 480;       // Standard mobile
  static const double tablet = 768;       // Tablet portrait
  static const double desktop = 1024;     // Desktop/laptop
  static const double desktopLarge = 1440; // Large desktop

  // ===== SCREEN SIZE DETECTION =====
  
  /// Check if current screen is mobile small (320px and below)
  static bool isMobileSmall(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobileSmall;
  }

  /// Check if current screen is mobile (480px and below)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobile;
  }

  /// Check if current screen is tablet (768px and below, but above mobile)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobile && width <= tablet;
  }

  /// Check if current screen is desktop (1024px and below, but above tablet)
  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > tablet && width <= desktop;
  }

  /// Check if current screen is large desktop (above 1024px)
  static bool isDesktopLarge(BuildContext context) {
    return MediaQuery.of(context).size.width > desktop;
  }

  /// Check if current screen width matches or exceeds breakpoint
  static bool isMinWidth(BuildContext context, double breakpoint) {
    return MediaQuery.of(context).size.width >= breakpoint;
  }

  /// Check if current screen width is below breakpoint
  static bool isMaxWidth(BuildContext context, double breakpoint) {
    return MediaQuery.of(context).size.width < breakpoint;
  }

  // ===== RESPONSIVE VALUE SELECTION =====
  
  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? desktopLarge,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width > AtomicResponsive.desktop && desktopLarge != null) {
      return desktopLarge;
    } else if (width > AtomicResponsive.tablet && desktop != null) {
      return desktop;
    } else if (width > AtomicResponsive.mobile && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  /// Get responsive column count for grids
  static int columns(BuildContext context, {
    int mobile = 1,
    int? tablet,
    int? desktop,
    int? desktopLarge,
  }) {
    return value<int>(
      context,
      mobile: mobile,
      tablet: tablet ?? (mobile * 2),
      desktop: desktop ?? (tablet ?? mobile * 2) + 1,
      desktopLarge: desktopLarge ?? (desktop ?? (tablet ?? mobile * 2) + 1) + 1,
    );
  }

  /// Get responsive spacing multiplier
  static double spacingMultiplier(BuildContext context) {
    return value<double>(
      context,
      mobile: 1.0,
      tablet: 1.2,
      desktop: 1.4,
      desktopLarge: 1.6,
    );
  }

  /// Get responsive font size multiplier
  static double fontSizeMultiplier(BuildContext context) {
    return value<double>(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
      desktopLarge: 1.3,
    );
  }

  // ===== RESPONSIVE LAYOUT HELPERS =====
  
  /// Build responsive layout with different widgets for different screen sizes
  static Widget layout(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    Widget? desktopLarge,
  }) {
    return value<Widget>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }

  /// Build responsive padding
  static EdgeInsets padding(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? desktopLarge,
  }) {
    return value<EdgeInsets>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }

  /// Build responsive margin
  static EdgeInsets margin(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
    EdgeInsets? desktopLarge,
  }) {
    return value<EdgeInsets>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      desktopLarge: desktopLarge,
    );
  }

  // ===== RESPONSIVE WRAP/FLEX HELPERS =====
  
  /// Determine if content should wrap based on available space and children count
  static bool shouldWrap(BuildContext context, int childrenCount, double minChildWidth) {
    final availableWidth = MediaQuery.of(context).size.width;
    final totalMinWidth = childrenCount * minChildWidth;
    return totalMinWidth > availableWidth;
  }

  /// Get responsive flex direction (Row for larger screens, Column for mobile)
  static Axis flexDirection(BuildContext context, {bool forceMobileColumn = true}) {
    if (forceMobileColumn && isMobile(context)) {
      return Axis.vertical;
    }
    return Axis.horizontal;
  }

  /// Get responsive main axis alignment
  static MainAxisAlignment mainAxisAlignment(BuildContext context, {
    MainAxisAlignment mobile = MainAxisAlignment.start,
    MainAxisAlignment? tablet,
    MainAxisAlignment? desktop,
  }) {
    return value<MainAxisAlignment>(
      context,
      mobile: mobile,
      tablet: tablet ?? MainAxisAlignment.center,
      desktop: desktop ?? MainAxisAlignment.center,
    );
  }

  /// Get responsive cross axis alignment
  static CrossAxisAlignment crossAxisAlignment(BuildContext context, {
    CrossAxisAlignment mobile = CrossAxisAlignment.stretch,
    CrossAxisAlignment? tablet,
    CrossAxisAlignment? desktop,
  }) {
    return value<CrossAxisAlignment>(
      context,
      mobile: mobile,
      tablet: tablet ?? CrossAxisAlignment.center,
      desktop: desktop ?? CrossAxisAlignment.center,
    );
  }

  // ===== RESPONSIVE COMPONENT BUILDERS =====
  
  /// Build responsive button layout (full width on mobile, auto on larger screens)
  static Widget responsiveButtonLayout(
    BuildContext context, {
    required List<Widget> buttons,
    double spacing = 16,
  }) {
    if (isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons
            .map((button) => Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: button,
                ))
            .toList(),
      );
    } else {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing / 2,
        children: buttons,
      );
    }
  }

  /// Build responsive grid
  static Widget responsiveGrid(
    BuildContext context, {
    required List<Widget> children,
    int? mobileColumns,
    int? tabletColumns,
    int? desktopColumns,
    double spacing = 16,
    double runSpacing = 16,
  }) {
    final columnCount = columns(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns,
      desktop: desktopColumns,
    );

    if (columnCount == 1) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: EdgeInsets.only(bottom: runSpacing),
                  child: child,
                ))
            .toList(),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: children
          .map((child) => SizedBox(
                width: (MediaQuery.of(context).size.width - (spacing * (columnCount - 1))) / columnCount,
                child: child,
              ))
          .toList(),
    );
  }
} 