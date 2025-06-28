/// Bool Extension for Atomic Flutter
/// Provides additional functionality for bool values

extension AtomicBoolExtension on bool {
  /// Serializes boolean to integer for API compatibility
  /// true -> 1, false -> 0
  int toInt() {
    return this ? 1 : 0;
  }

  /// Serializes boolean to integer (alias for API compatibility)
  int serialize() {
    return toInt();
  }

  /// Converts boolean to Yes/No string
  String toYesNo() {
    return this ? 'Yes' : 'No';
  }

  /// Converts boolean to On/Off string
  String toOnOff() {
    return this ? 'On' : 'Off';
  }

  /// Converts boolean to Enabled/Disabled string
  String toEnabledDisabled() {
    return this ? 'Enabled' : 'Disabled';
  }

  /// Converts boolean to custom strings
  String toCustomString(String trueValue, String falseValue) {
    return this ? trueValue : falseValue;
  }
}

/// Static helper for creating bool from various sources
class AtomicBool {
  /// Creates bool from integer (0 = false, anything else = true)
  static bool fromInt(int value) {
    return value != 0;
  }

  /// Creates bool from string (case-insensitive)
  /// Recognizes: true, yes, on, 1, enabled
  static bool fromString(String? value) {
    if (value == null) return false;
    
    final lowered = value.toLowerCase().trim();
    return ['true', 'yes', 'on', '1', 'enabled'].contains(lowered);
  }

  /// Creates bool from dynamic value
  static bool fromDynamic(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return fromInt(value);
    if (value is String) return fromString(value);
    return false;
  }
} 