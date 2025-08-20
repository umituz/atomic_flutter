library supabase_auth_helpers;

import 'dart:math';

import '../models/supabase_user.dart';

class EmailValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static bool isValid(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim().toLowerCase());
  }
  
  static String normalize(String email) {
    return email.trim().toLowerCase();
  }
  
  static String? getDomain(String email) {
    if (!isValid(email)) return null;
    final parts = email.split('@');
    return parts.length == 2 ? parts[1] : null;
  }
}

class PhoneValidator {
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  
  static bool isValid(String phone) {
    if (phone.isEmpty) return false;
    final cleanPhone = normalize(phone);
    return _phoneRegex.hasMatch(cleanPhone);
  }
  
  static String normalize(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }
  
  static String format(String phone, {String defaultCountryCode = '+1'}) {
    final cleanPhone = normalize(phone);
    if (!cleanPhone.startsWith('+') && !cleanPhone.startsWith('00')) {
      return '$defaultCountryCode$cleanPhone';
    }
    return cleanPhone;
  }
}

class PasswordValidator {
  static const int minLength = 8;
  
  static const int maxLength = 128;
  
  static PasswordValidationResult validate(String password) {
    final issues = <String>[];
    
    if (password.length < minLength) {
      issues.add('Password must be at least $minLength characters');
    }
    
    if (password.length > maxLength) {
      issues.add('Password must be less than $maxLength characters');
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      issues.add('Password must contain at least one uppercase letter');
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      issues.add('Password must contain at least one lowercase letter');
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      issues.add('Password must contain at least one number');
    }
    
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      issues.add('Password must contain at least one special character');
    }
    
    return PasswordValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      strength: _calculateStrength(password),
    );
  }
  
  static int _calculateStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    return strength;
  }
  
  static String generate({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*(),.?":{}|<>';
    
    String chars = '';
    if (includeUppercase) chars += uppercase;
    if (includeLowercase) chars += lowercase;
    if (includeNumbers) chars += numbers;
    if (includeSymbols) chars += symbols;
    
    if (chars.isEmpty) chars = lowercase; // Fallback
    
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}

class PasswordValidationResult {
  final bool isValid;
  final List<String> issues;
  final int strength; // 0-5 scale
  
  const PasswordValidationResult({
    required this.isValid,
    required this.issues,
    required this.strength,
  });
  
  String get strengthDescription {
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return 'Unknown';
    }
  }
  
  String get strengthColor {
    switch (strength) {
      case 0:
      case 1:
        return '#FF4444'; // Red
      case 2:
        return '#FF8800'; // Orange
      case 3:
        return '#FFBB00'; // Yellow
      case 4:
        return '#88BB00'; // Light Green
      case 5:
        return '#00BB00'; // Green
      default:
        return '#CCCCCC'; // Gray
    }
  }
}

class OtpHelper {
  static String generateNumeric({int length = 6}) {
    final random = Random.secure();
    return List.generate(length, (index) => random.nextInt(10)).join();
  }
  
  static String generateAlphanumeric({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
  
  static bool isValidFormat(String otp, {int expectedLength = 6}) {
    if (otp.length != expectedLength) return false;
    return RegExp(r'^\d+$').hasMatch(otp); // Only digits
  }
  
  static String formatForDisplay(String otp) {
    if (otp.length <= 4) return otp;
    
    final buffer = StringBuffer();
    for (int i = 0; i < otp.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(otp[i]);
    }
    return buffer.toString();
  }
}

class UserHelper {
  static String getDisplayName(SupabaseUser user) {
    if (user.userMetadata?['full_name'] != null) {
      final fullName = user.userMetadata!['full_name'] as String;
      if (fullName.isNotEmpty) return fullName;
    }
    
    final firstName = user.userMetadata?['first_name'] as String?;
    final lastName = user.userMetadata?['last_name'] as String?;
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    if (firstName != null) return firstName;
    
    if (user.email != null) {
      return user.email!.split('@')[0];
    }
    
    return 'User';
  }
  
  static String getInitials(SupabaseUser user) {
    final displayName = getDisplayName(user);
    final words = displayName.split(' ');
    
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty && words[0].isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    
    return 'U';
  }
  
  static String? getAvatarUrl(SupabaseUser user) {
    final avatarUrl = user.userMetadata?['avatar_url'] as String?;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }
    
    if (user.identities != null && user.identities!.isNotEmpty) {
      for (final identity in user.identities!) {
        final identityAvatar = identity.identityData?['avatar_url'] as String?;
        if (identityAvatar != null && identityAvatar.isNotEmpty) {
          return identityAvatar;
        }
      }
    }
    
    return null;
  }
  
  static bool hasRole(SupabaseUser user, String role) {
    final roles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    return roles.contains(role);
  }
  
  static bool hasAnyRole(SupabaseUser user, List<String> roles) {
    final userRoles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    return roles.any((role) => userRoles.contains(role));
  }
  
  static bool hasAllRoles(SupabaseUser user, List<String> roles) {
    final userRoles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    return roles.every((role) => userRoles.contains(role));
  }
}

class AuthErrorHelper {
  static String getUserFriendlyMessage(dynamic error) {
    final errorMessage = error.toString().toLowerCase();
    
    if (errorMessage.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check and try again.';
    }
    
    if (errorMessage.contains('email already exists') || 
        errorMessage.contains('user already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    }
    
    if (errorMessage.contains('weak password')) {
      return 'Password is too weak. Please choose a stronger password.';
    }
    
    if (errorMessage.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    
    if (errorMessage.contains('network')) {
      return 'Network error. Please check your connection and try again.';
    }
    
    if (errorMessage.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (errorMessage.contains('rate limit')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    
    if (errorMessage.contains('email not confirmed')) {
      return 'Please check your email and click the confirmation link.';
    }
    
    return 'Something went wrong. Please try again.';
  }
  
  static bool isRetryableError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();
    
    if (errorMessage.contains('network') || 
        errorMessage.contains('timeout') ||
        errorMessage.contains('connection')) {
      return true;
    }
    
    if (errorMessage.contains('rate limit')) {
      return true;
    }
    
    return false;
  }
} 