/// Session management service for Supabase authentication
/// Provides atomic-specific session features on top of official supabase_flutter
library supabase_session_manager;

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/supabase_response.dart';

/// Session manager that wraps official Supabase session management
/// with atomic-specific features
class SupabaseSessionManager {
  static SupabaseSessionManager? _instance;
  static SupabaseSessionManager get instance => _instance ??= SupabaseSessionManager._();
  
  SupabaseSessionManager._();
  
  GoTrueClient get _auth => Supabase.instance.client.auth;
  
  /// Initialize session manager
  Future<void> initialize() async {
    // Official supabase_flutter handles initialization
    // We just provide additional atomic features here
  }
  
  /// Get current session from official client
  SupabaseSession? get currentSession {
    final session = _auth.currentSession;
    return session != null ? SupabaseSession.fromSupabaseSession(session) : null;
  }
  
  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;
  
  /// Get current user ID
  String? get userId => _auth.currentUser?.id;
  
  /// Get current access token
  String? get accessToken => _auth.currentSession?.accessToken;
  
  /// Get current refresh token
  String? get refreshToken => _auth.currentSession?.refreshToken;
  
  /// Clear session (handled by official client)
  Future<void> clearSession() async {
    // Official client handles session clearing through signOut
    // This is just a placeholder for any atomic-specific cleanup
  }
  
  /// Force refresh session
  Future<SupabaseSession?> forceRefresh() async {
    try {
      final session = await _auth.refreshSession();
      return session != null ? SupabaseSession.fromSupabaseSession(session) : null;
    } catch (e) {
      return null;
    }
  }
  
  /// Listen to auth state changes
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
}

/// Extension to add atomic-specific session utilities
extension SupabaseSessionExpiry on SupabaseSession {
  /// Get expiry as DateTime
  DateTime get expiryDateTime => DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
  
  /// Check if session is expired
  bool get isExpired => DateTime.now().isAfter(expiryDateTime);
  
  /// Check if session expires soon (within 5 minutes)
  bool get expiresSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiryDateTime);
  }
  
  /// Time until expiry
  Duration get timeUntilExpiry {
    final remaining = expiryDateTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
} 