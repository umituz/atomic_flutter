library supabase_atomic_wrapper;

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/supabase_response.dart';
import 'models/supabase_user.dart';
import 'models/supabase_error.dart';
import 'auth/supabase_session_manager.dart';
import 'auth/supabase_auth_middleware.dart';

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
  
  factory AtomicSupabaseConfig.fromEnvironment() {
    return AtomicSupabaseConfig(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      enableLogging: const bool.fromEnvironment('SUPABASE_DEBUG', defaultValue: false),
    );
  }
}

class AtomicSupabase {
  static AtomicSupabase? _instance;
  static AtomicSupabase get instance => _instance ??= AtomicSupabase._();
  
  AtomicSupabase._();
  
  late SupabaseClient _client;
  late AtomicSupabaseConfig _config;
  bool _isInitialized = false;
  
  Future<void> initialize(AtomicSupabaseConfig config) async {
    if (_isInitialized) return;
    
    _config = config;
    
    await Supabase.initialize(
      url: config.url,
      anonKey: config.anonKey,
      debug: config.enableLogging,
    );
    _client = Supabase.instance.client;
    
    await SupabaseSessionManager.instance.initialize();
    
    _isInitialized = true;
  }
  
  SupabaseClient get client => _client;
  
  AtomicAuth get auth => AtomicAuth._();
  
  AtomicDatabase get database => AtomicDatabase._();
  
  AtomicStorage get storage => AtomicStorage._();
  
  AtomicSupabaseConfig get config => _config;
  
  bool get isInitialized => _isInitialized;
}

class AtomicAuth {
  AtomicAuth._();
  
  GoTrueClient get _auth => AtomicSupabase.instance.client.auth;
  
  SupabaseUser? get currentUser {
    final user = _auth.currentUser;
    return user != null ? SupabaseUser.fromSupabaseUser(user) : null;
  }
  
  SupabaseSession? get currentSession {
    final session = _auth.currentSession;
    return session != null ? SupabaseSession.fromSupabaseSession(session) : null;
  }
  
  Stream<SupabaseAuthResponse> get onAuthStateChange {
    return _auth.onAuthStateChange.map((data) {
      return SupabaseAuthResponse.success(
        user: data.session?.user != null ? SupabaseUser.fromSupabaseUser(data.session!.user) : null,
        session: data.session != null ? SupabaseSession.fromSupabaseSession(data.session!) : null,
      );
    });
  }
  
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
  
  SupabaseAuthMiddleware get middleware => SupabaseAuthMiddleware.instance;
}

class AtomicDatabase {
  AtomicDatabase._();
  
  SupabaseClient get _client => AtomicSupabase.instance.client;
  
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

class AtomicStorage {
  AtomicStorage._();
  
  
  Future<SupabaseResponse<String>> uploadFile(
    String bucket,
    String path,
    List<int> file, {
    String? contentType,
    bool upsert = false,
  }) async {
    return SupabaseResponse.error(
      SupabaseError.storage('Not implemented yet'),
    );
  }
  
  Future<SupabaseResponse<List<int>>> downloadFile(
    String bucket,
    String path,
  ) async {
    return SupabaseResponse.error(
      SupabaseError.storage('Not implemented yet'),
    );
  }
  
  String getPublicUrl(String bucket, String path) {
    return '';
  }
}

class AtomicLocalStorage {
}

class TypeConverter {
  
  
} 