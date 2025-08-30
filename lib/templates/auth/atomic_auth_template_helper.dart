import 'package:flutter/material.dart';
import 'atomic_auth_template.dart';

/// A utility class providing helper methods to easily create various authentication templates.
///
/// The [AtomicAuthTemplateHelper] simplifies the setup of common authentication
/// flows (login, registration, OTP verification, etc.) by pre-configuring
/// the [AtomicAuthTemplate] with appropriate titles, subtitles, default
/// background gradients, and icons.
///
/// Each static method returns an [AtomicAuthTemplate] widget, ready to be
/// integrated into your application's navigation.
///
/// Example usage:
/// ```dart
/// // In your login route:
/// class LoginRoute extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return AtomicAuthTemplateHelper.login(
///       form: AtomicLoginForm(
///         onSubmit: (email, password) {
///           // Handle login logic
///         },
///       ),
///       title: 'Welcome Back!',
///       subtitle: 'Please sign in to continue.',
///     );
///   }
/// }
/// ```
class AtomicAuthTemplateHelper {
  /// Creates an authentication template for a login screen.
  ///
  /// [form] is the login form widget (e.g., [AtomicLoginForm]).
  /// [title] is the main title for the screen. Defaults to 'Welcome Back'.
  /// [subtitle] is the subtitle for the screen. Defaults to 'Sign in to your account'.
  /// [headerWidget] is an optional custom widget to display in the header.
  /// [footerWidget] is an optional custom widget to display in the footer.
  /// [backgroundGradient] is the background gradient for the screen.
  /// [logoWidget] is an optional custom logo widget.
  /// [maxWidth] specifies the maximum width of the content area. Defaults to 400.
  /// [padding] is the internal padding for the content area.
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
      backgroundGradient: backgroundGradient ??
          const LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      logoWidget: logoWidget ??
          const Icon(
            Icons.person,
            size: 48,
            color: Colors.white,
          ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Creates an authentication template for a registration screen.
  ///
  /// [form] is the registration form widget.
  /// [title] is the main title for the screen. Defaults to 'Create Account'.
  /// [subtitle] is the subtitle for the screen. Defaults to 'Join us today'.
  /// [headerWidget] is an optional custom widget to display in the header.
  /// [footerWidget] is an optional custom widget to display in the footer.
  /// [backgroundGradient] is the background gradient for the screen.
  /// [logoWidget] is an optional custom logo widget.
  /// [maxWidth] specifies the maximum width of the content area. Defaults to 450.
  /// [padding] is the internal padding for the content area.
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
      backgroundGradient: backgroundGradient ??
          const LinearGradient(
            colors: [
              Color(0xFF11998e),
              Color(0xFF38ef7d),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      logoWidget: logoWidget ??
          const Icon(
            Icons.person_add,
            size: 48,
            color: Colors.white,
          ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Creates an authentication template for a forgot password screen.
  ///
  /// [form] is the forgot password form widget.
  /// [title] is the main title for the screen. Defaults to 'Reset Password'.
  /// [subtitle] is the subtitle for the screen. Defaults to 'Enter your email to reset password'.
  /// [headerWidget] is an optional custom widget to display in the header.
  /// [footerWidget] is an optional custom widget to display in the footer.
  /// [backgroundGradient] is the background gradient for the screen.
  /// [logoWidget] is an optional custom logo widget.
  /// [maxWidth] specifies the maximum width of the content area. Defaults to 400.
  /// [padding] is the internal padding for the content area.
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
      backgroundGradient: backgroundGradient ??
          const LinearGradient(
            colors: [
              Color(0xFFe65c00),
              Color(0xFFf9d423),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      logoWidget: logoWidget ??
          const Icon(
            Icons.lock_reset,
            size: 48,
            color: Colors.white,
          ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Creates an authentication template for an OTP verification screen.
  ///
  /// [form] is the OTP verification form widget.
  /// [title] is the main title for the screen. Defaults to 'Verify Code'.
  /// [subtitle] is the subtitle for the screen. Defaults to 'Enter the code sent to your email'.
  /// [headerWidget] is an optional custom widget to display in the header.
  /// [footerWidget] is an optional custom widget to display in the footer.
  /// [backgroundGradient] is the background gradient for the screen.
  /// [logoWidget] is an optional custom logo widget.
  /// [maxWidth] specifies the maximum width of the content area. Defaults to 400.
  /// [padding] is the internal padding for the content area.
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
      backgroundGradient: backgroundGradient ??
          const LinearGradient(
            colors: [
              Color(0xFF434343),
              Color(0xFF000000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      logoWidget: logoWidget ??
          const Icon(
            Icons.verified_user,
            size: 48,
            color: Colors.white,
          ),
      maxWidth: maxWidth,
      padding: padding,
      child: form,
    );
  }

  /// Creates an authentication template for a profile setup screen.
  ///
  /// [form] is the profile setup form widget.
  /// [title] is the main title for the screen. Defaults to 'Complete Profile'.
  /// [subtitle] is the subtitle for the screen. Defaults to 'Tell us more about yourself'.
  /// [headerWidget] is an optional custom widget to display in the header.
  /// [footerWidget] is an optional custom widget to display in the footer.
  /// [backgroundGradient] is the background gradient for the screen.
  /// [logoWidget] is an optional custom logo widget.
  /// [maxWidth] specifies the maximum width of the content area. Defaults to 500.
  /// [padding] is the internal padding for the content area.
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
      backgroundGradient: backgroundGradient ??
          const LinearGradient(
            colors: [
              Color(0xFF8360c3),
              Color(0xFF2ebf91),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      logoWidget: logoWidget ??
          const Icon(
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

  /// Creates an authentication template for an OTP authentication screen.
  ///
  /// [form] is the OTP authentication form widget.
  /// [title] is the main title for the screen. Defaults to 'Secure Access'.
  /// [subtitle] is the subtitle for the screen. Defaults to 'Enter your email to receive verification code'.
  /// [headerWidget] is an optional custom widget to display in the header.
  /// [footerWidget] is an optional custom widget to display in the footer.
  /// [backgroundGradient] is the background gradient for the screen.
  /// [logoWidget] is an optional custom logo widget.
  /// [maxWidth] specifies the maximum width of the content area. Defaults to 400.
  /// [padding] is the internal padding for the content area.
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
      backgroundGradient: backgroundGradient ??
          const LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      logoWidget: logoWidget ??
          const Icon(
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
