
class SupabaseException implements Exception {
  const SupabaseException(this.message, [this.details]);

  final String message;
  final String? details;

  @override
  String toString() => 'SupabaseException: $message${details != null ? ' ($details)' : ''}';
}

class SupabaseNotInitializedException extends SupabaseException {
  const SupabaseNotInitializedException(super.message);
}

class SupabaseInitializationException extends SupabaseException {
  const SupabaseInitializationException(super.message, [super.details]);
}

class SupabaseAuthException extends SupabaseException {
  const SupabaseAuthException(super.message, [super.details, this.statusCode]);

  final int? statusCode;

  @override
  String toString() => 'SupabaseAuthException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class SupabaseDatabaseException extends SupabaseException {
  const SupabaseDatabaseException(super.message, [super.details, this.code]);

  final String? code;

  @override
  String toString() => 'SupabaseDatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

class SupabaseStorageException extends SupabaseException {
  const SupabaseStorageException(super.message, [super.details]);
}

class SupabaseRealtimeException extends SupabaseException {
  const SupabaseRealtimeException(super.message, [super.details]);
}

class SupabaseNetworkException extends SupabaseException {
  const SupabaseNetworkException(super.message, [super.details]);
}

class SupabasePermissionException extends SupabaseException {
  const SupabasePermissionException(super.message, [super.details]);
}

class SupabaseValidationException extends SupabaseException {
  const SupabaseValidationException(super.message, [super.details, this.field]);

  final String? field;

  @override
  String toString() => 'SupabaseValidationException: $message${field != null ? ' (Field: $field)' : ''}';
}

class SupabaseRateLimitException extends SupabaseException {
  const SupabaseRateLimitException(super.message, [super.details, this.retryAfter]);

  final Duration? retryAfter;

  @override
  String toString() => 'SupabaseRateLimitException: $message${retryAfter != null ? ' (Retry after: ${retryAfter!.inSeconds}s)' : ''}';
}

class SupabaseErrorHelper {
  static SupabaseException parseError(dynamic error) {
    if (error == null) {
      return const SupabaseException('Unknown error occurred');
    }

    if (error is Map<String, dynamic>) {
      final message = error['message'] as String? ?? 'Unknown error';
      final details = error['details'] as String?;
      final code = error['code'] as String?;
      final statusCode = error['status_code'] as int?;

      if (code?.startsWith('auth') == true || statusCode == 401 || statusCode == 403) {
        return SupabaseAuthException(message, details, statusCode);
      }

      if (code?.contains('PGRST') == true || statusCode == 406) {
        return SupabaseDatabaseException(message, details, code);
      }

      if (code?.contains('storage') == true) {
        return SupabaseStorageException(message, details);
      }

      if (statusCode == 429) {
        return SupabaseRateLimitException(message, details);
      }

      if (statusCode == 401 || statusCode == 403) {
        return SupabasePermissionException(message, details);
      }

      if (statusCode != null && statusCode >= 500) {
        return SupabaseNetworkException(message, details);
      }

      return SupabaseException(message, details);
    }

    if (error is String) {
      return SupabaseException(error);
    }

    if (error is Exception) {
      return SupabaseException(error.toString());
    }

    return SupabaseException('Unknown error: $error');
  }

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