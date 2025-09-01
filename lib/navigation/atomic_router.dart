import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth/auth_provider.dart';

/// 🌟 Centralized Router Configuration for Atomic Flutter Kit
/// 
/// This provides a unified, auth-aware routing solution that eliminates
/// code duplication across all Flutter applications.
/// 
/// Usage in each app:
/// ```dart
/// final appRoutes = AtomicRouteConfig(
///   homeRoute: '/',
///   authRoute: '/auth',
///   routes: [...your routes...]
/// );
/// 
/// // In MaterialApp.router
/// routerConfig: ref.watch(atomicRouterProvider(appRoutes)),
/// ```

/// Route configuration interface for each app
class AtomicRouteConfig {
  final String homeRoute;
  final String authRoute;
  final List<RouteBase> routes;
  final bool debugLogDiagnostics;

  const AtomicRouteConfig({
    required this.homeRoute,
    required this.authRoute,
    required this.routes,
    this.debugLogDiagnostics = false,
  });
}

/// 🚀 Centralized Router Provider
/// 
/// Automatically handles auth state changes and provides consistent
/// navigation behavior across all applications.
final atomicRouterProvider = Provider.family<GoRouter, AtomicRouteConfig>((ref, config) {
  final authState = ref.watch(authProvider);
  return AtomicRouterHelper.createRouter(authState, config);
});

/// 🔧 Router Helper - Core routing logic
class AtomicRouterHelper {
  /// Creates an auth-aware GoRouter instance
  static GoRouter createRouter(AuthState authState, AtomicRouteConfig config) {
    return GoRouter(
      initialLocation: authState.isAuthenticated ? config.homeRoute : config.authRoute,
      debugLogDiagnostics: config.debugLogDiagnostics,
      redirect: (context, state) {
        final isAuthenticated = authState.isAuthenticated;
        final isAuthRoute = state.matchedLocation == config.authRoute;

        // If not authenticated and trying to access protected routes
        if (!isAuthenticated && !isAuthRoute) {
          return config.authRoute;
        }

        // If authenticated and trying to access auth screen, redirect to home
        if (isAuthenticated && isAuthRoute) {
          return config.homeRoute;
        }

        return null; // No redirect needed
      },
      routes: config.routes,
      errorBuilder: (context, state) => _buildErrorScreen(context, config),
    );
  }

  /// Default error screen for 404 and other routing errors
  static Widget _buildErrorScreen(BuildContext context, AtomicRouteConfig config) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(config.homeRoute),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🎯 Route Constants - Common route patterns
class AtomicRoutes {
  static const String home = '/';
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
}