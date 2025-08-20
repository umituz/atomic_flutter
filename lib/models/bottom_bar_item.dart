import 'package:flutter/material.dart';

class AtomicBottomBarItem {
  const AtomicBottomBarItem({
    required this.icon,
    this.label,
    this.selectedIcon,
    this.badge,
    this.enabled = true,
    this.tooltip,
  });

  final IconData icon;
  final String? label;
  final IconData? selectedIcon;
  final Widget? badge;
  final bool enabled;
  final String? tooltip;

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