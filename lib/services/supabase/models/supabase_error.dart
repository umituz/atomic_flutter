
class SupabaseError {
  const SupabaseError({
    required this.message,
    this.code,
    this.details,
    this.hint,
    this.statusCode,
  });

  final String message;
  
  final String? code;
  
  final String? details;
  
  final String? hint;
  
  final int? statusCode;

  factory SupabaseError.fromJson(Map<String, dynamic> json) {
    return SupabaseError(
      message: json['message'] as String? ?? 'Unknown error',
      code: json['code'] as String?,
      details: json['details'] as String?,
      hint: json['hint'] as String?,
      statusCode: json['status_code'] as int?,
    );
  }

  factory SupabaseError.fromException(Exception exception) {
    return SupabaseError(
      message: exception.toString(),
      code: 'EXCEPTION',
    );
  }

  factory SupabaseError.network({String? message}) {
    return SupabaseError(
      message: message ?? 'Network connection failed',
      code: 'NETWORK_ERROR',
      statusCode: 0,
    );
  }

  factory SupabaseError.timeout({String? message}) {
    return SupabaseError(
      message: message ?? 'Request timed out',
      code: 'TIMEOUT',
      statusCode: 408,
    );
  }

  factory SupabaseError.auth({String? message}) {
    return SupabaseError(
      message: message ?? 'Authentication failed',
      code: 'AUTH_ERROR',
      statusCode: 401,
    );
  }

  factory SupabaseError.permission({String? message}) {
    return SupabaseError(
      message: message ?? 'Insufficient permissions',
      code: 'PERMISSION_DENIED',
      statusCode: 403,
    );
  }

  factory SupabaseError.notFound({String? message}) {
    return SupabaseError(
      message: message ?? 'Resource not found',
      code: 'NOT_FOUND',
      statusCode: 404,
    );
  }

  factory SupabaseError.validation({String? message}) {
    return SupabaseError(
      message: message ?? 'Validation failed',
      code: 'VALIDATION_ERROR',
      statusCode: 400,
    );
  }

  factory SupabaseError.server({String? message}) {
    return SupabaseError(
      message: message ?? 'Internal server error',
      code: 'SERVER_ERROR',
      statusCode: 500,
    );
  }

  factory SupabaseError.database(String message) {
    return SupabaseError(
      message: message,
      code: 'DATABASE_ERROR',
      statusCode: 500,
    );
  }

  factory SupabaseError.storage(String message) {
    return SupabaseError(
      message: message,
      code: 'STORAGE_ERROR',
      statusCode: 500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'details': details,
      'hint': hint,
      'status_code': statusCode,
    };
  }

  bool get isAuthError => code?.contains('AUTH') == true || statusCode == 401;

  bool get isPermissionError => code?.contains('PERMISSION') == true || statusCode == 403;

  bool get isNetworkError => code?.contains('NETWORK') == true || statusCode == 0;

  bool get isServerError => (statusCode ?? 0) >= 500;

  bool get isClientError => (statusCode ?? 0) >= 400 && (statusCode ?? 0) < 500;

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