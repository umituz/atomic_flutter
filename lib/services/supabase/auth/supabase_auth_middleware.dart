/// Authentication middleware for route protection and auth guards
/// Provides Flutter navigation guards and automatic auth validation
library supabase_auth_middleware;

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_session_manager.dart';
import '../models/supabase_user.dart';

/// Auth guard result
enum AuthGuardResult {
  allowed,
  denied,
  redirect,
}

/// Auth requirement for routes
enum AuthRequirement {
  authenticated,    // Requires valid session
  unauthenticated, // Requires no session (login/register pages)
  optional,        // Works with or without session
}

/// Auth guard configuration
class AuthGuardConfig {
  final AuthRequirement requirement;
  final String? redirectRoute;
  final List<String>? requiredPermissions;
  final bool checkEmailVerified;
  final bool checkPhoneVerified;
  
  const AuthGuardConfig({
    required this.requirement,
    this.redirectRoute,
    this.requiredPermissions,
    this.checkEmailVerified = false,
    this.checkPhoneVerified = false,
  });
  
  /// Config for authenticated routes
  static const authenticated = AuthGuardConfig(
    requirement: AuthRequirement.authenticated,
    redirectRoute: '/login',
  );
  
  /// Config for unauthenticated routes (login, register)
  static const unauthenticated = AuthGuardConfig(
    requirement: AuthRequirement.unauthenticated,
    redirectRoute: '/home',
  );
  
  /// Config for optional auth routes
  static const optional = AuthGuardConfig(
    requirement: AuthRequirement.optional,
  );
  
  /// Config for admin routes
  static const admin = AuthGuardConfig(
    requirement: AuthRequirement.authenticated,
    redirectRoute: '/login',
    requiredPermissions: ['admin'],
  );
  
  /// Config for verified email routes
  static const emailVerified = AuthGuardConfig(
    requirement: AuthRequirement.authenticated,
    redirectRoute: '/verify-email',
    checkEmailVerified: true,
  );
}

/// Auth guard result data
class AuthGuardResultData {
  final AuthGuardResult result;
  final String? redirectRoute;
  final String? message;
  
  const AuthGuardResultData({
    required this.result,
    this.redirectRoute,
    this.message,
  });
  
  bool get isAllowed => result == AuthGuardResult.allowed;
  bool get isDenied => result == AuthGuardResult.denied;
  bool get shouldRedirect => result == AuthGuardResult.redirect;
}

/// Authentication middleware for Flutter applications
class SupabaseAuthMiddleware {
  static SupabaseAuthMiddleware? _instance;
  static SupabaseAuthMiddleware get instance => _instance ??= SupabaseAuthMiddleware._();
  
  SupabaseAuthMiddleware._();
  
  final SupabaseSessionManager _sessionManager = SupabaseSessionManager.instance;
  
  final StreamController<AuthGuardResultData> _guardResultController = 
      StreamController<AuthGuardResultData>.broadcast();
  
  /// Stream of guard results for navigation listeners
  Stream<AuthGuardResultData> get guardResultStream => _guardResultController.stream;
  
  /// Check if user can access route with given config
  Future<AuthGuardResultData> checkAccess(AuthGuardConfig config) async {
    try {
      // Check session validity
      final session = _sessionManager.currentSession;
      final isAuthenticated = _sessionManager.isAuthenticated;
      
      // Handle authentication requirement
      switch (config.requirement) {
        case AuthRequirement.authenticated:
          if (!isAuthenticated) {
            return _createRedirectResult(
              config.redirectRoute ?? '/login',
              'Authentication required',
            );
          }
          break;
          
        case AuthRequirement.unauthenticated:
          if (isAuthenticated) {
            return _createRedirectResult(
              config.redirectRoute ?? '/home',
              'Already authenticated',
            );
          }
          break;
          
        case AuthRequirement.optional:
          // Always allow, no checks needed
          break;
      }
      
      // If not authenticated, skip further checks
      if (!isAuthenticated || session?.user == null) {
        return const AuthGuardResultData(result: AuthGuardResult.allowed);
      }
      
      final user = session!.user!;
      
      // Check email verification
      if (config.checkEmailVerified && !user.isEmailConfirmed) {
        return _createRedirectResult(
          '/verify-email',
          'Email verification required',
        );
      }
      
      // Check phone verification
      if (config.checkPhoneVerified && !user.isPhoneConfirmed) {
        return _createRedirectResult(
          '/verify-phone',
          'Phone verification required',
        );
      }
      
      // Check required permissions
      if (config.requiredPermissions != null && config.requiredPermissions!.isNotEmpty) {
        final hasRequiredPermissions = _checkPermissions(user, config.requiredPermissions!);
        if (!hasRequiredPermissions) {
          return const AuthGuardResultData(
            result: AuthGuardResult.denied,
            message: 'Insufficient permissions',
          );
        }
      }
      
      // All checks passed
      return const AuthGuardResultData(result: AuthGuardResult.allowed);
      
    } catch (e) {
      return const AuthGuardResultData(
        result: AuthGuardResult.denied,
        message: 'Auth check failed',
      );
    }
  }
  
  /// Create redirect result
  AuthGuardResultData _createRedirectResult(String route, String message) {
    final result = AuthGuardResultData(
      result: AuthGuardResult.redirect,
      redirectRoute: route,
      message: message,
    );
    _guardResultController.add(result);
    return result;
  }
  
  /// Check if user has required permissions
  bool _checkPermissions(SupabaseUser user, List<String> requiredPermissions) {
    // TODO: Implement permission checking based on user metadata or roles
    // This could check user.userMetadata for roles or permissions
    // Example: user.userMetadata?['roles'] or user.userMetadata?['permissions']
    
    // Placeholder implementation
    final userRoles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    final userPermissions = user.userMetadata?['permissions'] as List<dynamic>? ?? [];
    
    for (final permission in requiredPermissions) {
      if (!userRoles.contains(permission) && !userPermissions.contains(permission)) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Route guard for GoRouter or similar navigation
  /// Returns true if access is allowed, false otherwise
  Future<bool> routeGuard(
    String routePath,
    AuthGuardConfig config, {
    Function(String route)? onRedirect,
    Function(String message)? onDenied,
  }) async {
    final result = await checkAccess(config);
    
    switch (result.result) {
      case AuthGuardResult.allowed:
        return true;
        
      case AuthGuardResult.redirect:
        if (result.redirectRoute != null && onRedirect != null) {
          onRedirect(result.redirectRoute!);
        }
        return false;
        
      case AuthGuardResult.denied:
        if (result.message != null && onDenied != null) {
          onDenied(result.message!);
        }
        return false;
    }
  }
  
  /// Auto-refresh middleware
  /// Automatically refreshes token if it's about to expire
  Future<bool> autoRefreshMiddleware() async {
    try {
      final session = _sessionManager.currentSession;
      if (session == null) return false;
      
      // Check if session expires soon
      if (session.expiresSoon) {
        final refreshedSession = await _sessionManager.forceRefresh();
        return refreshedSession != null;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// HTTP request middleware for API calls
  /// Adds auth headers and handles token refresh
  Future<Map<String, String>?> getAuthHeaders() async {
    try {
      // Auto-refresh if needed
      await autoRefreshMiddleware();
      
      final accessToken = _sessionManager.accessToken;
      if (accessToken == null) return null;
      
      return {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
    } catch (e) {
      return null;
    }
  }
  
  /// Session validation middleware
  /// Validates current session and refreshes if needed
  Future<bool> validateSession() async {
    try {
      final session = _sessionManager.currentSession;
      if (session == null) return false;
      
      // If session is expired, try to refresh
      if (session.isExpired) {
        final refreshedSession = await _sessionManager.forceRefresh();
        return refreshedSession != null;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Logout middleware
  /// Clears session and redirects to login
  Future<void> logoutMiddleware({
    Function(String route)? onRedirect,
  }) async {
    try {
      // TODO: Use official supabase client for sign out
      await _sessionManager.clearSession();
      
      if (onRedirect != null) {
        onRedirect('/login');
      }
    } catch (e) {
      // Handle logout error
    }
  }
  
  /// Dispose resources
  void dispose() {
    _guardResultController.close();
  }
}

/// Auth middleware extensions for easy usage
extension AuthMiddlewareExtensions on SupabaseAuthMiddleware {
  /// Quick check for authenticated user
  bool get isAuthenticated => _sessionManager.isAuthenticated;
  
  /// Quick check for user ID
  String? get currentUserId => _sessionManager.userId;
  
  /// Quick check for access token
  String? get currentAccessToken => _sessionManager.accessToken;
} 