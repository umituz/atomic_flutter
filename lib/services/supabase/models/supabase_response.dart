/// Supabase Response Models
/// Standardized response wrappers for Supabase operations

import 'supabase_error.dart';

/// Generic response wrapper
class SupabaseResponse<T> {
  const SupabaseResponse({
    required this.data,
    this.error,
    this.count,
    this.status,
    this.statusText,
  });

  /// Response data
  final T? data;
  
  /// Error information
  final SupabaseError? error;
  
  /// Row count for database operations
  final int? count;
  
  /// HTTP status code
  final int? status;
  
  /// HTTP status text
  final String? statusText;

  /// Check if response is successful
  bool get isSuccess => error == null && data != null;

  /// Check if response has error
  bool get hasError => error != null;

  /// Create successful response
  factory SupabaseResponse.success(T data, {int? count}) {
    return SupabaseResponse<T>(
      data: data,
      count: count,
    );
  }

  /// Create error response
  factory SupabaseResponse.error(SupabaseError error) {
    return SupabaseResponse<T>(
      data: null,
      error: error,
    );
  }

  /// Create from JSON
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

  /// Convert to JSON
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

/// Pagination response
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

  /// Current page number
  final int? page;
  
  /// Page size
  final int? pageSize;
  
  /// Total number of pages
  final int? totalPages;
  
  /// Has next page
  final bool? hasNextPage;
  
  /// Has previous page
  final bool? hasPreviousPage;

  /// Create successful paginated response
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

  /// Create error paginated response
  factory SupabasePaginatedResponse.error(SupabaseError error) {
    return SupabasePaginatedResponse<T>(
      data: null,
      error: error,
    );
  }

  @override
  String toString() => 'SupabasePaginatedResponse(page: $page/$totalPages, count: $count, success: $isSuccess)';
}

/// Auth response
class SupabaseAuthResponse {
  const SupabaseAuthResponse({
    this.user,
    this.session,
    this.error,
  });

  /// User information
  final dynamic user; // Will be SupabaseUser when implemented
  
  /// Session information
  final SupabaseSession? session;
  
  /// Error information
  final SupabaseError? error;

  /// Check if response is successful
  bool get isSuccess => error == null && user != null;

  /// Check if response has error
  bool get hasError => error != null;

  /// Create successful response
  factory SupabaseAuthResponse.success({
    required dynamic user,
    SupabaseSession? session,
  }) {
    return SupabaseAuthResponse(
      user: user,
      session: session,
    );
  }

  /// Create error response
  factory SupabaseAuthResponse.error(SupabaseError error) {
    return SupabaseAuthResponse(error: error);
  }

  @override
  String toString() => 'SupabaseAuthResponse(success: $isSuccess, user: $user, error: $error)';
}

/// Session information
class SupabaseSession {
  const SupabaseSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.expiresAt,
    required this.tokenType,
    this.user,
  });

  /// Access token
  final String accessToken;
  
  /// Refresh token
  final String? refreshToken;
  
  /// Token expires in seconds
  final int expiresIn;
  
  /// Token expiration timestamp
  final int expiresAt;
  
  /// Token type (usually "bearer")
  final String tokenType;
  
  /// User associated with this session
  final dynamic user; // Will be SupabaseUser when implemented

  /// Check if session is expired
  bool get isExpired {
    return DateTime.now().millisecondsSinceEpoch > expiresAt * 1000;
  }

  /// Get expiration date
  DateTime get expirationDate {
    return DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
  }

  /// Create from official Supabase Session
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

  /// Create from JSON
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

  /// Convert to JSON
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

/// Storage response
class SupabaseStorageResponse {
  const SupabaseStorageResponse({
    this.path,
    this.id,
    this.fullPath,
    this.error,
  });

  /// File path
  final String? path;
  
  /// File ID
  final String? id;
  
  /// Full file path
  final String? fullPath;
  
  /// Error information
  final SupabaseError? error;

  /// Check if response is successful
  bool get isSuccess => error == null && path != null;

  /// Check if response has error
  bool get hasError => error != null;

  /// Create successful response
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

  /// Create error response
  factory SupabaseStorageResponse.error(SupabaseError error) {
    return SupabaseStorageResponse(error: error);
  }

  @override
  String toString() => 'SupabaseStorageResponse(success: $isSuccess, path: $path, error: $error)';
} 