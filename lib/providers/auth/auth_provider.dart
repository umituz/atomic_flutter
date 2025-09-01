import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../models/auth/auth_result.dart';
import '../../models/auth/auth_user.dart';
import '../../services/auth/auth_service.dart';

/// 🔐 Centralized Authentication Provider
/// 
/// Manages authentication state across all Flutter applications.
/// Uses Riverpod for consistent state management.

// Auth service provider - singleton instance
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

// Auth state provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

/// Authentication State
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final AuthUser? user;
  final String? error;
  final String? message;

  const AuthState._({
    required this.isLoading,
    required this.isAuthenticated,
    this.user,
    this.error,
    this.message,
  });

  /// Initial state - loading to check auth status
  factory AuthState.initial() {
    return const AuthState._(
      isLoading: true,
      isAuthenticated: false,
    );
  }

  /// Loading state during auth operations
  factory AuthState.loading() {
    return const AuthState._(
      isLoading: true,
      isAuthenticated: false,
    );
  }

  /// Authenticated state with user data
  factory AuthState.authenticated(AuthUser user) {
    return AuthState._(
      isLoading: false,
      isAuthenticated: true,
      user: user,
    );
  }

  /// Unauthenticated state
  factory AuthState.unauthenticated() {
    return const AuthState._(
      isLoading: false,
      isAuthenticated: false,
    );
  }

  /// Error state with message
  factory AuthState.error(String error) {
    return AuthState._(
      isLoading: false,
      isAuthenticated: false,
      error: error,
    );
  }

  /// Success state with message
  factory AuthState.success(String message) {
    return AuthState._(
      isLoading: false,
      isAuthenticated: false,
      message: message,
    );
  }

  /// Copy with updated values
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    AuthUser? user,
    String? error,
    String? message,
  }) {
    return AuthState._(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      message: message,
    );
  }
}

/// Authentication Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _initialize();
  }

  final AuthService _authService;

  /// Initialize authentication state
  Future<void> _initialize() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final result = await _authService.getCurrentUser();
        if (result.isSuccess && result.user != null) {
          state = AuthState.authenticated(result.user!);
        } else {
          state = AuthState.unauthenticated();
        }
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  /// User Login
  Future<void> login(String email, String password) async {
    debugPrint('🔐 AuthProvider.login: Starting login for $email');
    
    if (state.message != null) state = state.copyWith(message: null);
    if (state.error != null) state = state.copyWith(error: null);
    
    state = AuthState.loading();
    debugPrint('🔐 AuthProvider.login: State set to loading');
    
    try {
      final result = await _authService.login(email, password);
      debugPrint('🔐 AuthProvider.login: AuthService returned result');
      debugPrint('🔐 AuthProvider.login: Result isSuccess: ${result.isSuccess}');
      debugPrint('🔐 AuthProvider.login: Result user: ${result.user != null ? "present" : "null"}');
      debugPrint('🔐 AuthProvider.login: Result message: ${result.message}');
      
      if (result.isSuccess && result.user != null) {
        debugPrint('🔐 AuthProvider.login: Setting state to authenticated');
        state = AuthState.authenticated(result.user!);
        debugPrint('🔐 AuthProvider.login: State set to authenticated successfully');
      } else {
        debugPrint('🔐 AuthProvider.login: Setting state to error: ${result.message}');
        state = AuthState.error(result.message);
      }
    } catch (e) {
      debugPrint('🔐 AuthProvider.login: Exception caught: $e');
      state = AuthState.error('Authentication failed');
    }
  }

  /// User Registration
  Future<void> register({
    required String email,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state.message != null) state = state.copyWith(message: null);
    if (state.error != null) state = state.copyWith(error: null);
    
    state = AuthState.loading();
    
    try {
      final result = await _authService.register(
        email: email,
        name: name,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      
      if (result.isSuccess && result.user != null) {
        state = AuthState.authenticated(result.user!);
      } else {
        state = AuthState.error(result.message);
      }
    } catch (e) {
      state = AuthState.error('Registration failed');
    }
  }

  /// User Logout
  Future<void> logout() async {
    state = AuthState.loading();
    
    try {
      await _authService.logout();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  /// Clear error message
  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }

  /// Clear success message
  void clearMessage() {
    if (state.message != null) {
      state = state.copyWith(message: null);
    }
  }

  /// Sign In (alias for login)
  Future<void> signIn(String email, String password) async {
    await login(email, password);
  }

  /// Sign Up (alias for register) 
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    await register(
      email: email,
      name: username,
      password: password,
      passwordConfirmation: password,
    );
  }

  /// Sign Out (alias for logout)
  Future<void> signOut() async {
    await logout();
  }

  /// Refresh user profile
  Future<void> refreshUser() async {
    if (!state.isAuthenticated) return;
    
    try {
      final result = await _authService.getCurrentUser();
      if (result.isSuccess && result.user != null) {
        state = AuthState.authenticated(result.user!);
      }
    } catch (e) {
      // Don't change state if refresh fails
    }
  }
}