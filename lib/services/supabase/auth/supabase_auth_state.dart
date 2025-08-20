
import 'package:atomic_flutter/services/supabase/models/supabase_user.dart';
import 'package:atomic_flutter/services/supabase/models/supabase_response.dart';

enum AuthState {
  unauthenticated,
  
  authenticated,
  
  loading,
  
  error,
}

enum AuthEvent {
  signedIn,
  
  signedOut,
  
  tokenRefreshed,
  
  passwordRecovery,
  
  userUpdated,
}

class SupabaseAuthState {
  const SupabaseAuthState({
    required this.state,
    this.user,
    this.session,
    this.errorMessage,
    this.isLoading = false,
  });

  final AuthState state;
  
  final SupabaseUser? user;
  
  final SupabaseSession? session;
  
  final String? errorMessage;
  
  final bool isLoading;

  bool get isAuthenticated => state == AuthState.authenticated && user != null;

  bool get isUnauthenticated => state == AuthState.unauthenticated;

  bool get isLoadingAuth => state == AuthState.loading;

  bool get hasError => state == AuthState.error && errorMessage != null;

  static const initial = SupabaseAuthState(
    state: AuthState.unauthenticated,
  );

  SupabaseAuthState loading() {
    return SupabaseAuthState(
      state: AuthState.loading,
      user: user,
      session: session,
      isLoading: true,
    );
  }

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

  SupabaseAuthState unauthenticated() {
    return const SupabaseAuthState(
      state: AuthState.unauthenticated,
    );
  }

  SupabaseAuthState withError(String errorMessage) {
    return SupabaseAuthState(
      state: AuthState.error,
      user: user,
      session: session,
      errorMessage: errorMessage,
    );
  }

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

class SupabaseAuthEvent {
  const SupabaseAuthEvent({
    required this.event,
    this.user,
    this.session,
    this.error,
  });

  final AuthEvent event;
  
  final SupabaseUser? user;
  
  final SupabaseSession? session;
  
  final String? error;

  @override
  String toString() {
    return 'SupabaseAuthEvent(event: $event, user: ${user?.email})';
  }
} 