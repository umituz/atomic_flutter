import 'package:flutter/material.dart';

/// Atomic Text List Item Model
/// Represents a simple text item with primary text and optional subtext
class AtomicTextListItem {
  const AtomicTextListItem({
    required this.text,
    this.subText,
    this.textStyle,
    this.subTextStyle,
    this.onTap,
    this.enabled = true,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final String? subText;
  final TextStyle? textStyle;
  final TextStyle? subTextStyle;
  final VoidCallback? onTap;
  final bool enabled;
  final int? maxLines;
  final TextOverflow? overflow;

  /// Create a copy of this item with modified properties
  AtomicTextListItem copyWith({
    String? text,
    String? subText,
    TextStyle? textStyle,
    TextStyle? subTextStyle,
    VoidCallback? onTap,
    bool? enabled,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return AtomicTextListItem(
      text: text ?? this.text,
      subText: subText ?? this.subText,
      textStyle: textStyle ?? this.textStyle,
      subTextStyle: subTextStyle ?? this.subTextStyle,
      onTap: onTap ?? this.onTap,
      enabled: enabled ?? this.enabled,
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
    );
  }

  /// Create from JSON
  factory AtomicTextListItem.fromJson(Map<String, dynamic> json) {
    return AtomicTextListItem(
      text: json['text'] ?? '',
      subText: json['sub_text'],
      enabled: json['enabled'] ?? true,
      maxLines: json['max_lines'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sub_text': subText,
      'enabled': enabled,
      'max_lines': maxLines,
    };
  }

  /// Check if item has subtext
  bool get hasSubText => subText != null && subText!.isNotEmpty;

  /// Get display text with fallback
  String get displayText => text.isEmpty ? 'No title' : text;

  /// Get display subtext with fallback
  String get displaySubText => hasSubText ? subText! : '';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicTextListItem &&
        other.text == text &&
        other.subText == subText &&
        other.enabled == enabled &&
        other.maxLines == maxLines &&
        other.overflow == overflow;
  }

  @override
  int get hashCode {
    return Object.hash(text, subText, enabled, maxLines, overflow);
  }

  @override
  String toString() {
    return 'AtomicTextListItem(text: $text, subText: $subText, enabled: $enabled)';
  }
}

/// Legacy compatibility - use AtomicTextListItem instead
@Deprecated('Use AtomicTextListItem instead')
typedef TextListItem = AtomicTextListItem; 