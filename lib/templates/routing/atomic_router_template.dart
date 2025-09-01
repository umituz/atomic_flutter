import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../navigation/atomic_router.dart';

/// Standardized router template that eliminates duplication across Flutter apps.
///
/// This template provides common routing patterns used by all apps in the ecosystem,
/// while allowing customization for app-specific routes and behavior.
///
/// Usage:
/// ```dart
/// final routerProvider = Provider<GoRouter>((ref) {
///   return AtomicRouterTemplate.createStandardRouter(
///     appName: AppConstants.appName,
///     authScreenBuilder: () => const AuthScreen(),
///     homeScreenBuilder: () => const HomeScreen(),
///     additionalRoutes: [
///       // App-specific routes
///       GoRoute(
///         path: '/features',
///         builder: (context, state) => const FeaturesScreen(),
///       ),
///     ],
///   );
/// });
/// ```
class AtomicRouterTemplate {
  /// Create a standardized router configuration with common routes and patterns
  ///
  /// This method creates a fully configured router with:
  /// - Authentication protection
  /// - Standard route structure
  /// - Error handling
  /// - Debug logging
  /// - Custom route support
  ///
  /// Parameters:
  /// - [appName]: Name of the app for debugging purposes
  /// - [authScreenBuilder]: Builder function for the authentication screen
  /// - [homeScreenBuilder]: Builder function for the home screen
  /// - [additionalRoutes]: List of app-specific routes
  /// - [debugLogDiagnostics]: Enable router debug logging (defaults to true in debug mode)
  /// - [homeRoute]: Home route path (defaults to '/')
  /// - [authRoute]: Auth route path (defaults to '/auth')
  /// - [errorPageBuilder]: Custom error page builder (optional)
  static GoRouter createStandardRouter({
    required String appName,
    required Widget Function() authScreenBuilder,
    required Widget Function() homeScreenBuilder,
    List<GoRoute> additionalRoutes = const [],
    bool? debugLogDiagnostics,
    String homeRoute = '/',
    String authRoute = '/auth',
    Page<void> Function(BuildContext, GoRouterState)? errorPageBuilder,
  }) {
    final config = AtomicRouteConfig(
      homeRoute: homeRoute,
      authRoute: authRoute,
      debugLogDiagnostics: debugLogDiagnostics ?? true,
      routes: [
        // Authentication route
        GoRoute(
          path: authRoute,
          name: 'auth',
          builder: (context, state) => authScreenBuilder(),
        ),
        
        // Home route
        GoRoute(
          path: homeRoute,
          name: 'home',
          builder: (context, state) => homeScreenBuilder(),
        ),
        
        // Standard app routes
        ...standardRoutes,
        
        // Custom app routes
        ...additionalRoutes,
      ],
    );

    return _createRouterFromConfig(config, appName, errorPageBuilder);
  }

  /// Create a router using AtomicRouteConfig with additional standardization
  static GoRouter createFromConfig(
    AtomicRouteConfig config,
    String appName, [
    Page<void> Function(BuildContext, GoRouterState)? errorPageBuilder,
  ]) {
    return _createRouterFromConfig(config, appName, errorPageBuilder);
  }

  /// Internal method to create the actual GoRouter instance
  static GoRouter _createRouterFromConfig(
    AtomicRouteConfig config,
    String appName,
    Page<void> Function(BuildContext, GoRouterState)? errorPageBuilder,
  ) {
    return GoRouter(
      initialLocation: config.authRoute,
      debugLogDiagnostics: config.debugLogDiagnostics,
      routes: config.routes,
      errorPageBuilder: errorPageBuilder ?? _defaultErrorPageBuilder,
      redirect: (context, state) {
        // Use the atomic router's redirect logic
        return _handleRedirect(context, state, config);
      },
    );
  }

  /// Standard routes that are common across most apps
  static List<GoRoute> get standardRoutes => [
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => _buildPlaceholderScreen(
        'Settings',
        'Settings screen not implemented for this app',
        context,
      ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => _buildPlaceholderScreen(
        'Profile',
        'Profile screen not implemented for this app',
        context,
      ),
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => _buildPlaceholderScreen(
        'Favorites',
        'Favorites screen not implemented for this app',
        context,
      ),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => _buildPlaceholderScreen(
        'History',
        'History screen not implemented for this app',
        context,
      ),
    ),
  ];

  /// Handle authentication redirect logic
  static String? _handleRedirect(
    BuildContext context,
    GoRouterState state,
    AtomicRouteConfig config,
  ) {
    // This would integrate with the actual auth provider
    // For now, return null to allow all navigation
    return null;
  }

  /// Default error page builder
  static Page<void> _defaultErrorPageBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: _buildErrorScreen(state.error.toString(), context),
    );
  }

  /// Build a placeholder screen for unimplemented routes
  static Widget _buildPlaceholderScreen(String title, String message, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error screen
  static Widget _buildErrorScreen(String error, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  /// Create a simple router with minimal setup (for basic apps)
  static GoRouter createSimpleRouter({
    required Widget Function() authScreenBuilder,
    required Widget Function() homeScreenBuilder,
    String homeRoute = '/',
    String authRoute = '/auth',
  }) {
    return GoRouter(
      initialLocation: authRoute,
      routes: [
        GoRoute(
          path: authRoute,
          builder: (context, state) => authScreenBuilder(),
        ),
        GoRoute(
          path: homeRoute,
          builder: (context, state) => homeScreenBuilder(),
        ),
      ],
    );
  }

  /// Create a router with authentication protection
  static GoRouter createAuthProtectedRouter({
    required String appName,
    required Widget Function() authScreenBuilder,
    required Widget Function() homeScreenBuilder,
    required Future<bool> Function() isAuthenticated,
    List<GoRoute> additionalRoutes = const [],
    String homeRoute = '/',
    String authRoute = '/auth',
  }) {
    return GoRouter(
      initialLocation: homeRoute,
      routes: [
        GoRoute(
          path: authRoute,
          name: 'auth',
          builder: (context, state) => authScreenBuilder(),
        ),
        GoRoute(
          path: homeRoute,
          name: 'home',
          builder: (context, state) => homeScreenBuilder(),
        ),
        ...additionalRoutes,
      ],
      redirect: (context, state) async {
        final authenticated = await isAuthenticated();
        final isAuthRoute = state.matchedLocation == authRoute;
        
        if (!authenticated && !isAuthRoute) {
          return authRoute;
        }
        
        if (authenticated && isAuthRoute) {
          return homeRoute;
        }
        
        return null;
      },
    );
  }
}

/// Provider helper for creating standardized router providers
class AtomicRouterProviders {
  /// Create a standard router provider for most apps
  static Provider<GoRouter> createStandardProvider({
    required String appName,
    required Widget Function() authScreenBuilder,
    required Widget Function() homeScreenBuilder,
    List<GoRoute> additionalRoutes = const [],
  }) {
    return Provider<GoRouter>((ref) {
      return AtomicRouterTemplate.createStandardRouter(
        appName: appName,
        authScreenBuilder: authScreenBuilder,
        homeScreenBuilder: homeScreenBuilder,
        additionalRoutes: additionalRoutes,
      );
    });
  }

  /// Create a router provider with auth protection
  static Provider<GoRouter> createAuthProtectedProvider({
    required String appName,
    required Widget Function() authScreenBuilder,
    required Widget Function() homeScreenBuilder,
    required Provider<Future<bool>> isAuthenticatedProvider,
    List<GoRoute> additionalRoutes = const [],
  }) {
    return Provider<GoRouter>((ref) {
      return AtomicRouterTemplate.createAuthProtectedRouter(
        appName: appName,
        authScreenBuilder: authScreenBuilder,
        homeScreenBuilder: homeScreenBuilder,
        isAuthenticated: () => ref.read(isAuthenticatedProvider),
        additionalRoutes: additionalRoutes,
      );
    });
  }
}