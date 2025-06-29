/// Atomic Flutter wrapper for Supabase
/// Provides typed responses and atomic-specific features
/// Built on top of the official supabase_flutter package
library supabase_atomic_wrapper;

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/supabase_response.dart';
import 'models/supabase_user.dart';
import 'models/supabase_error.dart';
import 'auth/supabase_session_manager.dart';
import 'auth/supabase_auth_middleware.dart';

/// Atomic Flutter Supabase configuration
class AtomicSupabaseConfig {
  final String url;
  final String anonKey;
  final bool enableLogging;
  final Duration sessionRefreshThreshold;
  
  const AtomicSupabaseConfig({
    required this.url,
    required this.anonKey,
    this.enableLogging = false,
    this.sessionRefreshThreshold = const Duration(minutes: 5),
  });
  
  /// Create config from environment variables
  factory AtomicSupabaseConfig.fromEnvironment() {
    return AtomicSupabaseConfig(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      enableLogging: const bool.fromEnvironment('SUPABASE_DEBUG', defaultValue: false),
    );
  }
}

/// Main Atomic Supabase client wrapper
class AtomicSupabase {
  static AtomicSupabase? _instance;
  static AtomicSupabase get instance => _instance ??= AtomicSupabase._();
  
  AtomicSupabase._();
  
  late SupabaseClient _client;
  late AtomicSupabaseConfig _config;
  bool _isInitialized = false;
  
  /// Initialize Atomic Supabase wrapper
  Future<void> initialize(AtomicSupabaseConfig config) async {
    if (_isInitialized) return;
    
    _config = config;
    
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
      debug: config.enableLogging,
    );
    _client = Supabase.instance.client;
    
    // Initialize our atomic features
    await SupabaseSessionManager.instance.initialize();
    
    _isInitialized = true;
  }
  
  /// Get the official Supabase client
  SupabaseClient get client => _client;
  
  /// Auth wrapper with atomic features
  AtomicAuth get auth => AtomicAuth._();
  
  /// Database wrapper with typed responses
  AtomicDatabase get database => AtomicDatabase._();
  
  /// Storage wrapper with atomic features
  AtomicStorage get storage => AtomicStorage._();
  
  /// Configuration
  AtomicSupabaseConfig get config => _config;
  
  /// Check if initialized
  bool get isInitialized => _isInitialized;
}

/// Atomic Authentication wrapper
class AtomicAuth {
  AtomicAuth._();
  
  GoTrueClient get _auth => AtomicSupabase.instance.client.auth;
  
  /// Current user with atomic typing
  SupabaseUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? SupabaseUser.fromSupabaseUser(user) : null;
  }
  
  /// Current session
  SupabaseSession? get currentSession {
    final session = _auth.currentSession;
    return session != null ? SupabaseSession.fromSupabaseSession(session) : null;
  }
  
  /// Auth state stream with atomic types
  Stream<SupabaseAuthResponse> get onAuthStateChange {
    return _auth.onAuthStateChange.map((data) {
      return SupabaseAuthResponse.success(
        user: data.session?.user != null ? SupabaseUser.fromSupabaseUser(data.session!.user) : null,
        session: data.session != null ? SupabaseSession.fromSupabaseSession(data.session!) : null,
      );
    });
  }
  
  /// Sign up with typed response
  Future<SupabaseAuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
    String? emailRedirectTo,
    String? captchaToken,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        data: data,
        emailRedirectTo: emailRedirectTo,
        captchaToken: captchaToken,
      );
      
      return SupabaseAuthResponse.success(
        user: response.user != null ? SupabaseUser.fromSupabaseUser(response.user!) : null,
        session: response.session != null ? SupabaseSession.fromSupabaseSession(response.session!) : null,
      );
    } catch (e) {
      return SupabaseAuthResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Sign in with password
  Future<SupabaseAuthResponse> signInWithPassword({
    required String email,
    required String password,
    String? captchaToken,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
        captchaToken: captchaToken,
      );
      
      return SupabaseAuthResponse.success(
        user: SupabaseUser.fromSupabaseUser(response.user),
        session: SupabaseSession.fromSupabaseSession(response.session),
      );
    } catch (e) {
      return SupabaseAuthResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Sign in with OTP
  Future<SupabaseResponse<void>> signInWithOtp({
    String? email,
    String? phone,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _auth.signInWithOtp(
        email: email,
        phone: phone,
        emailRedirectTo: emailRedirectTo,
        data: data,
      );
      
      return SupabaseResponse.success(null);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Verify OTP
  Future<SupabaseAuthResponse> verifyOtp({
    required String token,
    required OtpType type,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _auth.verifyOTP(
        token: token,
        type: type,
        email: email,
        phone: phone,
      );
      
      return SupabaseAuthResponse.success(
        user: response.user != null ? SupabaseUser.fromSupabaseUser(response.user!) : null,
        session: response.session != null ? SupabaseSession.fromSupabaseSession(response.session!) : null,
      );
    } catch (e) {
      return SupabaseAuthResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Sign out
  Future<SupabaseResponse<void>> signOut() async {
    try {
      await _auth.signOut();
      await SupabaseSessionManager.instance.clearSession();
      return SupabaseResponse.success(null);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Reset password
  Future<SupabaseResponse<void>> resetPasswordForEmail(
    String email, {
    String? redirectTo,
  }) async {
    try {
      await _auth.resetPasswordForEmail(
        email,
        redirectTo: redirectTo,
      );
      
      return SupabaseResponse.success(null);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Update user
  Future<SupabaseAuthResponse> updateUser({
    String? email,
    String? phone,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _auth.updateUser(
        UserAttributes(
          email: email,
          phone: phone,
          password: password,
          data: data,
        ),
      );
      
      return SupabaseAuthResponse.success(
        user: SupabaseUser.fromSupabaseUser(response.user!),
        session: null,
      );
    } catch (e) {
      return SupabaseAuthResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Get middleware instance
  SupabaseAuthMiddleware get middleware => SupabaseAuthMiddleware.instance;
}

/// Atomic Database wrapper
class AtomicDatabase {
  AtomicDatabase._();
  
  SupabaseClient get _client => AtomicSupabase.instance.client;
  
  /// Select with typed response
  Future<SupabaseResponse<List<Map<String, dynamic>>>> select(
    String table, {
    String columns = '*',
  }) async {
    try {
      final data = await _client.from(table).select(columns);
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Select with filters
  Future<SupabaseResponse<List<Map<String, dynamic>>>> selectWhere(
    String table,
    String column,
    dynamic value, {
    String columns = '*',
  }) async {
    try {
      final data = await _client
          .from(table)
          .select(columns)
          .eq(column, value);
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Insert with typed response
  Future<SupabaseResponse<List<Map<String, dynamic>>>> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _client.from(table).insert(data).select();
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Update with typed response
  Future<SupabaseResponse<List<Map<String, dynamic>>>> update(
    String table,
    String whereColumn,
    dynamic whereValue,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await _client
          .from(table)
          .update(data)
          .eq(whereColumn, whereValue)
          .select();
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
  
  /// Delete with typed response
  Future<SupabaseResponse<void>> delete(
    String table,
    String whereColumn,
    dynamic whereValue,
  ) async {
    try {
      await _client
          .from(table)
          .delete()
          .eq(whereColumn, whereValue);
      return SupabaseResponse.success(null);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.fromException(Exception(e.toString())),
      );
    }
  }
}

/// Atomic Storage wrapper
class AtomicStorage {
  AtomicStorage._();
  
  // TODO: Get official storage client
  // SupabaseStorageClient get _storage => AtomicSupabase.instance.client.storage;
  
  /// Upload file with typed response
  Future<SupabaseResponse<String>> uploadFile(
    String bucket,
    String path,
    List<int> file, {
    String? contentType,
    bool upsert = false,
  }) async {
    // TODO: Implement with official supabase_flutter package
    return SupabaseResponse.error(
      SupabaseError.storage('Not implemented yet'),
    );
  }
  
  /// Download file with typed response
  Future<SupabaseResponse<List<int>>> downloadFile(
    String bucket,
    String path,
  ) async {
    // TODO: Implement with official supabase_flutter package
    return SupabaseResponse.error(
      SupabaseError.storage('Not implemented yet'),
    );
  }
  
  /// Get public URL
  String getPublicUrl(String bucket, String path) {
    // TODO: Implement with official supabase_flutter package
    return '';
  }
}

/// Custom local storage for atomic features
class AtomicLocalStorage {
  // TODO: Implement custom local storage if needed
  // This can extend the official LocalStorage interface
}

/// Helper to convert between official and atomic types
class TypeConverter {
  // TODO: Add conversion methods between official Supabase types and our atomic types
  
  /// Convert official User to SupabaseUser
  // static SupabaseUser convertUser(User user) {
  //   return SupabaseUser(
  //     id: user.id,
  //     email: user.email,
  //     phone: user.phone,
  //     // ... other conversions
  //   );
  // }
  
  /// Convert official Session to SupabaseSession
  // static SupabaseSession convertSession(Session session) {
  //   return SupabaseSession(
  //     accessToken: session.accessToken,
  //     refreshToken: session.refreshToken,
  //     expiresAt: session.expiresAt,
  //     // ... other conversions
  //   );
  // }
} 