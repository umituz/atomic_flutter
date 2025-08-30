import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_button.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_text_field.dart';
import 'package:atomic_flutter_kit/molecules/forms/atomic_form_field.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/utilities/atomic_debouncer.dart';

class AtomicOTPForm extends StatefulWidget {
  const AtomicOTPForm({
    super.key,
    required this.onRequestOTP,
    required this.onVerifyOTP,
    this.emailController,
    this.otpController,
    this.emailFocusNode,
    this.otpFocusNode,
    this.isLoading = false,
    this.isOTPSent = false,
    this.requestButtonText = 'Send Code',
    this.verifyButtonText = 'Verify Code',
    this.resendButtonText = 'Resend Code',
    this.emailHint = 'Enter your email',
    this.otpHint = 'Enter 6-digit code',
    this.otpLength = 6,
    this.canResend = false,
    this.onResendOTP,
    this.countdownSeconds,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final Function(String email) onRequestOTP;
  final Function(String email, String otp) onVerifyOTP;
  final TextEditingController? emailController;
  final TextEditingController? otpController;
  final FocusNode? emailFocusNode;
  final FocusNode? otpFocusNode;
  final bool isLoading;
  final bool isOTPSent;
  final String requestButtonText;
  final String verifyButtonText;
  final String resendButtonText;
  final String emailHint;
  final String otpHint;
  final int otpLength;
  final bool canResend;
  final VoidCallback? onResendOTP;
  final int? countdownSeconds;
  final String? Function(String email, String? otp)? validator;
  final AutovalidateMode autovalidateMode;

  @override
  State<AtomicOTPForm> createState() => _AtomicOTPFormState();
}

class _AtomicOTPFormState extends State<AtomicOTPForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _otpController;
  final _debouncer = AtomicDebouncer(delay: const Duration(milliseconds: 300));
  
  String? _formError;

  @override
  void initState() {
    super.initState();
    _emailController = widget.emailController ?? TextEditingController();
    _otpController = widget.otpController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.emailController == null) _emailController.dispose();
    if (widget.otpController == null) _otpController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _handleRequestOTP() {
    if (!_formKey.currentState!.validate()) return;
    
    final email = _emailController.text.trim();
    
    final error = widget.validator?.call(email, null);
    if (error != null) {
      setState(() => _formError = error);
      return;
    }
    
    setState(() => _formError = null);
    widget.onRequestOTP(email);
  }

  void _handleVerifyOTP() {
    if (!_formKey.currentState!.validate()) return;
    
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    
    final error = widget.validator?.call(email, otp);
    if (error != null) {
      setState(() => _formError = error);
      return;
    }
    
    setState(() => _formError = null);
    widget.onVerifyOTP(email, otp);
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
              focusNode: widget.emailFocusNode,
              hint: widget.emailHint,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              enabled: !widget.isLoading && !widget.isOTPSent,
              borderType: AtomicTextFieldBorderType.filled,
              fillColor: theme.colors.surfaceSecondary,
              onChanged: (_) => _debouncer.debounce(() {
                if (_formError != null) setState(() => _formError = null);
              }),
            ),
          ),
          
          SizedBox(height: theme.spacing.md),
          
          if (widget.isOTPSent) ...[
            AtomicFormField<String>(
              label: 'Verification Code',
              required: true,
              validator: _validateOTP,
              child: AtomicTextField(
                controller: _otpController,
                focusNode: widget.otpFocusNode,
                hint: widget.otpHint,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.security,
                maxLength: widget.otpLength,
                enabled: !widget.isLoading,
                autofocus: true,
                borderType: AtomicTextFieldBorderType.filled,
                fillColor: theme.colors.surfaceSecondary,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.otpLength),
                ],
                onChanged: (_) => _debouncer.debounce(() {
                  if (_formError != null) setState(() => _formError = null);
                }),
              ),
            ),
            SizedBox(height: theme.spacing.md),
          ],
          
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
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: theme.spacing.md),
          ],
          
          if (widget.isOTPSent && _formError == null) ...[
            Container(
              padding: EdgeInsets.all(theme.spacing.sm),
              decoration: BoxDecoration(
                color: theme.colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colors.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'Verification code sent to ${_emailController.text}',
                    style: TextStyle(color: theme.colors.success),
                    textAlign: TextAlign.center,
                  ),
                  if (_otpController.text.isNotEmpty) ...[
                    SizedBox(height: theme.spacing.xs),
                    Text(
                      'Dev Mode: Use code ${_otpController.text}',
                      style: TextStyle(
                        color: theme.colors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: theme.spacing.md),
          ],
          
          AtomicButton(
            label: widget.isOTPSent ? widget.verifyButtonText : widget.requestButtonText,
            onPressed: widget.isLoading ? null : (widget.isOTPSent ? _handleVerifyOTP : _handleRequestOTP),
            isLoading: widget.isLoading,
            isFullWidth: true,
            variant: AtomicButtonVariant.primary,
            size: AtomicButtonSize.large,
          ),
          
          if (widget.isOTPSent && widget.canResend) ...[
            SizedBox(height: theme.spacing.sm),
            AtomicButton(
              label: widget.countdownSeconds != null && widget.countdownSeconds! > 0
                  ? '${widget.resendButtonText} (${widget.countdownSeconds}s)'
                  : widget.resendButtonText,
              onPressed: widget.isLoading || (widget.countdownSeconds != null && widget.countdownSeconds! > 0)
                  ? null 
                  : widget.onResendOTP,
              isFullWidth: true,
              variant: AtomicButtonVariant.outlined,
              size: AtomicButtonSize.medium,
            ),
          ],
          
          if (widget.isOTPSent) ...[
            SizedBox(height: theme.spacing.md),
            Text(
              'Enter the ${widget.otpLength}-digit code sent to your email address',
              style: theme.typography.bodySmall.copyWith(
                color: theme.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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

  String? _validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Verification code is required';
    }
    
    if (value.trim().length != widget.otpLength) {
      return 'Please enter ${widget.otpLength}-digit code';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'Verification code must contain only numbers';
    }
    
    return null;
  }
} 