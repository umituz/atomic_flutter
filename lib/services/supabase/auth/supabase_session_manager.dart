library supabase_session_manager;

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/supabase_response.dart';

class SupabaseSessionManager {
  static SupabaseSessionManager? _instance;
  static SupabaseSessionManager get instance => _instance ??= SupabaseSessionManager._();
  
  SupabaseSessionManager._();
  
  GoTrueClient get _auth => Supabase.instance.client.auth;
  
  Future<void> initialize() async {
  }
  
  SupabaseSession? get currentSession {
    final session = _auth.currentSession;
    return session != null ? SupabaseSession.fromSupabaseSession(session) : null;
  }
  
  bool get isAuthenticated => _auth.currentUser != null;
  
  String? get userId => _auth.currentUser?.id;
  
  String? get accessToken => _auth.currentSession?.accessToken;
  
  String? get refreshToken => _auth.currentSession?.refreshToken;
  
  Future<void> clearSession() async {
  }
  
  Future<SupabaseSession?> forceRefresh() async {
    try {
      final session = await _auth.refreshSession();
      return session != null ? SupabaseSession.fromSupabaseSession(session) : null;
    } catch (e) {
      return null;
    }
  }
  
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;
}

extension SupabaseSessionExpiry on SupabaseSession {
  DateTime get expiryDateTime => DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
  
  bool get isExpired => DateTime.now().isAfter(expiryDateTime);
  
  bool get expiresSoon {
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiryDateTime);
  }
  
  Duration get timeUntilExpiry {
    final remaining = expiryDateTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
} 