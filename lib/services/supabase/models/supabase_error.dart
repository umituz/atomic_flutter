/// Supabase Error Model
/// Standardized error representation for Supabase operations

/// Represents an error returned by Supabase
class SupabaseError {
  const SupabaseError({
    required this.message,
    this.code,
    this.details,
    this.hint,
    this.statusCode,
  });

  /// Error message
  final String message;
  
  /// Error code
  final String? code;
  
  /// Additional error details
  final String? details;
  
  /// Hint for resolving the error
  final String? hint;
  
  /// HTTP status code
  final int? statusCode;

  /// Create from JSON
  factory SupabaseError.fromJson(Map<String, dynamic> json) {
    return SupabaseError(
      message: json['message'] as String? ?? 'Unknown error',
      code: json['code'] as String?,
      details: json['details'] as String?,
      hint: json['hint'] as String?,
      statusCode: json['status_code'] as int?,
    );
  }

  /// Create from Exception
  factory SupabaseError.fromException(Exception exception) {
    return SupabaseError(
      message: exception.toString(),
      code: 'EXCEPTION',
    );
  }

  /// Create network error
  factory SupabaseError.network({String? message}) {
    return SupabaseError(
      message: message ?? 'Network connection failed',
      code: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }

  /// Create timeout error
  factory SupabaseError.timeout({String? message}) {
    return SupabaseError(
      message: message ?? 'Request timed out',
      code: 'TIMEOUT',
      statusCode: 408,
    );
  }

  /// Create auth error
  factory SupabaseError.auth({String? message}) {
    return SupabaseError(
      message: message ?? 'Authentication failed',
      code: 'AUTH_ERROR',
      statusCode: 401,
    );
  }

  /// Create permission error
  factory SupabaseError.permission({String? message}) {
    return SupabaseError(
      message: message ?? 'Insufficient permissions',
      code: 'PERMISSION_DENIED',
      statusCode: 403,
    );
  }

  /// Create not found error
  factory SupabaseError.notFound({String? message}) {
    return SupabaseError(
      message: message ?? 'Resource not found',
      code: 'NOT_FOUND',
      statusCode: 404,
    );
  }

  /// Create validation error
  factory SupabaseError.validation({String? message}) {
    return SupabaseError(
      message: message ?? 'Validation failed',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );
  }

  /// Create server error
  factory SupabaseError.server({String? message}) {
    return SupabaseError(
      message: message ?? 'Internal server error',
      code: 'SERVER_ERROR',
      statusCode: 500,
    );
  }

  /// Create database error
  factory SupabaseError.database(String message) {
    return SupabaseError(
      message: message,
      code: 'DATABASE_ERROR',
      statusCode: 500,
    );
  }

  /// Create storage error
  factory SupabaseError.storage(String message) {
    return SupabaseError(
      message: message,
      code: 'STORAGE_ERROR',
      statusCode: 500,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'details': details,
      'hint': hint,
      'status_code': statusCode,
    };
  }

  /// Check if error is related to authentication
  bool get isAuthError => code?.contains('AUTH') == true || statusCode == 401;

  /// Check if error is related to permissions
  bool get isPermissionError => code?.contains('PERMISSION') == true || statusCode == 403;

  /// Check if error is network related
  bool get isNetworkError => code?.contains('NETWORK') == true || statusCode == 0;

  /// Check if error is server related
  bool get isServerError => (statusCode ?? 0) >= 500;

  /// Check if error is client related
  bool get isClientError => (statusCode ?? 0) >= 400 && (statusCode ?? 0) < 500;

  /// Get user-friendly error message
  String get userFriendlyMessage {
    if (isNetworkError) {
      return 'Please check your internet connection and try again.';
    }
    if (isAuthError) {
      return 'Please sign in to continue.';
    }
    if (isPermissionError) {
      return 'You don\'t have permission to perform this action.';
    }
    if (isServerError) {
      return 'Something went wrong on our end. Please try again later.';
    }
    return message;
  }

  @override
  String toString() => 'SupabaseError(code: $code, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupabaseError &&
        other.message == message &&
        other.code == code &&
        other.details == details &&
        other.hint == hint &&
        other.statusCode == statusCode;
  }

  @override
  int get hashCode {
    return Object.hash(message, code, details, hint, statusCode);
  }
} 