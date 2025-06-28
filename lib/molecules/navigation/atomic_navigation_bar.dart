import 'package:flutter/material.dart';
import 'dart:ui';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/animations/atomic_animations.dart';
import '../../tokens/spacing/atomic_spacing.dart';
import '../../tokens/typography/atomic_typography.dart';
import '../../atoms/icons/atomic_icon.dart';
import '../../atoms/feedback/atomic_badge.dart';

class AtomicNavigationBar extends StatefulWidget {
  const AtomicNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.glassMorphism = true,
    this.height = 82.0,
    this.margin,
    this.borderRadius = 0.0,
    this.animationDuration = AtomicAnimations.normal,
    this.showLabels = true,
    this.showSelectedLabels = true,
  });

  final List<AtomicNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Color? backgroundColor;
  final bool glassMorphism;
  final double height;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Duration animationDuration;
  final bool showLabels;
  final bool showSelectedLabels;

  @override
  State<AtomicNavigationBar> createState() => _AtomicNavigationBarState();
}

class _AtomicNavigationBarState extends State<AtomicNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      margin: widget.margin ?? EdgeInsets.symmetric(
        horizontal: AtomicSpacing.md,
        vertical: AtomicSpacing.sm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: widget.glassMorphism 
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            height: widget.height + (bottomPadding > 0 ? bottomPadding : AtomicSpacing.sm),
            decoration: BoxDecoration(
              color: widget.glassMorphism
                  ? (widget.backgroundColor ?? theme.colors.surface).withValues(alpha: 0.8)
                  : (widget.backgroundColor ?? theme.colors.surface),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.glassMorphism 
                  ? Border.all(
                      color: theme.colors.gray200.withValues(alpha: 0.3),
                      width: 1.5,
                    )
                  : null,
              boxShadow: [
                if (widget.glassMorphism) ...[
                  BoxShadow(
                    color: theme.colors.gray900.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: theme.colors.gray900.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AtomicSpacing.sm,
                  vertical: AtomicSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    widget.destinations.length,
                    (index) => _buildNavigationItem(
                      theme,
                      widget.destinations[index],
                      index,
                      widget.selectedIndex == index,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    AtomicThemeData theme,
    AtomicNavigationDestination destination,
    int index,
    bool isSelected,
  ) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return GestureDetector(
            onTap: destination.enabled
                ? () {
                    widget.onDestinationSelected(index);
                    _animationController.forward().then((_) {
                      _animationController.reverse();
                    });
                  }
                : null,
            behavior: HitTestBehavior.opaque,
            child: ClipRect(
              child: AnimatedContainer(
                duration: widget.animationDuration,
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  vertical: AtomicSpacing.sm,
                  horizontal: AtomicSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with enhanced styling
                      Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(AtomicSpacing.xxs),
                          child: Center(
                            child: AnimatedScale(
                              duration: widget.animationDuration,
                              scale: isSelected ? 1.1 : 1.0,
                              child: _buildIcon(theme, destination, isSelected),
                            ),
                          ),
                        ),
                      ),
                      
                      // Label - show for all items but highlight selected
                      if (widget.showLabels && 
                          destination.label.isNotEmpty)
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: AtomicSpacing.xxs),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                destination.label,
                                style: theme.typography.labelMedium.copyWith(
                                  color: isSelected 
                                      ? theme.colors.primary 
                                      : theme.colors.textSecondary,
                                  fontWeight: isSelected 
                                      ? AtomicTypography.bold 
                                      : AtomicTypography.medium,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(
    AtomicThemeData theme,
    AtomicNavigationDestination destination,
    bool isSelected,
  ) {
    final iconData = isSelected && destination.selectedIcon != null
        ? destination.selectedIcon!
        : destination.icon;

    Widget iconWidget = AtomicIcon(
      icon: iconData,
      size: AtomicIconSize.large,
      color: isSelected 
          ? theme.colors.primary 
          : theme.colors.textSecondary,
    );

    // Add badge if present
    if (destination.badge != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          iconWidget,
          Positioned(
            right: -8,
            top: -8,
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