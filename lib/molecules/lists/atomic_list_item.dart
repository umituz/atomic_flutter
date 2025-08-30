import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/icons/atomic_icon.dart';
import 'package:atomic_flutter_kit/atoms/feedback/atomic_badge.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_avatar.dart';

/// A customizable list tile component for displaying items in a list.
///
/// The [AtomicListItem] provides a flexible and theme-integrated way to display
/// various types of content in a list format. It extends Flutter's [ListTile]
/// with additional customization options for variants, sizes, and visual feedback.
///
/// Features:
/// - Customizable leading, title, subtitle, and trailing widgets.
/// - Optional tap and long-press interactions.
/// - Support for selected and enabled states.
/// - Multiple visual variants ([AtomicListItemVariant]): standard, filled, outlined, elevated.
/// - Three predefined sizes ([AtomicListItemSize]): small, medium, large.
/// - Customizable content padding, tile color, and horizontal title gap.
/// - Optional badge for leading content.
/// - Optional divider at the bottom.
///
/// Example usage:
/// ```dart
/// // Basic list item
/// AtomicListItem(
///   leading: Icon(Icons.person),
///   title: Text('User Profile'),
///   subtitle: Text('View your personal information'),
///   trailing: Icon(Icons.arrow_forward_ios),
///   onTap: () {
///     print('Profile tapped!');
///   },
/// )
///
/// // Selected and elevated list item with badge
/// AtomicListItem(
///   leading: AtomicAvatar(name: 'JD'),
///   title: Text('John Doe'),
///   subtitle: Text('Online'),
///   selected: true,
///   variant: AtomicListItemVariant.elevated,
///   badge: AtomicBadge(count: 3, variant: AtomicBadgeVariant.error),
///   showDivider: true,
/// )
/// ```
class AtomicListItem extends StatelessWidget {
  /// Creates an [AtomicListItem] widget.
  ///
  /// [leading] is a widget to display before the title.
  /// [title] is the primary content of the list item.
  /// [subtitle] is additional content displayed below the title.
  /// [trailing] is a widget to display after the title.
  /// [onTap] is the callback function executed when the list item is tapped.
  /// [onLongPress] is the callback function executed when the list item is long-pressed.
  /// [selected] if true, the list item is visually marked as selected. Defaults to false.
  /// [enabled] if true, the list item is interactive. Defaults to true.
  /// [dense] if true, the list item will have less vertical padding. Defaults to false.
  /// [visualDensity] defines the compactnes of the list item.
  /// [contentPadding] is the internal padding of the list item.
  /// [tileColor] is the background color of the list item.
  /// [selectedTileColor] is the background color when the list item is selected.
  /// [enableFeedback] if true, haptic feedback is enabled on tap. Defaults to true.
  /// [horizontalTitleGap] is the horizontal space between the title and leading/trailing widgets.
  /// [minVerticalPadding] is the minimum vertical padding.
  /// [minLeadingWidth] is the minimum width of the leading widget.
  /// [titleAlignment] aligns the title and subtitle.
  /// [splashColor] is the splash color when tapped.
  /// [focusColor] is the focus color.
  /// [hoverColor] is the hover color.
  /// [autofocus] if true, the list item gains focus automatically. Defaults to false.
  /// [shape] defines the shape of the list item.
  /// [variant] defines the visual style of the list item. Defaults to [AtomicListItemVariant.standard].
  /// [size] defines the size of the list item. Defaults to [AtomicListItemSize.medium].
  /// [margin] is the external margin around the list item.
  /// [borderRadius] is the border radius of the list item.
  /// [showDivider] if true, a divider is displayed below the list item. Defaults to false.
  /// [badge] is an optional [AtomicBadge] to display on the leading widget.
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

  /// A widget to display before the title.
  final Widget? leading;

  /// The primary content of the list item.
  final Widget? title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display after the title.
  final Widget? trailing;

  /// The callback function executed when the list item is tapped.
  final VoidCallback? onTap;

  /// The callback function executed when the list item is long-pressed.
  final VoidCallback? onLongPress;

  /// If true, the list item is visually marked as selected. Defaults to false.
  final bool selected;

  /// If true, the list item is interactive. Defaults to true.
  final bool enabled;

  /// If true, the list item will have less vertical padding. Defaults to false.
  final bool dense;

  /// Defines the compactnes of the list item.
  final VisualDensity? visualDensity;

  /// The internal padding of the list item.
  final EdgeInsetsGeometry? contentPadding;

  /// The background color of the list item.
  final Color? tileColor;

  /// The background color when the list item is selected.
  final Color? selectedTileColor;

  /// If true, haptic feedback is enabled on tap. Defaults to true.
  final bool enableFeedback;

  /// The horizontal space between the title and leading/trailing widgets.
  final double? horizontalTitleGap;

  /// The minimum vertical padding.
  final double? minVerticalPadding;

  /// The minimum width of the leading widget.
  final double? minLeadingWidth;

  /// Aligns the title and subtitle.
  final ListTileTitleAlignment? titleAlignment;

  /// The splash color when tapped.
  final Color? splashColor;

  /// The focus color.
  final Color? focusColor;

  /// The hover color.
  final Color? hoverColor;

  /// If true, the list item gains focus automatically. Defaults to false.
  final bool autofocus;

  /// Defines the shape of the list item.
  final ShapeBorder? shape;

  /// Defines the visual style of the list item. Defaults to [AtomicListItemVariant.standard].
  final AtomicListItemVariant variant;

  /// Defines the size of the list item. Defaults to [AtomicListItemSize.medium].
  final AtomicListItemSize size;

  /// The external margin around the list item.
  final EdgeInsetsGeometry? margin;

  /// The border radius of the list item.
  final BorderRadius? borderRadius;

  /// If true, a divider is displayed below the list item. Defaults to false.
  final bool showDivider;

  /// An optional [AtomicBadge] to display on the leading widget.
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

/// Defines the visual variants for an [AtomicListItem].
enum AtomicListItemVariant {
  /// Standard Material Design list tile appearance.
  standard,

  /// A list item with a filled background.
  filled,

  /// A list item with an outlined border.
  outlined,

  /// A list item with an elevated appearance (shadow).
  elevated,
}

/// Defines the predefined sizes for an [AtomicListItem].
enum AtomicListItemSize {
  /// A compact list item.
  small,

  /// A standard-sized list item.
  medium,

  /// A large list item.
  large,
}

/// A list item component specifically designed for displaying user information.
///
/// The [AtomicUserListItem] combines an [AtomicListItem] with an [AtomicAvatar]
/// to present user details such as name, optional subtitle, and avatar.
///
/// Features:
/// - Displays user's name and optional subtitle.
/// - Automatically generates an [AtomicAvatar] from a URL or initials.
/// - Customizable size and variant.
/// - Optional trailing widget and badge.
/// - Tap interaction.
///
/// Example usage:
/// ```dart
/// AtomicUserListItem(
///   name: 'Jane Doe',
///   subtitle: 'Software Engineer',
///   avatarUrl: 'https://example.com/jane.jpg',
///   onTap: () {
///     print('Jane Doe profile tapped!');
///   },
/// )
/// ```
class AtomicUserListItem extends StatelessWidget {
  /// Creates an [AtomicUserListItem] widget.
  ///
  /// [name] is the user's name.
  /// [subtitle] is an optional subtitle for the user (e.g., job title).
  /// [avatarUrl] is the URL for the user's avatar image.
  /// [initials] are optional initials to display if no avatar URL is provided.
  /// [trailing] is an optional widget to display at the end of the list item.
  /// [onTap] is the callback function executed when the list item is tapped.
  /// [selected] if true, the list item is visually marked as selected. Defaults to false.
  /// [badge] is an optional [AtomicBadge] to display on the avatar.
  /// [size] defines the size of the list item. Defaults to [AtomicListItemSize.medium].
  /// [variant] defines the visual style of the list item. Defaults to [AtomicListItemVariant.standard].
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

  /// The user's name.
  final String name;

  /// An optional subtitle for the user (e.g., job title, status).
  final String? subtitle;

  /// The URL for the user's avatar image.
  final String? avatarUrl;

  /// Optional initials to display if no avatar URL is provided.
  final String? initials;

  /// An optional widget to display at the end of the list item.
  final Widget? trailing;

  /// The callback function executed when the list item is tapped.
  final VoidCallback? onTap;

  /// If true, the list item is visually marked as selected. Defaults to false.
  final bool selected;

  /// An optional [AtomicBadge] to display on the avatar.
  final AtomicBadge? badge;

  /// Defines the size of the list item. Defaults to [AtomicListItemSize.medium].
  final AtomicListItemSize size;

  /// Defines the visual style of the list item. Defaults to [AtomicListItemVariant.standard].
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
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'
        .toUpperCase();
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

/// A list item component specifically designed for displaying an icon and text.
///
/// The [AtomicIconListItem] combines an [AtomicListItem] with a styled icon
/// to present information with a clear visual cue.
///
/// Features:
/// - Displays a leading icon with customizable color and background.
/// - Displays a title and optional subtitle.
/// - Customizable size and variant.
/// - Optional trailing widget.
/// - Tap interaction.
///
/// Example usage:
/// ```dart
/// AtomicIconListItem(
///   icon: Icons.settings,
///   title: 'Settings',
///   subtitle: 'Adjust application preferences',
///   onTap: () {
///     print('Settings tapped!');
///   },
/// )
/// ```
class AtomicIconListItem extends StatelessWidget {
  /// Creates an [AtomicIconListItem] widget.
  ///
  /// [icon] is the leading icon for the list item.
  /// [title] is the primary text content.
  /// [subtitle] is an optional secondary text content.
  /// [trailing] is an optional widget to display at the end.
  /// [onTap] is the callback function executed when the list item is tapped.
  /// [selected] if true, the list item is visually marked as selected. Defaults to false.
  /// [iconColor] is the color of the leading icon.
  /// [backgroundColor] is the background color of the icon container.
  /// [size] defines the size of the list item. Defaults to [AtomicListItemSize.medium].
  /// [variant] defines the visual style of the list item. Defaults to [AtomicListItemVariant.standard].
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

  /// The leading icon for the list item.
  final IconData icon;

  /// The primary text content of the list item.
  final String title;

  /// An optional secondary text content.
  final String? subtitle;

  /// An optional widget to display at the end of the list item.
  final Widget? trailing;

  /// The callback function executed when the list item is tapped.
  final VoidCallback? onTap;

  /// If true, the list item is visually marked as selected. Defaults to false.
  final bool selected;

  /// The color of the leading icon.
  final Color? iconColor;

  /// The background color of the icon container.
  final Color? backgroundColor;

  /// Defines the size of the list item. Defaults to [AtomicListItemSize.medium].
  final AtomicListItemSize size;

  /// Defines the visual style of the list item. Defaults to [AtomicListItemVariant.standard].
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
