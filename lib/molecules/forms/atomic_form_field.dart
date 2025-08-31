import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/inputs/atomic_text_field.dart';
import 'package:atomic_flutter_kit/molecules/inputs/atomic_dropdown.dart';

/// A wrapper for form input widgets that provides consistent labeling, helper text, and error display.
///
/// The [AtomicFormField] simplifies the integration of various input widgets
/// (like [AtomicTextField] or [AtomicDropdown]) into a form by handling common
/// UI elements such as labels, required indicators, helper texts, and error messages.
/// It also integrates with Flutter's [Form] widget for validation and saving.
///
/// Features:
/// - Consistent display of labels and optional required indicators.
/// - Displays helper text when no error is present.
/// - Shows error messages dynamically based on validation.
/// - Integrates with [Form] for validation, saving, and auto-validation.
/// - Supports generic type [T] for the field's value.
/// - Customizable margin.
///
/// Example usage:
/// ```dart
/// GlobalKey<FormState> _formKey = GlobalKey<FormState>();
///
/// AtomicForm(
///   key: _formKey,
///   child: Column(
///     children: [
///       AtomicFormField<String>(
///         label: 'Username',
///         required: true,
///         helperText: 'Enter your desired username',
///         validator: (value) {
///           if (value == null || value.isEmpty) {
///             return 'Username is required';
///           }
///           return null;
///         },
///         child: AtomicTextField(
///           controller: TextEditingController(),
///           hint: 'e.g., johndoe',
///         ),
///       ),
///       SizedBox(height: 16),
///       AtomicFormField<String>(
///         label: 'Email',
///         validator: AtomicValidators.email(),
///         child: AtomicTextField(
///           controller: TextEditingController(),
///           keyboardType: TextInputType.emailAddress,
///         ),
///       ),
///       SizedBox(height: 16),
///       ElevatedButton(
///         onPressed: () {
///           if (_formKey.currentState?.validate() ?? false) {
///             _formKey.currentState?.save();
///             print('Form is valid and saved!');
///           }
///         },
///         child: Text('Submit'),
///       ),
///     ],
///   ),
/// )
/// ```
class AtomicFormField<T> extends StatefulWidget {
  /// Creates an [AtomicFormField] widget.
  ///
  /// [child] is the actual input widget (e.g., [AtomicTextField], [AtomicDropdown]).
  /// [validator] is a function that validates the field's value.
  /// [onSaved] is a callback function executed when the form is saved.
  /// [onChanged] is a callback function executed when the field's value changes.
  /// [initialValue] is the initial value of the field.
  /// [enabled] controls whether the field is interactive. Defaults to true.
  /// [autovalidateMode] specifies when to auto-validate the field. Defaults to [AutovalidateMode.disabled].
  /// [label] is the text label for the field.
  /// [helperText] is an optional helper text displayed below the label.
  /// [required] if true, displays a '*' next to the label. Defaults to false.
  /// [margin] is the external margin around the form field.
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

  /// The actual input widget (e.g., [AtomicTextField], [AtomicDropdown]).
  final Widget child;

  /// A function that validates the field's value.
  final String? Function(T?)? validator;

  /// A callback function executed when the form is saved.
  final void Function(T?)? onSaved;

  /// A callback function executed when the field's value changes.
  final void Function(T?)? onChanged;

  /// The initial value of the field.
  final T? initialValue;

  /// Controls whether the field is interactive. Defaults to true.
  final bool enabled;

  /// Specifies when to auto-validate the field. Defaults to [AutovalidateMode.disabled].
  final AutovalidateMode autovalidateMode;

  /// The text label for the field.
  final String? label;

  /// An optional helper text displayed below the label.
  final String? helperText;

  /// If true, displays a '*' next to the label to indicate it's a required field. Defaults to false.
  final bool required;

  /// The external margin around the form field.
  final EdgeInsetsGeometry? margin;

  @override
  State<AtomicFormField<T>> createState() => _AtomicFormFieldState<T>();
}

class _AtomicFormFieldState<T> extends State<AtomicFormField<T>> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
  }

  void _onChanged(T? value) {
    setState(() {
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

    return widget.child;
  }
}

/// A widget that groups multiple form fields and provides validation and saving capabilities.
///
/// The [AtomicForm] is a wrapper around Flutter's [Form] widget, providing
/// a convenient way to manage the state of multiple form fields, trigger
/// validation, and save their values.
///
/// Example usage:
/// ```dart
/// GlobalKey<AtomicFormState> _formKey = GlobalKey<AtomicFormState>();
///
/// AtomicForm(
///   key: _formKey,
///   onChanged: () {
///     // Called when any form field changes
///   },
///   child: Column(
///     children: [
///       AtomicFormField<String>(
///         label: 'Name',
///         child: AtomicTextField(controller: TextEditingController()),
///         validator: (value) => value!.isEmpty ? 'Name is required' : null,
///       ),
///       ElevatedButton(
///         onPressed: () {
///           if (_formKey.currentState?.validate() ?? false) {
///             _formKey.currentState?.save();
///             print('Form is valid!');
///           }
///         },
///         child: Text('Submit'),
///       ),
///     ],
///   ),
/// )
/// ```
class AtomicForm extends StatefulWidget {
  /// Creates an [AtomicForm] widget.
  ///
  /// [child] is the widget tree containing the form fields.
  /// [onChanged] is a callback function executed when any form field changes.
  /// [autovalidateMode] specifies when to auto-validate the form. Defaults to [AutovalidateMode.disabled].
  const AtomicForm({
    super.key,
    required this.child,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  /// The widget tree containing the form fields.
  final Widget child;

  /// A callback function executed when any form field changes.
  final VoidCallback? onChanged;

  /// Specifies when to auto-validate the form. Defaults to [AutovalidateMode.disabled].
  final AutovalidateMode autovalidateMode;

  @override
  State<AtomicForm> createState() => _AtomicFormState();

  /// Returns the [AtomicFormState] for the nearest [AtomicForm] ancestor.
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

/// An abstract class defining the interface for an [AtomicForm]'s state.
///
/// This interface provides methods to interact with the form, such as
/// triggering validation, saving, and resetting its fields.
abstract class AtomicFormState {
  /// Validates all form fields.
  ///
  /// Returns true if all fields are valid, otherwise false.
  bool validate();

  /// Saves all form fields.
  void save();

  /// Resets all form fields to their initial values.
  void reset();
}

/// A utility class providing common form validation functions.
///
/// The [AtomicValidators] class offers a collection of static methods
/// that can be used as `validator` functions for form fields, ensuring
/// consistent validation logic across the application.
///
/// Example usage:
/// ```dart
/// AtomicTextField(
///   controller: TextEditingController(),
///   validator: AtomicValidators.required('This field is mandatory'),
/// )
///
/// AtomicTextField(
///   controller: TextEditingController(),
///   validator: AtomicValidators.combine([
///     AtomicValidators.email(),
///     AtomicValidators.maxLength(50),
///   ]),
/// )
/// ```
class AtomicValidators {
  AtomicValidators._();

  /// A validator that checks if a string value is not null or empty.
  ///
  /// [value] is the string to validate.
  /// [message] is the error message to return if validation fails.
  static String? required(String? value, [String? message]) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  /// A validator that checks if a string value is a valid email address.
  ///
  /// [value] is the string to validate.
  /// [message] is the error message to return if validation fails.
  static String? email(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return message ?? 'Please enter a valid email address';
    }
    return null;
  }

  /// A validator that checks if a string value meets password complexity requirements.
  ///
  /// [value] is the string to validate.
  /// [minLength] specifies the minimum required length. Defaults to 8.
  /// [requireUppercase] if true, requires at least one uppercase letter.
  /// [requireLowercase] if true, requires at least one lowercase letter.
  /// [requireNumbers] if true, requires at least one number.
  /// [requireSpecialChars] if true, requires at least one special character.
  /// [message] is the error message to return if validation fails.
  static String? password(
    String? value, {
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

    if (requireSpecialChars &&
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return message ?? 'Password must contain at least one special character';
    }

    return null;
  }

  /// A validator that checks if a string value is a valid phone number.
  ///
  /// [value] is the string to validate.
  /// [message] is the error message to return if validation fails.
  static String? phone(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;

    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  }

  /// A validator that checks if a string value meets a minimum length requirement.
  ///
  /// [value] is the string to validate.
  /// [minLength] specifies the minimum required length.
  /// [message] is the error message to return if validation fails.
  static String? minLength(String? value, int minLength, [String? message]) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return message ?? 'Must be at least $minLength characters';
    }
    return null;
  }

  /// A validator that checks if a string value meets a maximum length requirement.
  ///
  /// [value] is the string to validate.
  /// [maxLength] specifies the maximum allowed length.
  /// [message] is the error message to return if validation fails.
  static String? maxLength(String? value, int maxLength, [String? message]) {
    if (value == null || value.isEmpty) return null;

    if (value.length > maxLength) {
      return message ?? 'Must be no more than $maxLength characters';
    }
    return null;
  }

  /// A validator that checks if a string value is a valid numeric value.
  ///
  /// [value] is the string to validate.
  /// [message] is the error message to return if validation fails.
  static String? numeric(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return message ?? 'Please enter a valid number';
    }
    return null;
  }

  /// A validator that checks if a string value is a valid URL (http or https).
  ///
  /// [value] is the string to validate.
  /// [message] is the error message to return if validation fails.
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

  /// Combines multiple validators into a single validator function.
  ///
  /// The combined validator returns the first error message encountered,
  /// or null if all validators pass.
  ///
  /// [validators] is a list of validator functions to combine.
  static String? Function(String?) combine(
      List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
