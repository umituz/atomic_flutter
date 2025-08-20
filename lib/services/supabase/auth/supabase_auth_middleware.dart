library supabase_auth_middleware;

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_session_manager.dart';
import '../models/supabase_user.dart';

enum AuthGuardResult {
  allowed,
  denied,
  redirect,
}

enum AuthRequirement {
  authenticated,    // Requires valid session
  unauthenticated, // Requires no session (login/register pages)
  optional,        // Works with or without session
}

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
  
  static const authenticated = AuthGuardConfig(
    requirement: AuthRequirement.authenticated,
    redirectRoute: '/login',
  );
  
  static const unauthenticated = AuthGuardConfig(
    requirement: AuthRequirement.unauthenticated,
    redirectRoute: '/home',
  );
  
  static const optional = AuthGuardConfig(
    requirement: AuthRequirement.optional,
  );
  
  static const admin = AuthGuardConfig(
    requirement: AuthRequirement.authenticated,
    redirectRoute: '/login',
    requiredPermissions: ['admin'],
  );
  
  static const emailVerified = AuthGuardConfig(
    requirement: AuthRequirement.authenticated,
    redirectRoute: '/verify-email',
    checkEmailVerified: true,
  );
}

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

class SupabaseAuthMiddleware {
  static SupabaseAuthMiddleware? _instance;
  static SupabaseAuthMiddleware get instance => _instance ??= SupabaseAuthMiddleware._();
  
  SupabaseAuthMiddleware._();
  
  final SupabaseSessionManager _sessionManager = SupabaseSessionManager.instance;
  
  final StreamController<AuthGuardResultData> _guardResultController = 
      StreamController<AuthGuardResultData>.broadcast();
  
  Stream<AuthGuardResultData> get guardResultStream => _guardResultController.stream;
  
  Future<AuthGuardResultData> checkAccess(AuthGuardConfig config) async {
    try {
      final session = _sessionManager.currentSession;
      final isAuthenticated = _sessionManager.isAuthenticated;
      
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
          break;
      }
      
      if (!isAuthenticated || session?.user == null) {
        return const AuthGuardResultData(result: AuthGuardResult.allowed);
      }
      
      final user = session!.user!;
      
      if (config.checkEmailVerified && !user.isEmailConfirmed) {
        return _createRedirectResult(
          '/verify-email',
          'Email verification required',
        );
      }
      
      if (config.checkPhoneVerified && !user.isPhoneConfirmed) {
        return _createRedirectResult(
          '/verify-phone',
          'Phone verification required',
        );
      }
      
      if (config.requiredPermissions != null && config.requiredPermissions!.isNotEmpty) {
        final hasRequiredPermissions = _checkPermissions(user, config.requiredPermissions!);
        if (!hasRequiredPermissions) {
          return const AuthGuardResultData(
            result: AuthGuardResult.denied,
            message: 'Insufficient permissions',
          );
        }
      }
      
      return const AuthGuardResultData(result: AuthGuardResult.allowed);
      
    } catch (e) {
      return const AuthGuardResultData(
        result: AuthGuardResult.denied,
        message: 'Auth check failed',
      );
    }
  }
  
  AuthGuardResultData _createRedirectResult(String route, String message) {
    final result = AuthGuardResultData(
      result: AuthGuardResult.redirect,
      redirectRoute: route,
      message: message,
    );
    _guardResultController.add(result);
    return result;
  }
  
  bool _checkPermissions(SupabaseUser user, List<String> requiredPermissions) {
    
    final userRoles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    final userPermissions = user.userMetadata?['permissions'] as List<dynamic>? ?? [];
    
    for (final permission in requiredPermissions) {
      if (!userRoles.contains(permission) && !userPermissions.contains(permission)) {
        return false;
      }
    }
    
    return true;
  }
  
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
  
  Future<bool> autoRefreshMiddleware() async {
    try {
      final session = _sessionManager.currentSession;
      if (session == null) return false;
      
      if (session.expiresSoon) {
        final refreshedSession = await _sessionManager.forceRefresh();
        return refreshedSession != null;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<Map<String, String>?> getAuthHeaders() async {
    try {
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
  
  Future<bool> validateSession() async {
    try {
      final session = _sessionManager.currentSession;
      if (session == null) return false;
      
      if (session.isExpired) {
        final refreshedSession = await _sessionManager.forceRefresh();
        return refreshedSession != null;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> logoutMiddleware({
    Function(String route)? onRedirect,
  }) async {
    try {
      await _sessionManager.clearSession();
      
      if (onRedirect != null) {
        onRedirect('/login');
      }
    } catch (e) {
    }
  }
  
  void dispose() {
    _guardResultController.close();
  }
}

extension AuthMiddlewareExtensions on SupabaseAuthMiddleware {
  bool get isAuthenticated => _sessionManager.isAuthenticated;
  
  String? get currentUserId => _sessionManager.userId;
  
  String? get currentAccessToken => _sessionManager.accessToken;
} 