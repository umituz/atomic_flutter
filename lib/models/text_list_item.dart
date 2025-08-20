import 'package:flutter/material.dart';

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

  factory AtomicTextListItem.fromJson(Map<String, dynamic> json) {
    return AtomicTextListItem(
      text: json['text'] ?? '',
      subText: json['sub_text'],
      enabled: json['enabled'] ?? true,
      maxLines: json['max_lines'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sub_text': subText,
      'enabled': enabled,
      'max_lines': maxLines,
    };
  }

  bool get hasSubText => subText != null && subText!.isNotEmpty;

  String get displayText => text.isEmpty ? 'No title' : text;

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