import 'package:flutter/material.dart';
import '../tokens/colors/atomic_colors.dart';

/// Atomic Icon List Item Model
/// Represents a list item with icon, title, and subtitle with customizable colors
class AtomicIconListItemModel {
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

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color iconColor;
  final Color textColor;
  final Color subTextColor;
  final VoidCallback? onTap;
  final bool enabled;

  /// Create a copy of this item with modified properties
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

  /// Create from JSON
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

  /// Convert to JSON
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