import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_button.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_text_field.dart';
import 'package:atomic_flutter_kit/molecules/forms/atomic_form_field.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/utilities/atomic_debouncer.dart';

/// A customizable One-Time Password (OTP) form component.
///
/// The [AtomicOTPForm] provides a UI for requesting and verifying OTPs,
/// typically used for two-factor authentication or passwordless login.s
/// It handles email input, OTP input, and manages the flow between requesting
/// and verifying the code.
///
/// Features:
/// - Email input field for requesting OTP.
/// - OTP input field with customizable length and numeric-only input.
/// - Loading states for request and verify buttons.
/// - Customizable button texts.
/// - Optional resend OTP functionality with countdown.
/// - Integrates with form validation and error display.
///
/// Example usage:
/// ```dart
/// bool _isLoading = false;
/// bool _isOTPSent = false;
/// int _countdown = 60;
/// Timer? _timer;
///
/// void _startCountdown() {
///   _countdown = 60;
///   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
///     if (_countdown == 0) {
///       timer.cancel();
///       setState(() {}); // Rebuild to enable resend button
///     } else {
///       setState(() {
///         _countdown--;
///       });
///     }
///   });
/// }
///
/// AtomicOTPForm(
///   onRequestOTP: (email) async {
///     setState(() { _isLoading = true; });
///     print('Requesting OTP for: $email');
///     await Future.delayed(const Duration(seconds: 2)); // Simulate API call
///     setState(() {
///       _isLoading = false;
///       _isOTPSent = true;
///     });
///     _startCountdown();
///   },
///   onVerifyOTP: (email, otp) async {
///     setState(() { _isLoading = true; });
///     print('Verifying OTP: $otp for $email');
///     await Future.delayed(const Duration(seconds: 2)); // Simulate API call
///     setState(() { _isLoading = false; });
///     if (otp == '123456') { // Simple mock verification
///       print('OTP Verified!');
///     } else {
///       print('Invalid OTP!');
///     }
///   },
///   isLoading: _isLoading,
///   isOTPSent: _isOTPSent,
///   canResend: _countdown == 0,
///   countdownSeconds: _countdown,
///   onResendOTP: () {
///     print('Resending OTP...');
///     _startCountdown();
///   },
///   emailHint: 'your.email@example.com',
///   otpHint: 'Enter 6-digit code',
///   otpLength: 6,
/// )
/// ```
class AtomicOTPForm extends StatefulWidget {
  /// Creates an [AtomicOTPForm] widget.
  ///
  /// [onRequestOTP] is the callback function executed when the user requests an OTP.
  /// [onVerifyOTP] is the callback function executed when the user attempts to verify the OTP.
  /// [emailController] is an optional controller for the email text field.
  /// [otpController] is an optional controller for the OTP text field.
  /// [emailFocusNode] is an optional focus node for the email text field.
  /// [otpFocusNode] is an optional focus node for the OTP text field.
  /// [isLoading] if true, shows a loading indicator and disables buttons. Defaults to false.
  /// [isOTPSent] if true, the OTP input field and verify button are shown. Defaults to false.
  /// [requestButtonText] is the text for the button to request OTP. Defaults to 'Send Code'.
  /// [verifyButtonText] is the text for the button to verify OTP. Defaults to 'Verify Code'.
  /// [resendButtonText] is the text for the resend OTP button. Defaults to 'Resend Code'.
  /// [emailHint] is the hint text for the email input field. Defaults to 'Enter your email'.
  /// [otpHint] is the hint text for the OTP input field. Defaults to 'Enter 6-digit code'.
  /// [otpLength] is the expected length of the OTP. Defaults to 6.
  /// [canResend] if true, enables the resend OTP button.
  /// [onResendOTP] is the callback function executed when the resend OTP button is pressed.
  /// [countdownSeconds] is the number of seconds remaining before OTP can be resent.
  /// [validator] is a function that validates the email and/or OTP.
  /// [autovalidateMode] specifies when to auto-validate the form. Defaults to [AutovalidateMode.disabled].
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

  /// The callback function executed when the user requests an OTP.
  final Function(String email) onRequestOTP;

  /// The callback function executed when the user attempts to verify the OTP.
  final Function(String email, String otp) onVerifyOTP;

  /// An optional controller for the email text field.
  final TextEditingController? emailController;

  /// An optional controller for the OTP text field.
  final TextEditingController? otpController;

  /// An optional focus node for the email text field.
  final FocusNode? emailFocusNode;

  /// An optional focus node for the OTP text field.
  final FocusNode? otpFocusNode;

  /// If true, shows a loading indicator and disables buttons. Defaults to false.
  final bool isLoading;

  /// If true, the OTP input field and verify button are shown. Defaults to false.
  final bool isOTPSent;

  /// The text for the button to request OTP. Defaults to 'Send Code'.
  final String requestButtonText;

  /// The text for the button to verify OTP. Defaults to 'Verify Code'.
  final String verifyButtonText;

  /// The text for the resend OTP button. Defaults to 'Resend Code'.
  final String resendButtonText;

  /// The hint text for the email input field. Defaults to 'Enter your email'.
  final String emailHint;

  /// The hint text for the OTP input field. Defaults to 'Enter 6-digit code'.
  final String otpHint;

  /// The expected length of the OTP. Defaults to 6.
  final int otpLength;

  /// If true, enables the resend OTP button.
  final bool canResend;

  /// The callback function executed when the resend OTP button is pressed.
  final VoidCallback? onResendOTP;

  /// The number of seconds remaining before OTP can be resent.
  final int? countdownSeconds;

  /// A function that validates the email and/or OTP.
  final String? Function(String email, String? otp)? validator;

  /// Specifies when to auto-validate the form. Defaults to [AutovalidateMode.disabled].
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
                border: Border.all(
                    color: theme.colors.error.withValues(alpha: 0.3)),
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
                border: Border.all(
                    color: theme.colors.success.withValues(alpha: 0.3)),
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
            label: widget.isOTPSent
                ? widget.verifyButtonText
                : widget.requestButtonText,
            onPressed: widget.isLoading
                ? null
                : (widget.isOTPSent ? _handleVerifyOTP : _handleRequestOTP),
            isLoading: widget.isLoading,
            isFullWidth: true,
            variant: AtomicButtonVariant.primary,
            size: AtomicButtonSize.large,
          ),
          if (widget.isOTPSent && widget.canResend) ...[
            SizedBox(height: theme.spacing.sm),
            AtomicButton(
              label: widget.countdownSeconds != null &&
                      widget.countdownSeconds! > 0
                  ? '${widget.resendButtonText} (${widget.countdownSeconds}s)'
                  : widget.resendButtonText,
              onPressed: widget.isLoading ||
                      (widget.countdownSeconds != null &&
                          widget.countdownSeconds! > 0)
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
