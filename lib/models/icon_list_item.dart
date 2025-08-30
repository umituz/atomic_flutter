import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';

/// A model representing a list item with an optional icon.
///
/// This class defines the properties for a list item that can display a title,
/// an optional subtitle, and an optional icon. It also allows for customization
/// of text and icon colors, and defines an optional tap callback.
class AtomicIconListItemModel {
  /// Creates an [AtomicIconListItemModel].
  ///
  /// [title] is the primary text displayed for the list item.
  /// [subtitle] is an optional secondary text displayed below the title.
  /// [icon] is an optional icon displayed next to the text.
  /// [iconColor] is the color of the icon. Defaults to [AtomicColors.gray500].
  /// [textColor] is the color of the title text. Defaults to [AtomicColors.textPrimary].
  /// [subTextColor] is the color of the subtitle text. Defaults to [AtomicColors.textSecondary].
  /// [onTap] is the callback function executed when the item is tapped.
  /// [enabled] determines if the item is interactive. Defaults to true.
  const AtomicIconListItemModel({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor = AtomicColors.gray500,
    this.textColor = AtomicColors.textPrimary,
    this.subTextColor = AtomicColors.textSecondary,
    this.onTap,
    this.enabled = true,
  });

  /// The primary text displayed for the list item.
  final String title;

  /// An optional secondary text displayed below the title.
  final String? subtitle;

  /// An optional icon displayed next to the text.
  final IconData? icon;

  /// The color of the icon. Defaults to [AtomicColors.gray500].
  final Color iconColor;

  /// The color of the title text. Defaults to [AtomicColors.textPrimary].
  final Color subTextColor;

  /// The color of the subtitle text. Defaults to [AtomicColors.textSecondary].
  final Color textColor;

  /// The callback function executed when the item is tapped.
  final VoidCallback? onTap;

  /// Determines if the item is interactive. Defaults to true.
  final bool enabled;

  /// Creates a new [AtomicIconListItemModel] instance with updated properties.
  ///
  /// If a parameter is null, the corresponding property from the original object
  /// is retained.
  AtomicIconListItemModel copyWith({
    String? title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? textColor,
    Color? subTextColor,
    VoidCallback? onTap,
    bool? enabled,
  }) {
    return AtomicIconListItemModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      subTextColor: subTextColor ?? this.subTextColor,
      onTap: onTap ?? this.onTap,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Creates an [AtomicIconListItemModel] from a JSON map.
  ///
  /// Expects a map with 'title' and optional 'subtitle', 'icon_code_point',
  /// 'icon_font_family', and 'enabled' fields.
  factory AtomicIconListItemModel.fromJson(Map<String, dynamic> json) {
    return AtomicIconListItemModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      icon: json['icon_code_point'] != null
          ? IconData(
              json['icon_code_point'],
              fontFamily: json['icon_font_family'] ?? 'MaterialIcons',
            )
          : null,
      enabled: json['enabled'] ?? true,
    );
  }

  /// Converts this [AtomicIconListItemModel] instance to a JSON map.
  ///
  /// Includes 'title', 'subtitle', 'icon_code_point', 'icon_font_family',
  /// and 'enabled' fields.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon_code_point': icon?.codePoint,
      'icon_font_family': icon?.fontFamily,
      'enabled': enabled,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicIconListItemModel &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.icon == icon &&
        other.iconColor == iconColor &&
        other.textColor == textColor &&
        other.subTextColor == subTextColor &&
        other.enabled == enabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      subtitle,
      icon,
      iconColor,
      textColor,
      subTextColor,
      enabled,
    );
  }

  @override
  String toString() {
    return 'AtomicIconListItemModel(title: $title, subtitle: $subtitle, icon: $icon)';
  }
}
