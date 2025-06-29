/// Authentication helpers and utilities for Supabase auth operations
/// Provides atomic-specific validation, formatting, and utility functions
library supabase_auth_helpers;

import 'dart:math';

import '../models/supabase_user.dart';

/// Email validation utilities
class EmailValidator {
  /// Email regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  /// Validate email format
  static bool isValid(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim().toLowerCase());
  }
  
  /// Normalize email (lowercase, trim)
  static String normalize(String email) {
    return email.trim().toLowerCase();
  }
  
  /// Get domain from email
  static String? getDomain(String email) {
    if (!isValid(email)) return null;
    final parts = email.split('@');
    return parts.length == 2 ? parts[1] : null;
  }
}

/// Phone number validation utilities
class PhoneValidator {
  /// Basic phone regex (international format)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  
  /// Validate phone number format
  static bool isValid(String phone) {
    if (phone.isEmpty) return false;
    final cleanPhone = normalize(phone);
    return _phoneRegex.hasMatch(cleanPhone);
  }
  
  /// Normalize phone number (remove spaces, dashes, parentheses)
  static String normalize(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  }
  
  /// Format phone for display
  static String format(String phone, {String defaultCountryCode = '+1'}) {
    final cleanPhone = normalize(phone);
    if (!cleanPhone.startsWith('+') && !cleanPhone.startsWith('00')) {
      return '$defaultCountryCode$cleanPhone';
    }
    return cleanPhone;
  }
}

/// Password validation utilities
class PasswordValidator {
  /// Minimum password length
  static const int minLength = 8;
  
  /// Maximum password length
  static const int maxLength = 128;
  
  /// Password validation result
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
  
  /// Calculate password strength (0-4)
  static int _calculateStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    return strength;
  }
  
  /// Generate secure random password
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

/// Password validation result
class PasswordValidationResult {
  final bool isValid;
  final List<String> issues;
  final int strength; // 0-5 scale
  
  const PasswordValidationResult({
    required this.isValid,
    required this.issues,
    required this.strength,
  });
  
  /// Get strength description
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
  
  /// Get strength color for UI
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

/// OTP (One-Time Password) utilities
class OtpHelper {
  /// Generate numeric OTP
  static String generateNumeric({int length = 6}) {
    final random = Random.secure();
    return List.generate(length, (index) => random.nextInt(10)).join();
  }
  
  /// Generate alphanumeric OTP
  static String generateAlphanumeric({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
  
  /// Validate OTP format
  static bool isValidFormat(String otp, {int expectedLength = 6}) {
    if (otp.length != expectedLength) return false;
    return RegExp(r'^\d+$').hasMatch(otp); // Only digits
  }
  
  /// Format OTP for display (add spaces for readability)
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

/// User helper utilities
class UserHelper {
  /// Get user display name with fallback
  static String getDisplayName(SupabaseUser user) {
    // Try full name first
    if (user.userMetadata?['full_name'] != null) {
      final fullName = user.userMetadata!['full_name'] as String;
      if (fullName.isNotEmpty) return fullName;
    }
    
    // Try first name + last name
    final firstName = user.userMetadata?['first_name'] as String?;
    final lastName = user.userMetadata?['last_name'] as String?;
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    }
    if (firstName != null) return firstName;
    
    // Fallback to email prefix
    if (user.email != null) {
      return user.email!.split('@')[0];
    }
    
    // Final fallback
    return 'User';
  }
  
  /// Get user initials for avatar
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
  
  /// Get user avatar URL with fallback
  static String? getAvatarUrl(SupabaseUser user) {
    // Try user metadata avatar
    final avatarUrl = user.userMetadata?['avatar_url'] as String?;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return avatarUrl;
    }
    
    // Try identities (OAuth providers)
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
  
  /// Check if user has specific role
  static bool hasRole(SupabaseUser user, String role) {
    final roles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    return roles.contains(role);
  }
  
  /// Check if user has any of the specified roles
  static bool hasAnyRole(SupabaseUser user, List<String> roles) {
    final userRoles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    return roles.any((role) => userRoles.contains(role));
  }
  
  /// Check if user has all specified roles
  static bool hasAllRoles(SupabaseUser user, List<String> roles) {
    final userRoles = user.userMetadata?['roles'] as List<dynamic>? ?? [];
    return roles.every((role) => userRoles.contains(role));
  }
}

/// Auth error helper utilities
class AuthErrorHelper {
  /// Get user-friendly message for auth errors
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
    
    // Default fallback
    return 'Something went wrong. Please try again.';
  }
  
  /// Check if error is retryable
  static bool isRetryableError(dynamic error) {
    final errorMessage = error.toString().toLowerCase();
    
    // Network and timeout errors are retryable
    if (errorMessage.contains('network') || 
        errorMessage.contains('timeout') ||
        errorMessage.contains('connection')) {
      return true;
    }
    
    // Rate limit errors are temporarily retryable
    if (errorMessage.contains('rate limit')) {
      return true;
    }
    
    return false;
  }
} 