import 'package:flutter/material.dart';

/// A generic model representing an item in a selectable list.
///
/// This class is used for items that can be selected from a list, such as in
/// dropdowns, radio buttons, or checkboxes. It supports a generic type [T]
/// for the item's value.
class AtomicSelectListItem<T> {
  /// Creates an [AtomicSelectListItem].
  ///
  /// [text] is the primary text displayed for the list item.
  /// [subText] is an optional secondary text displayed below the primary text.
  /// [value] is the generic value associated with this list item.
  /// [icon] is an optional icon displayed next to the text.
  /// [enabled] determines if the item is interactive. Defaults to true.
  /// [selected] indicates whether the item is currently selected. Defaults to false.
  const AtomicSelectListItem({
    required this.text,
    this.subText,
    T? value,
    this.icon,
    this.enabled = true,
    this.selected = false,
  }) : value = value;

  /// The primary text displayed for the list item.
  final String text;

  /// An optional secondary text displayed below the primary text.
  final String? subText;

  /// The generic value associated with this list item.
  final T? value;

  /// An optional icon displayed next to the text.
  final IconData? icon;

  /// Determines if the item is interactive. Defaults to true.
  final bool enabled;

  /// Indicates whether the item is currently selected. Defaults to false.
  final bool selected;

  /// Creates a new [AtomicSelectListItem] instance with updated properties.
  ///
  /// If a parameter is null, the corresponding property from the original object
  /// is retained.
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

  /// Generates a unique string value based on the current microsecond epoch.
  ///
  /// This is typically used when a unique value is needed for an item that
  /// doesn't have an explicit one.
  static String generateUniqueValue() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Creates an [AtomicSelectListItem] from a JSON map.
  ///
  /// Expects a map with 'text' and optional 'sub_text', 'value', 'enabled',
  /// and 'selected' fields.
  factory AtomicSelectListItem.fromJson(Map<String, dynamic> json) {
    return AtomicSelectListItem<T>(
      text: json['text'] ?? '',
      subText: json['sub_text'],
      value: json['value'],
      enabled: json['enabled'] ?? true,
      selected: json['selected'] ?? false,
    );
  }

  /// Converts this [AtomicSelectListItem] instance to a JSON map.
  ///
  /// If `value` is null, a unique value is generated before conversion.
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
  @override
  String toString() {
    return 'AtomicSelectListItem(text: $text, value: $value, selected: $selected)';
  }
}

/// A specialized [AtomicSelectListItem] for dynamic values.
///
/// This class is a convenience class for when the type of the value is dynamic.
class AtomicSelectListItemDynamic extends AtomicSelectListItem<dynamic> {
  /// Creates an [AtomicSelectListItemDynamic].
  const AtomicSelectListItemDynamic({
    required super.text,
    super.subText,
    super.value,
    super.icon,
    super.enabled = true,
    super.selected = false,
  });
}
