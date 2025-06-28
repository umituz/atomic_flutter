import 'package:flutter/material.dart';
import 'atomic_auth_template.dart';

/// Atomic Auth Template Helper
/// Provides pre-configured auth templates for common use cases
class AtomicAuthTemplateHelper {
  
  /// Login template with standard configuration
  static Widget login({
    required Widget form,
    String? title,
    String? subtitle,
    Widget? headerWidget,
    Widget? footerWidget,
    Gradient? backgroundGradient,
    Widget? logoWidget,
    double maxWidth = 400,
    EdgeInsetsGeometry? padding,
  }) {
    return AtomicAuthTemplate(
      title: title ?? 'Welcome Back',
      subtitle: subtitle ?? 'Sign in to your account',
      headerWidget: headerWidget,
      footerWidget: footerWidget,
      backgroundGradient: backgroundGradient ?? const LinearGradient(
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      logoWidget: logoWidget ?? const Icon(
        Icons.person,
        size: 48,
        color: Colors.white,
      ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Register template with standard configuration
  static Widget register({
    required Widget form,
    String? title,
    String? subtitle,
    Widget? headerWidget,
    Widget? footerWidget,
    Gradient? backgroundGradient,
    Widget? logoWidget,
    double maxWidth = 450,
    EdgeInsetsGeometry? padding,
  }) {
    return AtomicAuthTemplate(
      title: title ?? 'Create Account',
      subtitle: subtitle ?? 'Join us today',
      headerWidget: headerWidget,
      footerWidget: footerWidget,
      backgroundGradient: backgroundGradient ?? const LinearGradient(
        colors: [
          Color(0xFF11998e),
          Color(0xFF38ef7d),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      logoWidget: logoWidget ?? const Icon(
        Icons.person_add,
        size: 48,
        color: Colors.white,
      ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Forgot password template with standard configuration
  static Widget forgotPassword({
    required Widget form,
    String? title,
    String? subtitle,
    Widget? headerWidget,
    Widget? footerWidget,
    Gradient? backgroundGradient,
    Widget? logoWidget,
    double maxWidth = 400,
    EdgeInsetsGeometry? padding,
  }) {
    return AtomicAuthTemplate(
      title: title ?? 'Reset Password',
      subtitle: subtitle ?? 'Enter your email to reset password',
      headerWidget: headerWidget,
      footerWidget: footerWidget,
      backgroundGradient: backgroundGradient ?? const LinearGradient(
        colors: [
          Color(0xFFe65c00),
          Color(0xFFf9d423),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      logoWidget: logoWidget ?? const Icon(
        Icons.lock_reset,
        size: 48,
        color: Colors.white,
      ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// OTP verification template with standard configuration
  static Widget otpVerification({
    required Widget form,
    String? title,
    String? subtitle,
    Widget? headerWidget,
    Widget? footerWidget,
    Gradient? backgroundGradient,
    Widget? logoWidget,
    double maxWidth = 400,
    EdgeInsetsGeometry? padding,
  }) {
    return AtomicAuthTemplate(
      title: title ?? 'Verify Code',
      subtitle: subtitle ?? 'Enter the code sent to your email',
      headerWidget: headerWidget,
      footerWidget: footerWidget,
      backgroundGradient: backgroundGradient ?? const LinearGradient(
        colors: [
          Color(0xFF434343),
          Color(0xFF000000),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      logoWidget: logoWidget ?? const Icon(
        Icons.verified_user,
        size: 48,
        color: Colors.white,
      ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Profile setup template with standard configuration
  static Widget profileSetup({
    required Widget form,
    String? title,
    String? subtitle,
    Widget? headerWidget,
    Widget? footerWidget,
    Gradient? backgroundGradient,
    Widget? logoWidget,
    double maxWidth = 500,
    EdgeInsetsGeometry? padding,
  }) {
    return AtomicAuthTemplate(
      title: title ?? 'Complete Profile',
      subtitle: subtitle ?? 'Tell us more about yourself',
      headerWidget: headerWidget,
      footerWidget: footerWidget,
      backgroundGradient: backgroundGradient ?? const LinearGradient(
        colors: [
          Color(0xFF8360c3),
          Color(0xFF2ebf91),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      logoWidget: logoWidget ?? const Icon(
        Icons.account_circle,
        size: 48,
        color: Colors.white,
      ),
      maxWidth: maxWidth,
      padding: padding,
      scrollable: true, // Profile forms are usually longer
      child: form,
    );
  }

  /// OTP authentication template with standard configuration
  static Widget otpAuth({
    required Widget form,
    String? title,
    String? subtitle,
    Widget? headerWidget,
    Widget? footerWidget,
    Gradient? backgroundGradient,
    Widget? logoWidget,
    double maxWidth = 400,
    EdgeInsetsGeometry? padding,
  }) {
    return AtomicAuthTemplate(
      title: title ?? 'Secure Access',
      subtitle: subtitle ?? 'Enter your email to receive verification code',
      headerWidget: headerWidget,
      footerWidget: footerWidget,
      backgroundGradient: backgroundGradient ?? const LinearGradient(
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      logoWidget: logoWidget ?? const Icon(
        Icons.security,
        size: 48,
        color: Colors.white,
      ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }
} 