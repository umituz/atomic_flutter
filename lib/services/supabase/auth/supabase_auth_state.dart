/// Supabase Authentication State
/// Manages authentication state for Supabase integration

import '../models/supabase_user.dart';
import '../models/supabase_response.dart';

/// Authentication state
enum AuthState {
  /// User is not authenticated
  unauthenticated,
  
  /// User is authenticated
  authenticated,
  
  /// Authentication is in progress
  loading,
  
  /// Authentication failed
  error,
}

/// Authentication event types
enum AuthEvent {
  /// User signed in
  signedIn,
  
  /// User signed out
  signedOut,
  
  /// Token refreshed
  tokenRefreshed,
  
  /// Password recovery initiated
  passwordRecovery,
  
  /// User updated
  userUpdated,
}

/// Authentication state data
class SupabaseAuthState {
  const SupabaseAuthState({
    required this.state,
    this.user,
    this.session,
    this.errorMessage,
    this.isLoading = false,
  });

  /// Current authentication state
  final AuthState state;
  
  /// Current authenticated user
  final SupabaseUser? user;
  
  /// Current session
  final SupabaseSession? session;
  
  /// Current error message
  final String? errorMessage;
  
  /// Loading indicator
  final bool isLoading;

  /// Check if user is authenticated
  bool get isAuthenticated => state == AuthState.authenticated && user != null;

  /// Check if user is not authenticated
  bool get isUnauthenticated => state == AuthState.unauthenticated;

  /// Check if authentication is in progress
  bool get isLoadingAuth => state == AuthState.loading;

  /// Check if there's an error
  bool get hasError => state == AuthState.error && errorMessage != null;

  /// Initial unauthenticated state
  static const initial = SupabaseAuthState(
    state: AuthState.unauthenticated,
  );

  /// Create loading state
  SupabaseAuthState loading() {
    return SupabaseAuthState(
      state: AuthState.loading,
      user: user,
      session: session,
      isLoading: true,
    );
  }

  /// Create authenticated state
  SupabaseAuthState authenticated({
    required SupabaseUser user,
    SupabaseSession? session,
  }) {
    return SupabaseAuthState(
      state: AuthState.authenticated,
      user: user,
      session: session,
    );
  }

  /// Create unauthenticated state
  SupabaseAuthState unauthenticated() {
    return const SupabaseAuthState(
      state: AuthState.unauthenticated,
    );
  }

  /// Create error state
  SupabaseAuthState withError(String errorMessage) {
    return SupabaseAuthState(
      state: AuthState.error,
      user: user,
      session: session,
      errorMessage: errorMessage,
    );
  }

  /// Copy with new values
  SupabaseAuthState copyWith({
    AuthState? state,
    SupabaseUser? user,
    SupabaseSession? session,
    String? errorMessage,
    bool? isLoading,
  }) {
    return SupabaseAuthState(
      state: state ?? this.state,
      user: user ?? this.user,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'SupabaseAuthState(state: $state, user: ${user?.email}, error: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupabaseAuthState &&
        other.state == state &&
        other.user == user &&
        other.session == session &&
        other.errorMessage == errorMessage &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return Object.hash(state, user, session, errorMessage, isLoading);
  }
}

/// Authentication event data
class SupabaseAuthEvent {
  const SupabaseAuthEvent({
    required this.event,
    this.user,
    this.session,
    this.error,
  });

  /// Event type
  final AuthEvent event;
  
  /// User associated with event
  final SupabaseUser? user;
  
  /// Session associated with event
  final SupabaseSession? session;
  
  /// Error associated with event
  final String? error;

  @override
  String toString() {
    return 'SupabaseAuthEvent(event: $event, user: ${user?.email})';
  }
} 