import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_button.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_text_field.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_checkbox.dart';
import 'package:atomic_flutter_kit/molecules/forms/atomic_form_field.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/utilities/atomic_debouncer.dart';

/// A customizable registration form component.
///
/// The [AtomicRegisterForm] provides a ready-to-use UI for user registration,
/// including name, email, password, and password confirmation input fields,
/// optional terms acceptance checkbox, and a submit button.
///
/// Features:
/// - Name, email, password, and password confirmation input fields with built-in validation.
/// - Optional terms and conditions checkbox with state management.
/// - Customizable submit button text.
/// - Loading state for the submit button.
/// - Customizable hint texts for all input fields.
/// - Integrates with [AtomicFormField] for consistent error display.
/// - Supports custom validation logic for the entire form.
///
/// Example usage:
/// ```dart
/// AtomicRegisterForm(
///   onSubmit: (name, email, password, passwordConfirmation) async {
///     print('Registering: $name, $email');
///     // Simulate API call
///     await Future.delayed(const Duration(seconds: 2));
///   },
///   showTermsAcceptance: true,
///   onTermsPressed: () {
///     // Navigate to terms screen
///   },
///   submitButtonText: 'Sign Up',
/// )
/// ```
class AtomicRegisterForm extends StatefulWidget {
  /// Creates an [AtomicRegisterForm] widget.
  ///
  /// [onSubmit] is the callback function executed when the form is submitted.
  const AtomicRegisterForm({
    super.key,
    required this.onSubmit,
    this.showTermsAcceptance = true,
    this.onTermsPressed,
    this.submitButtonText = 'Sign Up',
    this.nameHint = 'Full Name',
    this.emailHint = 'Email Address',
    this.passwordHint = 'Password',
    this.passwordConfirmationHint = 'Confirm Password',
    this.termsText = 'I accept the Terms and Conditions',
    this.enableValidation = true,
  });

  /// Callback function executed when the form is submitted.
  /// 
  /// Receives name, email, password, and password confirmation as parameters.
  final Function(String name, String email, String password, String passwordConfirmation) onSubmit;

  /// Whether to show the terms acceptance checkbox. Defaults to true.
  final bool showTermsAcceptance;

  /// Callback function executed when the terms text is pressed.
  final VoidCallback? onTermsPressed;

  /// The text to display on the submit button. Defaults to 'Sign Up'.
  final String submitButtonText;

  /// The hint text for the name field. Defaults to 'Full Name'.
  final String nameHint;

  /// The hint text for the email field. Defaults to 'Email Address'.
  final String emailHint;

  /// The hint text for the password field. Defaults to 'Password'.
  final String passwordHint;

  /// The hint text for the password confirmation field. Defaults to 'Confirm Password'.
  final String passwordConfirmationHint;

  /// The text for the terms acceptance checkbox. Defaults to 'I accept the Terms and Conditions'.
  final String termsText;

  /// Whether to enable form validation. Defaults to true.
  final bool enableValidation;

  @override
  State<AtomicRegisterForm> createState() => _AtomicRegisterFormState();
}

class _AtomicRegisterFormState extends State<AtomicRegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _debouncer = AtomicDebouncer(delay: const Duration(milliseconds: 300));

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _isLoading = false;
  bool _termsAccepted = false;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.showTermsAcceptance && !_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions to continue.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final passwordConfirmation = _passwordConfirmationController.text;

      await widget.onSubmit(name, email, password, passwordConfirmation);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateName(String? value) {
    if (!widget.enableValidation) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (!widget.enableValidation) return null;
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (!widget.enableValidation) return null;
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (!widget.enableValidation) return null;
    if (value == null || value.isEmpty) {
      return 'Password confirmation is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          AtomicFormField(
            child: AtomicTextField(
              controller: _nameController,
              hint: widget.nameHint,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: _validateName,
              prefixIcon: Icons.person_outline,
            ),
          ),
          SizedBox(height: theme.spacing.md),

          // Email Field  
          AtomicFormField(
            child: AtomicTextField(
              controller: _emailController,
              hint: widget.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
              prefixIcon: Icons.email_outlined,
            ),
          ),
          SizedBox(height: theme.spacing.md),

          // Password Field
          AtomicFormField(
            child: AtomicTextField(
              controller: _passwordController,
              hint: widget.passwordHint,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              validator: _validatePassword,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.md),

          // Password Confirmation Field
          AtomicFormField(
            child: AtomicTextField(
              controller: _passwordConfirmationController,
              hint: widget.passwordConfirmationHint,
              obscureText: _obscurePasswordConfirmation,
              textInputAction: TextInputAction.done,
              validator: _validatePasswordConfirmation,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscurePasswordConfirmation = !_obscurePasswordConfirmation),
                icon: Icon(_obscurePasswordConfirmation ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),

          // Terms Acceptance
          if (widget.showTermsAcceptance) ...[
            SizedBox(height: theme.spacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AtomicCheckbox(
                  value: _termsAccepted,
                  onChanged: (value) => setState(() => _termsAccepted = value ?? false),
                ),
                SizedBox(width: theme.spacing.sm),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onTermsPressed,
                    child: Text(
                      widget.termsText,
                      style: theme.typography.bodyMedium.copyWith(
                        color: widget.onTermsPressed != null 
                          ? theme.colors.primary 
                          : theme.colors.textSecondary,
                        decoration: widget.onTermsPressed != null 
                          ? TextDecoration.underline 
                          : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: theme.spacing.lg),

          // Submit Button
          AtomicButton(
            label: widget.submitButtonText,
            onPressed: _isLoading ? null : _handleSubmit,
            variant: AtomicButtonVariant.primary,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}