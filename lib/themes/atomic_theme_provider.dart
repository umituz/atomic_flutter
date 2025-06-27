import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'atomic_theme_data.dart';

/// Atomic Theme
/// Inherited widget for providing theme data to widgets
class AtomicTheme extends InheritedWidget {
  const AtomicTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final AtomicThemeData data;

  static AtomicThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<AtomicTheme>();
    if (theme == null) {
      throw Exception('AtomicTheme not found in widget tree');
    }
    return theme.data;
  }

  static AtomicThemeData? maybeOf(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<AtomicTheme>();
    return theme?.data;
  }

  @override
  bool updateShouldNotify(AtomicTheme oldWidget) {
    return data != oldWidget.data;
  }
}

/// Atomic Theme Provider Widget
/// Wraps the app with AtomicTheme and Material Theme
class AtomicThemeProvider extends StatelessWidget {
  const AtomicThemeProvider({
    super.key,
    required this.theme,
    required this.child,
  });

  final AtomicThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AtomicTheme(
      data: theme,
      child: MaterialApp(
        theme: theme.toMaterialTheme(),
        darkTheme: theme.toMaterialTheme(brightness: Brightness.dark),
        home: child,
      ),
    );
  }
}

/// Riverpod provider for theme management
final atomicThemeProvider = StateProvider<AtomicThemeData>((ref) {
  return AtomicThemeData.defaultTheme;
});

/// Extension to access theme from BuildContext
extension AtomicThemeExtension on BuildContext {
  AtomicThemeData get atomicTheme => AtomicTheme.of(this);
  AtomicColorScheme get atomicColors => atomicTheme.colors;
  AtomicTypographyTheme get atomicTypography => atomicTheme.typography;
  AtomicSpacingTheme get atomicSpacing => atomicTheme.spacing;
  AtomicBordersTheme get atomicBorders => atomicTheme.borders;
  AtomicAnimationsTheme get atomicAnimations => atomicTheme.animations;
} 