import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/animations/atomic_animations.dart';
import '../../atoms/icons/atomic_icon.dart';
import '../../atoms/feedback/atomic_badge.dart';

/// Atomic Navigation Bar Component
/// Material Design 3 bottom navigation bar
class AtomicNavigationBar extends StatelessWidget {
  const AtomicNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.height = 80.0,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
    this.animationDuration = AtomicAnimations.normal,
    this.indicatorColor,
    this.indicatorShape,
    this.surfaceTintColor,
    this.shadowColor,
    this.overlayColor,
  });

  final List<AtomicNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Color? backgroundColor;
  final double? elevation;
  final double height;
  final NavigationDestinationLabelBehavior labelBehavior;
  final Duration animationDuration;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final Color? surfaceTintColor;
  final Color? shadowColor;
  final WidgetStateProperty<Color?>? overlayColor;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor ?? theme.colors.surface,
      elevation: elevation ?? 3.0,
      height: height,
      labelBehavior: labelBehavior,
      animationDuration: animationDuration,
      indicatorColor: indicatorColor ?? theme.colors.secondary,
      indicatorShape: indicatorShape,
      surfaceTintColor: surfaceTintColor ?? theme.colors.surface,
      shadowColor: shadowColor ?? theme.colors.gray300,
      overlayColor: overlayColor,
      destinations: destinations.map((destination) {
        return NavigationDestination(
          icon: _buildIcon(destination, false),
          selectedIcon: _buildIcon(destination, true),
          label: destination.label,
          tooltip: destination.tooltip,
          enabled: destination.enabled,
        );
      }).toList(),
    );
  }

  Widget _buildIcon(AtomicNavigationDestination destination, bool isSelected) {
    Widget iconWidget = destination.selectedIcon != null && isSelected
        ? AtomicIcon(
            icon: destination.selectedIcon!,
            size: AtomicIconSize.large,
            color: isSelected ? null : AtomicColors.gray600,
          )
        : AtomicIcon(
            icon: destination.icon,
            size: AtomicIconSize.large,
            color: isSelected ? null : AtomicColors.gray600,
          );

    if (destination.badge != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -6,
            top: -6,
            child: destination.badge!,
          ),
        ],
      );
    }

    return iconWidget;
  }
}

/// Navigation destination data class
class AtomicNavigationDestination {
  const AtomicNavigationDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
    this.badge,
    this.enabled = true,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final String? tooltip;
  final AtomicBadge? badge;
  final bool enabled;
}

/// Rail variant for larger screens
class AtomicNavigationRail extends StatelessWidget {
  const AtomicNavigationRail({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.elevation,
    this.extended = false,
    this.leading,
    this.trailing,
    this.groupAlignment = 0.0,
    this.labelType,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.unselectedIconTheme,
    this.selectedIconTheme,
    this.minWidth = 72.0,
    this.minExtendedWidth = 256.0,
    this.useIndicator = true,
    this.indicatorColor,
    this.indicatorShape,
  });

  final List<AtomicNavigationRailDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Color? backgroundColor;
  final double? elevation;
  final bool extended;
  final Widget? leading;
  final Widget? trailing;
  final double groupAlignment;
  final NavigationRailLabelType? labelType;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final IconThemeData? unselectedIconTheme;
  final IconThemeData? selectedIconTheme;
  final double minWidth;
  final double minExtendedWidth;
  final bool useIndicator;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor ?? theme.colors.surface,
      elevation: elevation ?? 1.0,
      extended: extended,
      leading: leading,
      trailing: trailing,
      groupAlignment: groupAlignment,
      labelType: labelType,
      unselectedLabelTextStyle: unselectedLabelTextStyle,
      selectedLabelTextStyle: selectedLabelTextStyle,
      unselectedIconTheme: unselectedIconTheme,
      selectedIconTheme: selectedIconTheme,
      minWidth: minWidth,
      minExtendedWidth: minExtendedWidth,
      useIndicator: useIndicator,
      indicatorColor: indicatorColor ?? theme.colors.secondary,
      indicatorShape: indicatorShape,
      destinations: destinations.map((destination) {
        return NavigationRailDestination(
          icon: _buildIcon(destination, false),
          selectedIcon: _buildIcon(destination, true),
          label: Text(destination.label),
          disabled: !destination.enabled,
          padding: destination.padding,
        );
      }).toList(),
    );
  }

  Widget _buildIcon(AtomicNavigationRailDestination destination, bool isSelected) {
    Widget iconWidget = destination.selectedIcon != null && isSelected
        ? AtomicIcon(
            icon: destination.selectedIcon!,
            size: AtomicIconSize.large,
            color: isSelected ? null : AtomicColors.gray600,
          )
        : AtomicIcon(
            icon: destination.icon,
            size: AtomicIconSize.large,
            color: isSelected ? null : AtomicColors.gray600,
          );

    if (destination.badge != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -6,
            top: -6,
            child: destination.badge!,
          ),
        ],
      );
    }

    return iconWidget;
  }
}

/// Navigation rail destination data class
class AtomicNavigationRailDestination {
  const AtomicNavigationRailDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badge,
    this.enabled = true,
    this.padding,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final AtomicBadge? badge;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
} 