/// Supabase Exception Classes
/// Custom exceptions for Supabase operations

/// Base Supabase exception
class SupabaseException implements Exception {
  const SupabaseException(this.message, [this.details]);

  final String message;
  final String? details;

  @override
  String toString() => 'SupabaseException: $message${details != null ? ' ($details)' : ''}';
}

/// Exception thrown when Supabase client is not initialized
class SupabaseNotInitializedException extends SupabaseException {
  const SupabaseNotInitializedException(super.message);
}

/// Exception thrown when Supabase initialization fails
class SupabaseInitializationException extends SupabaseException {
  const SupabaseInitializationException(super.message, [super.details]);
}

/// Authentication related exceptions
class SupabaseAuthException extends SupabaseException {
  const SupabaseAuthException(super.message, [super.details, this.statusCode]);

  final int? statusCode;

  @override
  String toString() => 'SupabaseAuthException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Database operation exceptions
class SupabaseDatabaseException extends SupabaseException {
  const SupabaseDatabaseException(super.message, [super.details, this.code]);

  final String? code;

  @override
  String toString() => 'SupabaseDatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Storage operation exceptions
class SupabaseStorageException extends SupabaseException {
  const SupabaseStorageException(super.message, [super.details]);
}

/// Realtime subscription exceptions
class SupabaseRealtimeException extends SupabaseException {
  const SupabaseRealtimeException(super.message, [super.details]);
}

/// Network related exceptions
class SupabaseNetworkException extends SupabaseException {
  const SupabaseNetworkException(super.message, [super.details]);
}

/// Permission denied exceptions
class SupabasePermissionException extends SupabaseException {
  const SupabasePermissionException(super.message, [super.details]);
}

/// Validation exceptions
class SupabaseValidationException extends SupabaseException {
  const SupabaseValidationException(super.message, [super.details, this.field]);

  final String? field;

  @override
  String toString() => 'SupabaseValidationException: $message${field != null ? ' (Field: $field)' : ''}';
}

/// Rate limit exceptions
class SupabaseRateLimitException extends SupabaseException {
  const SupabaseRateLimitException(super.message, [super.details, this.retryAfter]);

  final Duration? retryAfter;

  @override
  String toString() => 'SupabaseRateLimitException: $message${retryAfter != null ? ' (Retry after: ${retryAfter!.inSeconds}s)' : ''}';
}

/// Helper to parse Supabase errors
class SupabaseErrorHelper {
  /// Parse error from Supabase response
  static SupabaseException parseError(dynamic error) {
    if (error == null) {
      return const SupabaseException('Unknown error occurred');
    }

    // Handle different error types based on error structure
    if (error is Map<String, dynamic>) {
      final message = error['message'] as String? ?? 'Unknown error';
      final details = error['details'] as String?;
      final code = error['code'] as String?;
      final statusCode = error['status_code'] as int?;

      // Auth errors
      if (code?.startsWith('auth') == true || statusCode == 401 || statusCode == 403) {
        return SupabaseAuthException(message, details, statusCode);
      }

      // Database errors
      if (code?.contains('PGRST') == true || statusCode == 406) {
        return SupabaseDatabaseException(message, details, code);
      }

      // Storage errors
      if (code?.contains('storage') == true) {
        return SupabaseStorageException(message, details);
      }

      // Rate limit errors
      if (statusCode == 429) {
        return SupabaseRateLimitException(message, details);
      }

      // Permission errors
      if (statusCode == 401 || statusCode == 403) {
        return SupabasePermissionException(message, details);
      }

      // Network errors
      if (statusCode != null && statusCode >= 500) {
        return SupabaseNetworkException(message, details);
      }

      // Generic exception
      return SupabaseException(message, details);
    }

    // String error
    if (error is String) {
      return SupabaseException(error);
    }

    // Exception error
    if (error is Exception) {
      return SupabaseException(error.toString());
    }

    return SupabaseException('Unknown error: $error');
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(SupabaseException exception) {
    switch (exception.runtimeType) {
      case SupabaseAuthException:
        return _getAuthErrorMessage(exception as SupabaseAuthException);
      case SupabaseDatabaseException:
        return 'Database operation failed. Please try again.';
      case SupabaseStorageException:
        return 'File operation failed. Please try again.';
      case SupabaseNetworkException:
        return 'Network error. Please check your connection.';
      case SupabasePermissionException:
        return 'You don\'t have permission to perform this action.';
      case SupabaseRateLimitException:
        return 'Too many requests. Please wait and try again.';
      case SupabaseValidationException:
        return exception.message;
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  static String _getAuthErrorMessage(SupabaseAuthException exception) {
    final message = exception.message.toLowerCase();
    
    if (message.contains('invalid credentials') || message.contains('invalid login')) {
      return 'Invalid email or password. Please try again.';
    }
    
    if (message.contains('email not confirmed')) {
      return 'Please check your email and confirm your account.';
    }
    
    if (message.contains('user not found')) {
      return 'No account found with this email address.';
    }
    
    if (message.contains('password')) {
      return 'Password is incorrect. Please try again.';
    }
    
    if (message.contains('email')) {
      return 'Please enter a valid email address.';
    }
    
    return 'Authentication failed. Please try again.';
  }
} 