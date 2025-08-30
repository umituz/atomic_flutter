import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/shadows/atomic_shadows.dart';

/// A customizable avatar component for displaying user profiles, icons, or initials.
///
/// The [AtomicAvatar] provides a flexible way to represent users or entities
/// with an image, initials from a name, or a fallback icon. It supports various
/// sizes, shapes, background/foreground colors, borders, and shadow effects.
///
/// Features:
/// - Display an [ImageProvider] (e.g., NetworkImage, AssetImage).
/// - Generate initials from a [name] if no image is provided.
/// - Display a custom [icon] or a [fallbackIcon].
/// - Customizable [size] ([AtomicAvatarSize]) and [shape] ([AtomicAvatarShape]).
/// - Adjustable background and foreground colors.
/// - Optional border and shadow effects.
/// - Support for a badge widget and tap interactions.
///
/// Example usage:
/// ```dart
/// AtomicAvatar(
///   name: 'John Doe',
///   size: AtomicAvatarSize.large,
///   shape: AtomicAvatarShape.circle,
///   backgroundColor: Colors.blue.shade100,
///   foregroundColor: Colors.blue.shade700,
///   onTap: () {
///     print('Avatar tapped!');
///   },
/// )
///
/// AtomicAvatar(
///   image: NetworkImage('https://example.com/avatar.jpg'),
///   size: AtomicAvatarSize.medium,
///   shape: AtomicAvatarShape.square,
///   badge: Positioned(
///     bottom: 0,
///     right: 0,
///     child: Container(
///       width: 10,
///       height: 10,
///       decoration: BoxDecoration(
///         color: Colors.green,
///         shape: BoxShape.circle,
///       ),
///     ),
///   ),
/// )
/// ```
class AtomicAvatar extends StatelessWidget {
  /// Creates an [AtomicAvatar].
  ///
  /// [image] is the image to display. If null, [name] or [icon] will be used.
  /// [name] is used to generate initials if [image] is null.
  /// [icon] is a custom icon to display if [image] and [name] are null.
  /// [size] defines the overall size of the avatar. Defaults to [AtomicAvatarSize.medium].
  /// [shape] defines the shape of the avatar. Defaults to [AtomicAvatarShape.circle].
  /// [backgroundColor] is the background color of the avatar.
  /// [foregroundColor] is the color of the initials or icon.
  /// [border] is an optional border for the avatar.
  /// [shadow] defines the shadow effect of the avatar. Defaults to [AtomicAvatarShadow.none].
  /// [badge] is an optional widget to display as a badge on the avatar.
  /// [onTap] is the callback function executed when the avatar is tapped.
  /// [fallbackIcon] is the icon displayed if no image, name, or custom icon is provided. Defaults to [Icons.person].
  const AtomicAvatar({
    super.key,
    this.image,
    this.name,
    this.icon,
    this.size = AtomicAvatarSize.medium,
    this.shape = AtomicAvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
    this.shadow = AtomicAvatarShadow.none,
    this.badge,
    this.onTap,
    this.fallbackIcon = Icons.person,
  });

  /// The image to display in the avatar. If null, initials or an icon will be used.
  final ImageProvider? image;

  /// The name used to generate initials if [image] is null.
  final String? name;

  /// A custom icon to display if [image] and [name] are null.
  final IconData? icon;

  /// The size of the avatar. Defaults to [AtomicAvatarSize.medium].
  final AtomicAvatarSize size;

  /// The shape of the avatar. Defaults to [AtomicAvatarShape.circle].
  final AtomicAvatarShape shape;

  /// The background color of the avatar.
  final Color? backgroundColor;

  /// The color of the initials or icon displayed in the avatar.
  final Color? foregroundColor;

  /// An optional border for the avatar.
  final Border? border;

  /// Defines the shadow effect of the avatar. Defaults to [AtomicAvatarShadow.none].
  final AtomicAvatarShadow shadow;

  /// An optional widget to display as a badge on the avatar (e.g., online status).
  final Widget? badge;

  /// The callback function executed when the avatar is tapped.
  final VoidCallback? onTap;

  /// The icon displayed if no image, name, or custom icon is provided. Defaults to [Icons.person].
  final IconData fallbackIcon;

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';

    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '?';
    }

    final first = words[0].isNotEmpty ? words[0][0].toUpperCase() : '';
    final last = words[words.length - 1].isNotEmpty
        ? words[words.length - 1][0].toUpperCase()
        : '';

    return '$first$last';
  }

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final diameter = _getDiameter();

    Widget avatar = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colors.primary,
        borderRadius: _getBorderRadius(),
        border: border ?? _getDefaultBorder(theme),
        boxShadow: _getShadow(),
        image: image != null
            ? DecorationImage(
                image: image!,
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: image == null
          ? Center(
              child: _buildContent(theme),
            )
          : null,
    );

    if (onTap != null) {
      avatar = InkWell(
        onTap: onTap,
        borderRadius: _getBorderRadius(),
        child: avatar,
      );
    }

    if (badge != null) {
      return Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: badge!,
          ),
        ],
      );
    }

    return avatar;
  }

  Widget _buildContent(AtomicThemeData theme) {
    if (icon != null) {
      return Icon(
        icon,
        size: _getIconSize(),
        color: foregroundColor ?? theme.colors.textInverse,
      );
    }

    if (name != null && name!.isNotEmpty) {
      return Text(
        _getInitials(name!),
        style: _getTextStyle(theme),
      );
    }

    return Icon(
      fallbackIcon,
      size: _getIconSize(),
      color: foregroundColor ?? theme.colors.textInverse,
    );
  }

  double _getDiameter() {
    switch (size) {
      case AtomicAvatarSize.tiny:
        return 24;
      case AtomicAvatarSize.small:
        return 32;
      case AtomicAvatarSize.medium:
        return 40;
      case AtomicAvatarSize.large:
        return 48;
      case AtomicAvatarSize.huge:
        return 64;
      case AtomicAvatarSize.massive:
        return 96;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AtomicAvatarSize.tiny:
        return 16;
      case AtomicAvatarSize.small:
        return 20;
      case AtomicAvatarSize.medium:
        return 24;
      case AtomicAvatarSize.large:
        return 28;
      case AtomicAvatarSize.huge:
        return 36;
      case AtomicAvatarSize.massive:
        return 48;
    }
  }

  TextStyle _getTextStyle(AtomicThemeData theme) {
    final TextStyle baseStyle;
    final double fontSize;

    switch (size) {
      case AtomicAvatarSize.tiny:
        fontSize = 10;
        baseStyle = theme.typography.labelSmall;
      case AtomicAvatarSize.small:
        fontSize = 12;
        baseStyle = theme.typography.labelSmall;
      case AtomicAvatarSize.medium:
        fontSize = 14;
        baseStyle = theme.typography.labelMedium;
      case AtomicAvatarSize.large:
        fontSize = 16;
        baseStyle = theme.typography.labelLarge;
      case AtomicAvatarSize.huge:
        fontSize = 20;
        baseStyle = theme.typography.titleMedium;
      case AtomicAvatarSize.massive:
        fontSize = 32;
        baseStyle = theme.typography.headlineMedium;
    }

    return baseStyle.copyWith(
      color: foregroundColor ?? theme.colors.textInverse,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
    );
  }

  BorderRadius _getBorderRadius() {
    switch (shape) {
      case AtomicAvatarShape.circle:
        return AtomicBorders.full;
      case AtomicAvatarShape.square:
        return AtomicBorders.md;
    }
  }

  Border? _getDefaultBorder(AtomicThemeData theme) {
    return Border.all(
      color: theme.colors.surface,
      width: 2,
    );
  }

  List<BoxShadow>? _getShadow() {
    switch (shadow) {
      case AtomicAvatarShadow.none:
        return null;
      case AtomicAvatarShadow.small:
        return AtomicShadows.sm;
      case AtomicAvatarShadow.medium:
        return AtomicShadows.md;
      case AtomicAvatarShadow.large:
        return AtomicShadows.lg;
    }
  }
}

/// A widget that displays a group of [AtomicAvatar]s, with an optional counter for remaining avatars.
///
/// This component is useful for showing multiple participants in a conversation,
/// members of a team, or any collection of users. It handles overlapping avatars
/// and can display a "+X" indicator for avatars beyond a specified display limit.
///
/// Example usage:
/// ```dart
/// AtomicAvatarGroup(
///   avatars: [
///     AtomicAvatar(name: 'Alice'),
///     AtomicAvatar(name: 'Bob'),
///     AtomicAvatar(name: 'Charlie'),
///     AtomicAvatar(name: 'David'),
///     AtomicAvatar(name: 'Eve'),
///   ],
///   size: AtomicAvatarSize.medium,
///   maxDisplay: 3, // Shows 3 avatars + a "+2" indicator
///   overlap: 0.5,
/// )
/// ```
class AtomicAvatarGroup extends StatelessWidget {
  /// Creates an [AtomicAvatarGroup].
  ///
  /// [avatars] is a list of [AtomicAvatar] widgets to display.
  /// [size] defines the size of the avatars within the group. Defaults to [AtomicAvatarSize.medium].
  /// [maxDisplay] is the maximum number of individual avatars to display before showing a "+X" indicator. Defaults to 4.
  /// [overlap] controls how much each avatar overlaps the previous one (0.0 to 1.0). Defaults to 0.6.
  /// [borderColor] is the color of the border around each avatar in the group.
  /// [borderWidth] is the width of the border around each avatar in the group. Defaults to 2.
  const AtomicAvatarGroup({
    super.key,
    required this.avatars,
    this.size = AtomicAvatarSize.medium,
    this.maxDisplay = 4,
    this.overlap = 0.6,
    this.borderColor,
    this.borderWidth = 2,
  });

  /// A list of [AtomicAvatar] widgets to display in the group.
  final List<AtomicAvatar> avatars;

  /// The size of the avatars within the group. Defaults to [AtomicAvatarSize.medium].
  final AtomicAvatarSize size;

  /// The maximum number of individual avatars to display before showing a "+X" indicator. Defaults to 4.
  final int maxDisplay;

  /// Controls how much each avatar overlaps the previous one (0.0 to 1.0).
  /// A value of 0.0 means no overlap, 1.0 means full overlap. Defaults to 0.6.
  final double overlap;

  /// The color of the border around each avatar in the group.
  final Color? borderColor;

  /// The width of the border around each avatar in the group. Defaults to 2.
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final displayAvatars = avatars.take(maxDisplay).toList();
    final remaining = avatars.length - maxDisplay;
    final diameter = _getDiameter();
    final offset = diameter * (1 - overlap);

    return SizedBox(
      height: diameter,
      width: offset * (displayAvatars.length - 1) +
          diameter +
          (remaining > 0 ? offset : 0),
      child: Stack(
        children: [
          ...displayAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;

            return Positioned(
              left: index * offset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? theme.colors.surface,
                    width: borderWidth,
                  ),
                ),
                child: AtomicAvatar(
                  image: avatar.image,
                  name: avatar.name,
                  icon: avatar.icon,
                  size: size,
                  shape: AtomicAvatarShape.circle,
                  backgroundColor: avatar.backgroundColor,
                  foregroundColor: avatar.foregroundColor,
                  border: null,
                ),
              ),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: displayAvatars.length * offset,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? theme.colors.surface,
                    width: borderWidth,
                  ),
                ),
                child: AtomicAvatar(
                  name: '+$remaining',
                  size: size,
                  shape: AtomicAvatarShape.circle,
                  backgroundColor: theme.colors.gray400,
                  foregroundColor: theme.colors.textInverse,
                  border: null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _getDiameter() {
    switch (size) {
      case AtomicAvatarSize.tiny:
        return 24;
      case AtomicAvatarSize.small:
        return 32;
      case AtomicAvatarSize.medium:
        return 40;
      case AtomicAvatarSize.large:
        return 48;
      case AtomicAvatarSize.huge:
        return 64;
      case AtomicAvatarSize.massive:
        return 96;
    }
  }
}

/// Defines the predefined sizes for an [AtomicAvatar].
enum AtomicAvatarSize {
  /// A very small avatar (24x24).
  tiny,

  /// A small avatar (32x32).
  small,

  /// A medium avatar (40x40), often used as a default.
  medium,

  /// A large avatar (48x48).
  large,

  /// A very large avatar (64x64).
  huge,

  /// An extra large avatar (96x96).
  massive,
}

/// Defines the predefined shapes for an [AtomicAvatar].
enum AtomicAvatarShape {
  /// A circular avatar.
  circle,

  /// A square avatar with rounded corners.
  square,
}

/// Defines the shadow elevation options for an [AtomicAvatar].
enum AtomicAvatarShadow {
  /// No shadow.
  none,

  /// A small shadow elevation.
  small,

  /// A medium shadow elevation.
  medium,

  /// A large shadow elevation.
  large,
}
