import 'package:flutter/material.dart';
import '../../atoms/buttons/atomic_button.dart';
import '../../atoms/buttons/atomic_icon_button.dart';
import '../../atoms/inputs/atomic_text_field.dart';
import '../../atoms/inputs/atomic_checkbox.dart';
import '../../molecules/forms/atomic_form_field.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../utilities/atomic_debouncer.dart';

/// Atomic Login Form Organism
/// Reusable login form that can be used across projects
class AtomicLoginForm extends StatefulWidget {
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

  final Function(String email, String password) onSubmit;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isLoading;
  final bool showRememberMe;
  final bool showForgotPassword;
  final VoidCallback? onForgotPassword;
  final ValueChanged<bool>? onRememberMeChanged;
  final String submitButtonText;
  final String emailHint;
  final String passwordHint;
  final String? Function(String email, String password)? validator;
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
    
    // Custom validation
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
          // Email Field
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
          
          // Password Field
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
                icon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                variant: AtomicIconButtonVariant.ghost,
              ),
              enabled: !widget.isLoading,
              onChanged: (_) => _debouncer.debounce(() {
                if (_formError != null) setState(() => _formError = null);
              }),
            ),
          ),
          
          SizedBox(height: theme.spacing.md),
          
          // Remember Me & Forgot Password Row
          if (widget.showRememberMe || widget.showForgotPassword)
            Row(
              children: [
                if (widget.showRememberMe) ...[
                  AtomicCheckbox(
                    value: _rememberMe,
                    onChanged: widget.isLoading ? null : (value) {
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
                    onPressed: widget.isLoading ? null : widget.onForgotPassword,
                    variant: AtomicButtonVariant.ghost,
                  ),
              ],
            ),
          
          if (widget.showRememberMe || widget.showForgotPassword)
            SizedBox(height: theme.spacing.md),
          
          // Form Error
          if (_formError != null) ...[
            Container(
              padding: EdgeInsets.all(theme.spacing.sm),
              decoration: BoxDecoration(
                color: theme.colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colors.error.withValues(alpha: 0.3)),
              ),
              child: Text(
                _formError!,
                style: TextStyle(color: theme.colors.error),
              ),
            ),
            SizedBox(height: theme.spacing.md),
          ],
          
          // Submit Button
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