
import 'supabase_error.dart';

class SupabaseResponse<T> {
  const SupabaseResponse({
    required this.data,
    this.error,
    this.count,
    this.status,
    this.statusText,
  });

  final T? data;
  
  final SupabaseError? error;
  
  final int? count;
  
  final int? status;
  
  final String? statusText;

  bool get isSuccess => error == null && data != null;

  bool get hasError => error != null;

  factory SupabaseResponse.success(T data, {int? count}) {
    return SupabaseResponse<T>(
      data: data,
      count: count,
    );
  }

  factory SupabaseResponse.error(SupabaseError error) {
    return SupabaseResponse<T>(
      data: null,
      error: error,
    );
  }

  factory SupabaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) dataFromJson,
  ) {
    return SupabaseResponse<T>(
      data: json['data'] != null ? dataFromJson(json['data']) : null,
      error: json['error'] != null 
          ? SupabaseError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      count: json['count'] as int?,
      status: json['status'] as int?,
      statusText: json['statusText'] as String?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T?) dataToJson) {
    return {
      'data': dataToJson(data),
      'error': error?.toJson(),
      'count': count,
      'status': status,
      'statusText': statusText,
    };
  }

  @override
  String toString() => 'SupabaseResponse(success: $isSuccess, data: $data, error: $error)';
}

class SupabasePaginatedResponse<T> extends SupabaseResponse<List<T>> {
  const SupabasePaginatedResponse({
    required super.data,
    super.error,
    super.count,
    super.status,
    super.statusText,
    this.page,
    this.pageSize,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  final int? page;
  
  final int? pageSize;
  
  final int? totalPages;
  
  final bool? hasNextPage;
  
  final bool? hasPreviousPage;

  factory SupabasePaginatedResponse.success(
    List<T> data, {
    required int count,
    int? page,
    int? pageSize,
  }) {
    final totalPages = pageSize != null ? (count / pageSize).ceil() : null;
    final currentPage = page ?? 1;
    
    return SupabasePaginatedResponse<T>(
      data: data,
      count: count,
      page: currentPage,
      pageSize: pageSize,
      totalPages: totalPages,
      hasNextPage: totalPages != null ? currentPage < totalPages : null,
      hasPreviousPage: currentPage > 1,
    );
  }

  factory SupabasePaginatedResponse.error(SupabaseError error) {
    return SupabasePaginatedResponse<T>(
      data: null,
      error: error,
    );
  }

  @override
  String toString() => 'SupabasePaginatedResponse(page: $page/$totalPages, count: $count, success: $isSuccess)';
}

class SupabaseAuthResponse {
  const SupabaseAuthResponse({
    this.user,
    this.session,
    this.error,
  });

  final dynamic user; // Will be SupabaseUser when implemented
  
  final SupabaseSession? session;
  
  final SupabaseError? error;

  bool get isSuccess => error == null && user != null;

  bool get hasError => error != null;

  factory SupabaseAuthResponse.success({
    required dynamic user,
    SupabaseSession? session,
  }) {
    return SupabaseAuthResponse(
      user: user,
      session: session,
    );
  }

  factory SupabaseAuthResponse.error(SupabaseError error) {
    return SupabaseAuthResponse(error: error);
  }

  @override
  String toString() => 'SupabaseAuthResponse(success: $isSuccess, user: $user, error: $error)';
}

class SupabaseSession {
  const SupabaseSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.expiresAt,
    required this.tokenType,
    this.user,
  });

  final String accessToken;
  
  final String? refreshToken;
  
  final int expiresIn;
  
  final int expiresAt;
  
  final String tokenType;
  
  final dynamic user; // Will be SupabaseUser when implemented

  bool get isExpired {
    return DateTime.now().millisecondsSinceEpoch > expiresAt * 1000;
  }

  DateTime get expirationDate {
    return DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
  }

  factory SupabaseSession.fromSupabaseSession(dynamic session) {
    return SupabaseSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresIn: session.expiresIn,
      expiresAt: session.expiresAt,
      tokenType: session.tokenType,
      user: session.user,
    );
  }

  factory SupabaseSession.fromJson(Map<String, dynamic> json) {
    return SupabaseSession(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresIn: json['expires_in'] as int,
      expiresAt: json['expires_at'] as int,
      tokenType: json['token_type'] as String,
      user: json['user'], // Parse user when implemented
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
      'expires_at': expiresAt,
      'token_type': tokenType,
      'user': user, // Serialize user when implemented
    };
  }

  @override
  String toString() => 'SupabaseSession(tokenType: $tokenType, expiresAt: ${expirationDate.toIso8601String()})';
}

class SupabaseStorageResponse {
  const SupabaseStorageResponse({
    this.path,
    this.id,
    this.fullPath,
    this.error,
  });

  final String? path;
  
  final String? id;
  
  final String? fullPath;
  
  final SupabaseError? error;

  bool get isSuccess => error == null && path != null;

  bool get hasError => error != null;

  factory SupabaseStorageResponse.success({
    required String path,
    String? id,
    String? fullPath,
  }) {
    return SupabaseStorageResponse(
      path: path,
      id: id,
      fullPath: fullPath,
    );
  }

  factory SupabaseStorageResponse.error(SupabaseError error) {
    return SupabaseStorageResponse(error: error);
  }

  @override
  String toString() => 'SupabaseStorageResponse(success: $isSuccess, path: $path, error: $error)';
} 