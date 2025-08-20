
extension AtomicBoolExtension on bool {
  int toInt() {
    return this ? 1 : 0;
  }

  int serialize() {
    return toInt();
  }

  String toYesNo() {
    return this ? 'Yes' : 'No';
  }

  String toOnOff() {
    return this ? 'On' : 'Off';
  }

  String toEnabledDisabled() {
    return this ? 'Enabled' : 'Disabled';
  }

  String toCustomString(String trueValue, String falseValue) {
    return this ? trueValue : falseValue;
  }
}

class AtomicBool {
  static bool fromInt(int value) {
    return value != 0;
  }

  static bool fromString(String? value) {
    if (value == null) return false;
    
    final lowered = value.toLowerCase().trim();
    return ['true', 'yes', 'on', '1', 'enabled'].contains(lowered);
  }

  static bool fromDynamic(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return fromInt(value);
    if (value is String) return fromString(value);
    return false;
  }
} 