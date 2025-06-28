import 'package:flutter/material.dart';

/// Atomic Select List Item Model
/// Represents a selectable item in a dropdown or picker with text, value, and optional subtext
class AtomicSelectListItem<T> {
  const AtomicSelectListItem({
    required this.text,
    this.subText,
    T? value,
    this.icon,
    this.enabled = true,
    this.selected = false,
  }) : value = value;

  final String text;
  final String? subText;
  final T? value;
  final IconData? icon;
  final bool enabled;
  final bool selected;

  /// Create a copy of this item with modified properties
  AtomicSelectListItem<T> copyWith({
    String? text,
    String? subText,
    T? value,
    IconData? icon,
    bool? enabled,
    bool? selected,
  }) {
    return AtomicSelectListItem<T>(
      text: text ?? this.text,
      subText: subText ?? this.subText,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      enabled: enabled ?? this.enabled,
      selected: selected ?? this.selected,
    );
  }

  /// Generate a unique value if not provided
  static String generateUniqueValue() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Create from JSON
  factory AtomicSelectListItem.fromJson(Map<String, dynamic> json) {
    return AtomicSelectListItem<T>(
      text: json['text'] ?? '',
      subText: json['sub_text'],
      value: json['value'],
      enabled: json['enabled'] ?? true,
      selected: json['selected'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sub_text': subText,
      'value': value ?? generateUniqueValue(),
      'enabled': enabled,
      'selected': selected,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicSelectListItem<T> &&
        other.text == text &&
        other.subText == subText &&
        other.value == value &&
        other.icon == icon &&
        other.enabled == enabled &&
        other.selected == selected;
  }

  @override
  int get hashCode {
    return Object.hash(text, subText, value, icon, enabled, selected);
  }

  @override
  String toString() {
    return 'AtomicSelectListItem(text: $text, value: $value, selected: $selected)';
  }
}

/// Non-generic version for backward compatibility
class AtomicSelectListItemDynamic extends AtomicSelectListItem<dynamic> {
  const AtomicSelectListItemDynamic({
    required super.text,
    super.subText,
    super.value,
    super.icon,
    super.enabled = true,
    super.selected = false,
  });
} 