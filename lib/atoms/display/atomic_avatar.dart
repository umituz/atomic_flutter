import 'package:flutter/material.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/typography/atomic_typography.dart';
import '../../tokens/shadows/atomic_shadows.dart';

/// Atomic Avatar Component
/// User avatars with image, initials, or icon support
class AtomicAvatar extends StatelessWidget {
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

  final ImageProvider? image;
  final String? name;
  final IconData? icon;
  final AtomicAvatarSize size;
  final AtomicAvatarShape shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Border? border;
  final AtomicAvatarShadow shadow;
  final Widget? badge;
  final VoidCallback? onTap;
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

/// Avatar Group Component
/// Display multiple avatars in a stack
class AtomicAvatarGroup extends StatelessWidget {
  const AtomicAvatarGroup({
    super.key,
    required this.avatars,
    this.size = AtomicAvatarSize.medium,
    this.maxDisplay = 4,
    this.overlap = 0.6,
    this.borderColor,
    this.borderWidth = 2,
  });

  final List<AtomicAvatar> avatars;
  final AtomicAvatarSize size;
  final int maxDisplay;
  final double overlap;
  final Color? borderColor;
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
      width: offset * (displayAvatars.length - 1) + diameter + 
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
          }).toList(),
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

/// Avatar size options
enum AtomicAvatarSize {
  tiny,
  small,
  medium,
  large,
  huge,
  massive,
}

/// Avatar shape options
enum AtomicAvatarShape {
  circle,
  square,
}

/// Avatar shadow options
enum AtomicAvatarShadow {
  none,
  small,
  medium,
  large,
}
