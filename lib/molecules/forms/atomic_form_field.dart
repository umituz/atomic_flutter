import 'package:flutter/material.dart';
import '../../atoms/display/atomic_text.dart';
import '../../atoms/inputs/atomic_text_field.dart';
import '../../molecules/inputs/atomic_dropdown.dart';

/// Atomic Form Field Component
/// Wrapper for form inputs with validation support
class AtomicFormField<T> extends StatefulWidget {
  const AtomicFormField({
    super.key,
    required this.child,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.initialValue,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.label,
    this.helperText,
    this.required = false,
    this.margin,
  });

  final Widget child;
  final String? Function(T?)? validator;
  final void Function(T?)? onSaved;
  final void Function(T?)? onChanged;
  final T? initialValue;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final String? label;
  final String? helperText;
  final bool required;
  final EdgeInsetsGeometry? margin;

  @override
  State<AtomicFormField<T>> createState() => _AtomicFormFieldState<T>();
}

class _AtomicFormFieldState<T> extends State<AtomicFormField<T>> {
  String? _errorText;
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onChanged(T? value) {
    setState(() {
      _value = value;
      _errorText = widget.validator?.call(value);
    });
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Row(
              children: [
                AtomicText(
                  widget.label!,
                  atomicStyle: AtomicTextStyle.labelLarge,
                ),
                if (widget.required)
                  const AtomicText(
                    ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          _buildChildWithErrorState(),
          if (widget.helperText != null && _errorText == null) ...[
            const SizedBox(height: 4),
            AtomicText(
              widget.helperText!,
              atomicStyle: AtomicTextStyle.labelSmall,
            ),
          ],
          if (_errorText != null) ...[
            const SizedBox(height: 4),
            AtomicText(
              _errorText!,
              style: const TextStyle(color: Colors.red),
              atomicStyle: AtomicTextStyle.labelSmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChildWithErrorState() {
    // If child is AtomicTextField, pass error state
    if (widget.child is AtomicTextField) {
      final textField = widget.child as AtomicTextField;
      return AtomicTextField(
        controller: textField.controller,
        onChanged: (value) {
          _onChanged(value as T?);
          textField.onChanged?.call(value);
        },
        label: null, // We handle label at form field level
        hint: textField.hint,
        helperText: null, // We handle helper text at form field level
        errorText: _errorText,
        prefixIcon: textField.prefixIcon,
        suffixIcon: textField.suffixIcon,
        onSubmitted: textField.onSubmitted,
        onTap: textField.onTap,
        keyboardType: textField.keyboardType,
        textInputAction: textField.textInputAction,
        obscureText: textField.obscureText,
        enabled: widget.enabled && textField.enabled,
        readOnly: textField.readOnly,
        autofocus: textField.autofocus,
        maxLines: textField.maxLines,
        minLines: textField.minLines,
        maxLength: textField.maxLength,
        inputFormatters: textField.inputFormatters,
        focusNode: textField.focusNode,
        fillColor: textField.fillColor,
        borderType: textField.borderType,
        validator: null, // We handle validation at form field level
      );
    }
    
    // If child is AtomicDropdown, pass error state
    if (widget.child is AtomicDropdown) {
      final dropdown = widget.child as AtomicDropdown;
      return AtomicDropdown(
        items: dropdown.items,
        value: dropdown.value,
        onChanged: (value) {
          _onChanged(value as T?);
          dropdown.onChanged?.call(value);
        },
        hint: dropdown.hint,
        label: null, // We handle label at form field level
        helperText: null, // We handle helper text at form field level
        errorText: _errorText,
        enabled: widget.enabled && dropdown.enabled,
        dense: dropdown.dense,
        isExpanded: dropdown.isExpanded,
        icon: dropdown.icon,
        iconSize: dropdown.iconSize,
        isDense: dropdown.isDense,
        menuMaxHeight: dropdown.menuMaxHeight,
        enableFilter: dropdown.enableFilter,
        filterHint: dropdown.filterHint,
        itemBuilder: dropdown.itemBuilder,
        selectedItemBuilder: dropdown.selectedItemBuilder,
        dropdownDecoration: dropdown.dropdownDecoration,
        alignment: dropdown.alignment,
        margin: null, // We handle margin at form field level
      );
    }
    
    // For other widgets, just return as-is
    return widget.child;
  }
}

/// Atomic Form Component
/// Container for form fields with validation support
class AtomicForm extends StatefulWidget {
  const AtomicForm({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final Widget child;
  final VoidCallback? onChanged;
  final AutovalidateMode autovalidateMode;

  @override
  State<AtomicForm> createState() => _AtomicFormState();

  /// Get the form state
  static AtomicFormState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AtomicFormState>();
  }
}

class _AtomicFormState extends State<AtomicForm> implements AtomicFormState {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void save() {
    _formKey.currentState?.save();
  }

  @override
  void reset() {
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      child: widget.child,
    );
  }
}

/// Form state interface
abstract class AtomicFormState {
  bool validate();
  void save();
  void reset();
}

/// Form validators
class AtomicValidators {
  AtomicValidators._();

  /// Required field validator
  static String? required(String? value, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  /// Email validator
  static String? email(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return message ?? 'Please enter a valid email address';
    }
    return null;
  }

  /// Password validator
  static String? password(String? value, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = false,
    String? message,
  }) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < minLength) {
      return message ?? 'Password must be at least $minLength characters';
    }
    
    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return message ?? 'Password must contain at least one uppercase letter';
    }
    
    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return message ?? 'Password must contain at least one lowercase letter';
    }
    
    if (requireNumbers && !value.contains(RegExp(r'[0-9]'))) {
      return message ?? 'Password must contain at least one number';
    }
    
    if (requireSpecialChars && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return message ?? 'Password must contain at least one special character';
    }
    
    return null;
  }

  /// Phone number validator
  static String? phone(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  }

  /// Minimum length validator
  static String? minLength(String? value, int minLength, [String? message]) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < minLength) {
      return message ?? 'Must be at least $minLength characters';
    }
    return null;
  }

  /// Maximum length validator
  static String? maxLength(String? value, int maxLength, [String? message]) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length > maxLength) {
      return message ?? 'Must be no more than $maxLength characters';
    }
    return null;
  }

  /// Numeric validator
  static String? numeric(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    
    if (double.tryParse(value) == null) {
      return message ?? 'Please enter a valid number';
    }
    return null;
  }

  /// URL validator
  static String? url(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    
    try {
      Uri.parse(value);
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return message ?? 'Please enter a valid URL (http:// or https://)';
      }
    } catch (e) {
      return message ?? 'Please enter a valid URL';
    }
    return null;
  }

  /// Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
} 