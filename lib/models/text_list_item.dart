import 'package:flutter/material.dart';

/// A model representing a list item primarily composed of text.
///
/// This class defines the properties for a list item that displays a primary
/// text and an optional secondary text. It allows for customization of text
/// styles, tap behavior, and text overflow properties.
class AtomicTextListItem {
  /// Creates an [AtomicTextListItem].
  ///
  /// [text] is the primary text displayed for the list item.
  /// [subText] is an optional secondary text displayed below the primary text.
  /// [textStyle] is the [TextStyle] for the primary text.
  /// [subTextStyle] is the [TextStyle] for the secondary text.
  /// [onTap] is the callback function executed when the item is tapped.
  /// [enabled] determines if the item is interactive. Defaults to true.
  /// [maxLines] is the maximum number of lines for the primary text.
  /// [overflow] defines how visual overflow of the primary text is handled.
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

  /// The primary text displayed for the list item.
  final String text;

  /// An optional secondary text displayed below the primary text.
  final String? subText;

  /// The [TextStyle] for the primary text.
  final TextStyle? textStyle;

  /// The [TextStyle] for the secondary text.
  final TextStyle? subTextStyle;

  /// The callback function executed when the item is tapped.
  final VoidCallback? onTap;

  /// Determines if the item is interactive. Defaults to true.
  final bool enabled;

  /// The maximum number of lines for the primary text.
  final int? maxLines;

  /// Defines how visual overflow of the primary text is handled.
  final TextOverflow? overflow;

  /// Creates a new [AtomicTextListItem] instance with updated properties.
  ///
  /// If a parameter is null, the corresponding property from the original object
  /// is retained.
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

  /// Creates an [AtomicTextListItem] from a JSON map.
  ///
  /// Expects a map with 'text' and optional 'sub_text', 'enabled', and 'max_lines' fields.
  factory AtomicTextListItem.fromJson(Map<String, dynamic> json) {
    return AtomicTextListItem(
      text: json['text'] ?? '',
      subText: json['sub_text'],
      enabled: json['enabled'] ?? true,
      maxLines: json['max_lines'],
    );
  }

  /// Converts this [AtomicTextListItem] instance to a JSON map.
  ///
  /// Includes 'text', 'sub_text', 'enabled', and 'max_lines' fields.
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sub_text': subText,
      'enabled': enabled,
      'max_lines': maxLines,
    };
  }

  /// Returns true if [subText] is not null and not empty.
  bool get hasSubText => subText != null && subText!.isNotEmpty;

  /// Returns the primary text, or 'No title' if it's empty.
  String get displayText => text.isEmpty ? 'No title' : text;

  /// Returns the secondary text, or an empty string if it's null or empty.
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
