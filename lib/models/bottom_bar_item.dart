import 'package:flutter/material.dart';

/// A model representing an item in a bottom navigation bar.
///
/// This class defines the properties for an item displayed in a bottom navigation bar,
/// including its icon, an optional label, a selected icon, a badge, and its enabled state.
class AtomicBottomBarItem {
  /// Creates an [AtomicBottomBarItem].
  ///
  /// [icon] is the icon displayed when the item is not selected.
  /// [label] is an optional text label displayed below the icon.
  /// [selectedIcon] is an optional icon displayed when the item is selected.
  /// If null, [icon] will be used.
  /// [badge] is an optional widget to display as a badge on the item (e.g., a notification count).
  /// [enabled] determines if the item is interactive. Defaults to true.
  /// [tooltip] is an optional text to display when the item is long-pressed.
  const AtomicBottomBarItem({
    required this.icon,
    this.label,
    this.selectedIcon,
    this.badge,
    this.enabled = true,
    this.tooltip,
  });

  /// The icon displayed when the item is not selected.
  final IconData icon;

  /// An optional text label displayed below the icon.
  final String? label;

  /// An optional icon displayed when the item is selected.
  /// If null, [icon] will be used.
  final IconData? selectedIcon;

  /// An optional widget to display as a badge on the item (e.g., a notification count).
  final Widget? badge;

  /// Determines if the item is interactive. Defaults to true.
  final bool enabled;

  /// An optional text to display when the item is long-pressed.
  final String? tooltip;

  /// Creates a new [AtomicBottomBarItem] instance with updated properties.
  ///
  /// If a parameter is null, the corresponding property from the original object
  /// is retained.
  AtomicBottomBarItem copyWith({
    IconData? icon,
    String? label,
    IconData? selectedIcon,
    Widget? badge,
    bool? enabled,
    String? tooltip,
  }) {
    return AtomicBottomBarItem(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      badge: badge ?? this.badge,
      enabled: enabled ?? this.enabled,
      tooltip: tooltip ?? this.tooltip,
    );
  }

  /// Creates an [AtomicBottomBarItem] from a JSON map.
  ///
  /// Expects a map with 'icon_code_point', 'icon_font_family', and optional
  /// 'label', 'enabled', and 'tooltip' fields.
  factory AtomicBottomBarItem.fromJson(Map<String, dynamic> json) {
    return AtomicBottomBarItem(
      icon: IconData(
        json['icon_code_point'] ?? Icons.home.codePoint,
        fontFamily: json['icon_font_family'] ?? 'MaterialIcons',
      ),
      label: json['label'],
      enabled: json['enabled'] ?? true,
      tooltip: json['tooltip'],
    );
  }

  /// Converts this [AtomicBottomBarItem] instance to a JSON map.
  ///
  /// Includes 'icon_code_point', 'icon_font_family', and optional
  /// 'label', 'enabled', and 'tooltip' fields.
  Map<String, dynamic> toJson() {
    return {
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily,
      'label': label,
      'enabled': enabled,
      'tooltip': tooltip,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AtomicBottomBarItem &&
        other.icon == icon &&
        other.label == label &&
        other.selectedIcon == selectedIcon &&
        other.enabled == enabled &&
        other.tooltip == tooltip;
  }

  @override
  int get hashCode {
    return Object.hash(icon, label, selectedIcon, enabled, tooltip);
  }

  @override
  String toString() {
    return 'AtomicBottomBarItem(icon: $icon, label: $label, enabled: $enabled)';
  }
}
