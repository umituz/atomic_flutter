import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_button.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_icon_button.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_text_field.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_checkbox.dart';
import 'package:atomic_flutter_kit/molecules/forms/atomic_form_field.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/utilities/atomic_debouncer.dart';

/// A customizable login form component.
///
/// The [AtomicLoginForm] provides a ready-to-use UI for user authentication,
/// including email and password input fields, "Remember Me" checkbox,
/// "Forgot Password" link, and a submit button. It integrates with form
/// validation and handles loading states.
///
/// Features:
/// - Email and password input fields with built-in validation.
/// - Optional "Remember Me" checkbox with state management.
/// - Optional "Forgot Password" link with a customizable callback.
/// - Customizable submit button text.
/// - Loading state for the submit button.
/// - Customizable hint texts for email and password fields.
/// - Integrates with [AtomicFormField] for consistent error display.
/// - Supports custom validation logic for the entire form.
///
/// Example usage:
/// ```dart
/// AtomicLoginForm(
///   onSubmit: (email, password) async {
///     print('Submitting login for: $email with password: $password');
///     // Simulate API call
///     await Future.delayed(const Duration(seconds: 2));
///     if (email == 'test@example.com' && password == 'password') {
///       print('Login successful!');
///       // Navigate to home screen
///     } else {
///       print('Login failed!');
///       // Show error message
///     }
///   },
///   showRememberMe: true,
///   showForgotPassword: true,
///   onForgotPassword: () {
///     print('Forgot password clicked!');
///     // Navigate to forgot password screen
///   },
///   submitButtonText: 'Log In',
///   emailHint: 'Your email address',
///   passwordHint: 'Your secret password',
/// )
/// ```
class AtomicLoginForm extends StatefulWidget {
  /// Creates an [AtomicLoginForm] widget.
  ///
  /// [onSubmit] is the callback function executed when the form is submitted.
  /// [emailController] is an optional controller for the email text field.
  /// [passwordController] is an optional controller for the password text field.
  /// [isLoading] if true, the submit button shows a loading indicator and is disabled. Defaults to false.
  /// [showRememberMe] if true, displays a "Remember Me" checkbox. Defaults to true.
  /// [showForgotPassword] if true, displays a "Forgot Password" link. Defaults to true.
  /// [onForgotPassword] is the callback function executed when "Forgot Password" is tapped.
  /// [onRememberMeChanged] is the callback function executed when the "Remember Me" checkbox changes.
  /// [submitButtonText] is the text displayed on the submit button. Defaults to 'Sign In'.
  /// [emailHint] is the hint text for the email input field. Defaults to 'Enter your email'.
  /// [passwordHint] is the hint text for the password input field. Defaults to 'Enter your password'.
  /// [validator] is a function that validates the entire form (email and password).
  /// [autovalidateMode] specifies when to auto-validate the form. Defaults to [AutovalidateMode.disabled].
  const AtomicLoginForm({
    super.key,
    required this.onSubmit,
    this.emailController,
    this.passwordController,
    this.isLoading = false,
    this.showRememberMe = true,
    this.showForgotPassword = true,
    this.onForgotPassword,
    this.onRememberMeChanged,
    this.submitButtonText = 'Sign In',
    this.emailHint = 'Enter your email',
    this.passwordHint = 'Enter your password',
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  /// The callback function executed when the form is submitted.
  final Function(String email, String password) onSubmit;

  /// An optional controller for the email text field.
  final TextEditingController? emailController;

  /// An optional controller for the password text field.
  final TextEditingController? passwordController;

  /// If true, the submit button shows a loading indicator and is disabled. Defaults to false.
  final bool isLoading;

  /// If true, displays a "Remember Me" checkbox. Defaults to true.
  final bool showRememberMe;

  /// If true, displays a "Forgot Password" link. Defaults to true.
  final bool showForgotPassword;

  /// The callback function executed when "Forgot Password" is tapped.
  final VoidCallback? onForgotPassword;

  /// The callback function executed when the "Remember Me" checkbox changes.
  final ValueChanged<bool>? onRememberMeChanged;

  /// The text displayed on the submit button. Defaults to 'Sign In'.
  final String submitButtonText;

  /// The hint text for the email input field. Defaults to 'Enter your email'.
  final String emailHint;

  /// The hint text for the password input field. Defaults to 'Enter your password'.
  final String passwordHint;

  /// A function that validates the entire form (email and password).
  final String? Function(String email, String password)? validator;

  /// Specifies when to auto-validate the form. Defaults to [AutovalidateMode.disabled].
  final AutovalidateMode autovalidateMode;

  @override
  State<AtomicLoginForm> createState() => _AtomicLoginFormState();
}

class _AtomicLoginFormState extends State<AtomicLoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _debouncer = AtomicDebouncer(delay: const Duration(milliseconds: 300));

  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _emailController = widget.emailController ?? TextEditingController();
    _passwordController = widget.passwordController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.emailController == null) _emailController.dispose();
    if (widget.passwordController == null) _passwordController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final error = widget.validator?.call(email, password);
    if (error != null) {
      setState(() => _formError = error);
      return;
    }

    setState(() => _formError = null);
    widget.onSubmit(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AtomicFormField<String>(
            label: 'Email',
            required: true,
            validator: _validateEmail,
            child: AtomicTextField(
              controller: _emailController,
              hint: widget.emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              enabled: !widget.isLoading,
              onChanged: (_) => _debouncer.debounce(() {
                if (_formError != null) setState(() => _formError = null);
              }),
            ),
          ),
          SizedBox(height: theme.spacing.md),
          AtomicFormField<String>(
            label: 'Password',
            required: true,
            validator: _validatePassword,
            child: AtomicTextField(
              controller: _passwordController,
              hint: widget.passwordHint,
              obscureText: _obscurePassword,
              prefixIcon: Icons.lock_outlined,
              suffixIcon: AtomicIconButton(
                icon:
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                variant: AtomicIconButtonVariant.ghost,
              ),
              enabled: !widget.isLoading,
              onChanged: (_) => _debouncer.debounce(() {
                if (_formError != null) setState(() => _formError = null);
              }),
            ),
          ),
          SizedBox(height: theme.spacing.md),
          if (widget.showRememberMe || widget.showForgotPassword)
            Row(
              children: [
                if (widget.showRememberMe) ...[
                  AtomicCheckbox(
                    value: _rememberMe,
                    onChanged: widget.isLoading
                        ? null
                        : (value) {
                            setState(() => _rememberMe = value ?? false);
                            widget.onRememberMeChanged?.call(_rememberMe);
                          },
                  ),
                  const Text('Remember me'),
                ],
                const Spacer(),
                if (widget.showForgotPassword)
                  AtomicButton(
                    label: 'Forgot Password?',
                    onPressed:
                        widget.isLoading ? null : widget.onForgotPassword,
                    variant: AtomicButtonVariant.ghost,
                  ),
              ],
            ),
          if (widget.showRememberMe || widget.showForgotPassword)
            SizedBox(height: theme.spacing.md),
          if (_formError != null) ...[
            Container(
              padding: EdgeInsets.all(theme.spacing.sm),
              decoration: BoxDecoration(
                color: theme.colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: theme.colors.error.withValues(alpha: 0.3)),
              ),
              child: Text(
                _formError!,
                style: TextStyle(color: theme.colors.error),
              ),
            ),
            SizedBox(height: theme.spacing.md),
          ],
          AtomicButton(
            label: widget.submitButtonText,
            onPressed: widget.isLoading ? null : _handleSubmit,
            isLoading: widget.isLoading,
            isFullWidth: true,
            variant: AtomicButtonVariant.primary,
            size: AtomicButtonSize.large,
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }
}
