import 'package:flutter/material.dart';

/// Atomic Action List Item Model
/// Represents an actionable item in a list with text, optional subtext, and unique identifier
class AtomicActionListItem {
  const AtomicActionListItem({
    required this.text,
    this.subtext,
    this.icon,
    this.onTap,
    this.enabled = true,
    String? uniqueKey,
  }) : uniqueKey = uniqueKey ?? '';

  final String text;
  final String? subtext;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;
  final String uniqueKey;

  /// Create a copy of this item with modified properties
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

  /// Generate a unique key if not provided
  static String generateUniqueKey() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Create from JSON
  factory AtomicActionListItem.fromJson(Map<String, dynamic> json) {
    return AtomicActionListItem(
      text: json['text'] ?? '',
      subtext: json['subtext'],
      uniqueKey: json['unique_key'],
    );
  }

  /// Convert to JSON
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

/// Legacy compatibility - use AtomicActionListItem instead
@Deprecated('Use AtomicActionListItem instead')
typedef ActionListItem = AtomicActionListItem; 