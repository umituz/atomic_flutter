import 'auth_user.dart';

/// 🔐 Centralized Authentication Result Model
/// 
/// This model wraps API responses for authentication operations.
/// Provides consistent error handling across all Flutter applications.
class AuthResult {
  final bool isSuccess;
  final String message;
  final List<String> errors;
  final AuthUser? user;
  final String? token;

  const AuthResult({
    required this.isSuccess,
    required this.message,
    this.errors = const [],
    this.user,
    this.token,
  });

  factory AuthResult.success({
    required String message,
    AuthUser? user,
    String? token,
  }) {
    return AuthResult(
      isSuccess: true,
      message: message,
      user: user,
      token: token,
    );
  }

  factory AuthResult.error({
    required String message,
    List<String> errors = const [],
  }) {
    return AuthResult(
      isSuccess: false,
      message: message,
      errors: errors,
    );
  }

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      isSuccess: json['success'] == true,
      message: json['message'] ?? '',
      errors: json['errors'] is List 
          ? List<String>.from(json['errors']) 
          : [],
      user: json['data']?['user'] != null 
          ? AuthUser.fromJson(json['data']['user']) 
          : null,
      token: json['data']?['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'message': message,
      'errors': errors,
      'data': {
        if (user != null) 'user': user!.toJson(),
        if (token != null) 'token': token,
      },
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResult &&
        other.isSuccess == isSuccess &&
        other.message == message &&
        other.errors.length == errors.length &&
        other.user == user &&
        other.token == token;
  }

  @override
  int get hashCode {
    return isSuccess.hashCode ^
        message.hashCode ^
        errors.hashCode ^
        user.hashCode ^
        token.hashCode;
  }

  @override
  String toString() {
    return 'AuthResult(isSuccess: $isSuccess, message: $message, errors: $errors, user: $user, token: $token)';
  }
}