import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/icons/atomic_icon.dart';
import 'package:atomic_flutter_kit/atoms/feedback/atomic_badge.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_avatar.dart';

class AtomicListItem extends StatelessWidget {
  const AtomicListItem({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.dense = false,
    this.visualDensity,
    this.contentPadding,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback = true,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.titleAlignment,
    this.splashColor,
    this.focusColor,
    this.hoverColor,
    this.autofocus = false,
    this.shape,
    this.variant = AtomicListItemVariant.standard,
    this.size = AtomicListItemSize.medium,
    this.margin,
    this.borderRadius,
    this.showDivider = false,
    this.badge,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final bool selected;
  final bool enabled;
  final bool autofocus;

  final bool dense;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? contentPadding;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;
  final ListTileTitleAlignment? titleAlignment;

  final Color? tileColor;
  final Color? selectedTileColor;
  final Color? splashColor;
  final Color? focusColor;
  final Color? hoverColor;
  final ShapeBorder? shape;
  final bool enableFeedback;

  final AtomicListItemVariant variant;
  final AtomicListItemSize size;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool showDivider;
  final AtomicBadge? badge;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    Widget listTile = ListTile(
      leading: _buildLeading(),
      title: title,
      subtitle: subtitle,
      trailing: _buildTrailing(),
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      selected: selected,
      enabled: enabled,
      dense: _getDense(),
      visualDensity: visualDensity,
      contentPadding: _getContentPadding(theme),
      tileColor: _getTileColor(theme),
      selectedTileColor: _getSelectedTileColor(theme),
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap ?? _getHorizontalTitleGap(),
      minVerticalPadding: minVerticalPadding ?? _getMinVerticalPadding(),
      minLeadingWidth: minLeadingWidth ?? _getMinLeadingWidth(),
      titleAlignment: titleAlignment ?? ListTileTitleAlignment.threeLine,
      splashColor: splashColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      autofocus: autofocus,
      shape: shape ?? _getShape(theme),
    );

    if (variant != AtomicListItemVariant.standard || 
        borderRadius != null || 
        margin != null) {
      listTile = Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? _getBorderRadius(theme),
          color: _getTileColor(theme),
          border: variant == AtomicListItemVariant.outlined 
              ? Border.all(
                  color: AtomicColors.dividerColor,
                  width: 1,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? _getBorderRadius(theme),
          child: listTile,
        ),
      );
    }

    if (showDivider) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          listTile,
          Divider(
            height: 1,
            thickness: 1,
            color: AtomicColors.dividerColor.withValues(alpha: 0.2),
          ),
        ],
      );
    }

    return listTile;
  }

  Widget? _buildLeading() {
    if (leading == null && badge == null) return null;
    
    if (badge != null && leading != null) {
      return AtomicBadge(
        count: badge!.count,
        showZero: badge!.showZero,
        position: badge!.position,
        child: leading!,
      );
    }
    
    return leading;
  }

  Widget? _buildTrailing() {
    if (trailing == null) return null;
    
    if (trailing is Icon || trailing is AtomicIcon) {
      return SizedBox(
        width: 24,
        height: 24,
        child: trailing,
      );
    }
    
    return trailing;
  }

  bool _getDense() {
    switch (size) {
      case AtomicListItemSize.small:
        return true;
      case AtomicListItemSize.medium:
        return dense;
      case AtomicListItemSize.large:
        return false;
    }
  }

  EdgeInsetsGeometry _getContentPadding(AtomicThemeData theme) {
    if (contentPadding != null) return contentPadding!;
    
    switch (size) {
      case AtomicListItemSize.small:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.sm,
          vertical: theme.spacing.xs,
        );
      case AtomicListItemSize.medium:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing.sm,
        );
      case AtomicListItemSize.large:
        return EdgeInsets.symmetric(
          horizontal: theme.spacing.lg,
          vertical: theme.spacing.md,
        );
    }
  }

  Color? _getTileColor(AtomicThemeData theme) {
    if (tileColor != null) return tileColor;
    
    switch (variant) {
      case AtomicListItemVariant.standard:
        return null;
      case AtomicListItemVariant.filled:
        return theme.colors.surface;
      case AtomicListItemVariant.outlined:
        return theme.colors.background;
      case AtomicListItemVariant.elevated:
        return theme.colors.surface;
    }
  }

  Color? _getSelectedTileColor(AtomicThemeData theme) {
    if (selectedTileColor != null) return selectedTileColor;
    return theme.colors.primary.withValues(alpha: 0.1);
  }

  double _getHorizontalTitleGap() {
    switch (size) {
      case AtomicListItemSize.small:
        return 12;
      case AtomicListItemSize.medium:
        return 16;
      case AtomicListItemSize.large:
        return 20;
    }
  }

  double _getMinVerticalPadding() {
    switch (size) {
      case AtomicListItemSize.small:
        return 4;
      case AtomicListItemSize.medium:
        return 8;
      case AtomicListItemSize.large:
        return 12;
    }
  }

  double _getMinLeadingWidth() {
    switch (size) {
      case AtomicListItemSize.small:
        return 32;
      case AtomicListItemSize.medium:
        return 40;
      case AtomicListItemSize.large:
        return 48;
    }
  }

  ShapeBorder? _getShape(AtomicThemeData theme) {
    if (variant == AtomicListItemVariant.standard) return null;
    
    return RoundedRectangleBorder(
      borderRadius: borderRadius ?? _getBorderRadius(theme),
    );
  }

  BorderRadius _getBorderRadius(AtomicThemeData theme) {
    switch (variant) {
      case AtomicListItemVariant.standard:
        return BorderRadius.zero;
      case AtomicListItemVariant.filled:
      case AtomicListItemVariant.outlined:
      case AtomicListItemVariant.elevated:
        return AtomicBorders.md;
    }
  }
}

enum AtomicListItemVariant {
  standard,    // Default Material ListTile
  filled,      // Filled background
  outlined,    // Outlined border
  elevated,    // Elevated with shadow
}

enum AtomicListItemSize {
  small,       // Compact size
  medium,      // Standard size
  large,       // Large size
}

class AtomicUserListItem extends StatelessWidget {
  const AtomicUserListItem({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.initials,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.badge,
    this.size = AtomicListItemSize.medium,
    this.variant = AtomicListItemVariant.standard,
  });

  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final String? initials;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final AtomicBadge? badge;
  final AtomicListItemSize size;
  final AtomicListItemVariant variant;

  @override
  Widget build(BuildContext context) {
    return AtomicListItem(
      leading: AtomicAvatar(
        name: initials ?? _getInitials(name),
        image: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        size: _getAvatarSize(),
      ),
      title: AtomicText(
        name,
        atomicStyle: AtomicTextStyle.bodyMedium,
      ),
      subtitle: subtitle != null 
          ? AtomicText(
              subtitle!,
              atomicStyle: AtomicTextStyle.bodySmall,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      selected: selected,
      badge: badge,
      size: size,
      variant: variant,
    );
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words[0].substring(0, 1).toUpperCase();
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }

  AtomicAvatarSize _getAvatarSize() {
    switch (size) {
      case AtomicListItemSize.small:
        return AtomicAvatarSize.small;
      case AtomicListItemSize.medium:
        return AtomicAvatarSize.medium;
      case AtomicListItemSize.large:
        return AtomicAvatarSize.large;
    }
  }
}

class AtomicIconListItem extends StatelessWidget {
  const AtomicIconListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.iconColor,
    this.backgroundColor,
    this.size = AtomicListItemSize.medium,
    this.variant = AtomicListItemVariant.standard,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final Color? iconColor;
  final Color? backgroundColor;
  final AtomicListItemSize size;
  final AtomicListItemVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    return AtomicListItem(
      leading: Container(
        width: _getIconContainerSize(),
        height: _getIconContainerSize(),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: AtomicIcon(
          icon: icon,
          color: iconColor ?? theme.colors.primary,
          size: _getIconSize(),
        ),
      ),
      title: AtomicText(
        title,
        atomicStyle: AtomicTextStyle.bodyMedium,
      ),
      subtitle: subtitle != null
          ? AtomicText(
              subtitle!,
              atomicStyle: AtomicTextStyle.bodySmall,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      selected: selected,
      size: size,
      variant: variant,
    );
  }

  double _getIconContainerSize() {
    switch (size) {
      case AtomicListItemSize.small:
        return 32;
      case AtomicListItemSize.medium:
        return 40;
      case AtomicListItemSize.large:
        return 48;
    }
  }

  AtomicIconSize _getIconSize() {
    switch (size) {
      case AtomicListItemSize.small:
        return AtomicIconSize.small;
      case AtomicListItemSize.medium:
        return AtomicIconSize.medium;
      case AtomicListItemSize.large:
        return AtomicIconSize.large;
    }
  }
} 