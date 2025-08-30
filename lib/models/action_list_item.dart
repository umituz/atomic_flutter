import 'package:flutter/material.dart';

/// A model representing an item in an action list, typically used for interactive lists
/// where each item can trigger an action.
///
/// This class provides properties for displaying text, an optional subtext, an icon,
/// and a callback for when the item is tapped. It also includes methods for
/// serialization (toJson, fromJson) and immutability (copyWith).
class AtomicActionListItem {
  /// Creates an [AtomicActionListItem].
  ///
  /// [text] is the primary text displayed for the list item.
  /// [subtext] is an optional secondary text displayed below the primary text.
  /// [icon] is an optional icon displayed next to the text.
  /// [onTap] is the callback function executed when the item is tapped.
  /// [enabled] determines if the item is interactive. Defaults to true.
  /// [uniqueKey] is an optional unique identifier for the item. If not provided,
  /// a unique key is generated based on the current microsecond epoch.
  const AtomicActionListItem({
    required this.text,
    this.subtext,
    this.icon,
    this.onTap,
    this.enabled = true,
    String? uniqueKey,
  }) : uniqueKey = uniqueKey ?? '';

  /// The primary text displayed for the list item.
  final String text;

  /// An optional secondary text displayed below the primary text.
  final String? subtext;

  /// An optional icon displayed next to the text.
  final IconData? icon;

  /// The callback function executed when the item is tapped.
  final VoidCallback? onTap;

  /// Determines if the item is interactive. Defaults to true.
  final bool enabled;

  /// A unique identifier for the item.
  final String uniqueKey;

  /// Creates a new [AtomicActionListItem] instance with updated properties.
  ///
  /// If a parameter is null, the corresponding property from the original object
  /// is retained.
  AtomicActionListItem copyWith({
    String? text,
    String? subtext,
    IconData? icon,
    VoidCallback? onTap,
    bool? enabled,
    String? uniqueKey,
  }) {
    return AtomicActionListItem(
      text: text ?? this.text,
      subtext: subtext ?? this.subtext,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      enabled: enabled ?? this.enabled,
      uniqueKey: uniqueKey ?? this.uniqueKey,
    );
  }

  /// Generates a unique key based on the current microsecond epoch.
  static String generateUniqueKey() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Creates an [AtomicActionListItem] from a JSON map.
  ///
  /// Expects a map with 'text' and optional 'subtext' and 'unique_key' fields.
  factory AtomicActionListItem.fromJson(Map<String, dynamic> json) {
    return AtomicActionListItem(
      text: json['text'] ?? '',
      subtext: json['subtext'],
      uniqueKey: json['unique_key'],
    );
  }

  /// Converts this [AtomicActionListItem] instance to a JSON map.
  ///
  /// If `uniqueKey` is empty, a new unique key is generated before conversion.
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'subtext': subtext,
      'unique_key': uniqueKey.isEmpty ? generateUniqueKey() : uniqueKey,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicActionListItem &&
        other.text == text &&
        other.subtext == subtext &&
        other.uniqueKey == uniqueKey;
  }

  @override
  int get hashCode {
    return Object.hash(text, subtext, uniqueKey);
  }

  @override
  String toString() {
    return 'AtomicActionListItem(text: $text, subtext: $subtext, uniqueKey: $uniqueKey)';
  }
}
