import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show ImageFilter;
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_icon_button.dart';

class AtomicAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AtomicAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.foregroundColor,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.variant = AtomicAppBarVariant.standard,
    this.size = AtomicAppBarSize.medium,
    this.gradient,
    this.blur = false,
    this.showBackButton = true,
    this.onBackPressed,
  });

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final double? toolbarHeight;
  final double? leadingWidth;

  final AtomicAppBarVariant variant;
  final AtomicAppBarSize size;
  final Gradient? gradient;
  final bool blur;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    
    Widget appBar = AppBar(
      leading: _buildLeading(context, theme),
      automaticallyImplyLeading: automaticallyImplyLeading && leading == null,
      title: _buildTitle(theme),
      actions: _buildActions(theme),
      flexibleSpace: _buildFlexibleSpace(theme),
      bottom: bottom,
      elevation: _getElevation(),
      shadowColor: shadowColor ?? _getShadowColor(theme),
      surfaceTintColor: surfaceTintColor,
      backgroundColor: _getBackgroundColor(theme),
      foregroundColor: _getForegroundColor(theme),
      primary: primary,
      centerTitle: _getCenterTitle(context),
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: _getToolbarHeight(),
      leadingWidth: leadingWidth,
      systemOverlayStyle: _getSystemOverlayStyle(theme),
    );

    if (blur) {
      appBar = ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: appBar,
        ),
      );
    }

    return appBar;
  }

  Widget? _buildLeading(BuildContext context, AtomicThemeData theme) {
    if (leading != null) return leading;
    
    if (showBackButton && Navigator.of(context).canPop()) {
      return AtomicIconButton(
        icon: Icons.arrow_back,
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        variant: AtomicIconButtonVariant.ghost,
        size: _getIconButtonSize(),
      );
    }
    
    return null;
  }

  Widget? _buildTitle(AtomicThemeData theme) {
    if (title == null) return null;
    
    if (title is String) {
      return AtomicText(
        title as String,
        atomicStyle: _getTitleStyle(),
      );
    }
    
    return title;
  }

  List<Widget>? _buildActions(AtomicThemeData theme) {
    if (actions == null) return null;
    
    return actions!.map((action) {
      if (action is AtomicIconButton) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: action,
        );
      }
      return action;
    }).toList();
  }

  Widget? _buildFlexibleSpace(AtomicThemeData theme) {
    if (flexibleSpace != null) return flexibleSpace;
    
    if (gradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      );
    }
    
    return null;
  }

  double? _getElevation() {
    if (elevation != null) return elevation;
    
    switch (variant) {
      case AtomicAppBarVariant.standard:
        return 0;
      case AtomicAppBarVariant.elevated:
        return 4;
      case AtomicAppBarVariant.surface:
        return 2;
      case AtomicAppBarVariant.transparent:
        return 0;
    }
  }

  Color? _getShadowColor(AtomicThemeData theme) {
    switch (variant) {
      case AtomicAppBarVariant.standard:
      case AtomicAppBarVariant.surface:
        return AtomicColors.shadowColor;
      case AtomicAppBarVariant.elevated:
        return AtomicColors.shadowColor;
      case AtomicAppBarVariant.transparent:
        return Colors.transparent;
    }
  }

  Color? _getBackgroundColor(AtomicThemeData theme) {
    if (backgroundColor != null) return backgroundColor;
    
    switch (variant) {
      case AtomicAppBarVariant.standard:
        return theme.colors.surface;
      case AtomicAppBarVariant.elevated:
        return theme.colors.surface;
      case AtomicAppBarVariant.surface:
        return theme.colors.background;
      case AtomicAppBarVariant.transparent:
        return Colors.transparent;
    }
  }

  Color? _getForegroundColor(AtomicThemeData theme) {
    if (foregroundColor != null) return foregroundColor;
    return theme.colors.textPrimary;
  }

  bool? _getCenterTitle(BuildContext context) {
    if (centerTitle != null) return centerTitle;
    
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  double? _getToolbarHeight() {
    if (toolbarHeight != null) return toolbarHeight;
    
    switch (size) {
      case AtomicAppBarSize.compact:
        return 48;
      case AtomicAppBarSize.medium:
        return kToolbarHeight; // 56
      case AtomicAppBarSize.large:
        return 64;
    }
  }

  AtomicTextStyle _getTitleStyle() {
    switch (size) {
      case AtomicAppBarSize.compact:
        return AtomicTextStyle.titleMedium;
      case AtomicAppBarSize.medium:
        return AtomicTextStyle.titleLarge;
      case AtomicAppBarSize.large:
        return AtomicTextStyle.headlineSmall;
    }
  }

  AtomicIconButtonSize _getIconButtonSize() {
    switch (size) {
      case AtomicAppBarSize.compact:
        return AtomicIconButtonSize.small;
      case AtomicAppBarSize.medium:
        return AtomicIconButtonSize.medium;
      case AtomicAppBarSize.large:
        return AtomicIconButtonSize.large;
    }
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(AtomicThemeData theme) {
    final backgroundColor = _getBackgroundColor(theme);
    final isDark = backgroundColor != null && backgroundColor.computeLuminance() < 0.5;
    
    return SystemUiOverlayStyle(
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );
  }

  @override
  Size get preferredSize {
    final height = _getToolbarHeight() ?? kToolbarHeight;
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(height + bottomHeight);
  }
}

enum AtomicAppBarVariant {
  standard,     // Default app bar
  elevated,     // Elevated with shadow
  surface,      // Surface tinted
  transparent,  // Transparent background
}

enum AtomicAppBarSize {
  compact,      // Compact height
  medium,       // Standard height
  large,        // Large height
}

class AtomicSimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AtomicSimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.centerTitle,
    this.backgroundColor,
    this.variant = AtomicAppBarVariant.standard,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool? centerTitle;
  final Color? backgroundColor;
  final AtomicAppBarVariant variant;

  @override
  Widget build(BuildContext context) {
    return AtomicAppBar(
      title: Text(title),
      actions: actions,
      showBackButton: showBackButton,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      variant: variant,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AtomicSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AtomicSearchAppBar({
    super.key,
    this.onSearch,
    this.onSearchChanged,
    this.hintText = 'Search...',
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
  });

  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onSearchChanged;
  final String hintText;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;

  @override
  State<AtomicSearchAppBar> createState() => _AtomicSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AtomicSearchAppBarState extends State<AtomicSearchAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AtomicAppBar(
      leading: widget.showBackButton
          ? AtomicIconButton(
              icon: _isSearching ? Icons.arrow_back : Icons.search,
              onPressed: () {
                if (_isSearching) {
                  setState(() {
                    _isSearching = false;
                    _controller.clear();
                  });
                } else {
                  setState(() {
                    _isSearching = true;
                  });
                }
              },
              variant: AtomicIconButtonVariant.ghost,
            )
          : null,
      title: _isSearching
          ? TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  color: AtomicColors.textSecondary,
                ),
              ),
              style: const TextStyle(
                color: AtomicColors.textPrimary,
              ),
              onChanged: widget.onSearchChanged,
              onSubmitted: widget.onSearch,
            )
          : const AtomicText(
              'Search',
              atomicStyle: AtomicTextStyle.titleLarge,
            ),
      actions: _isSearching
          ? [
              if (_controller.text.isNotEmpty)
                AtomicIconButton(
                  icon: Icons.clear,
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged?.call('');
                  },
                  variant: AtomicIconButtonVariant.ghost,
                ),
            ]
          : widget.actions,
      backgroundColor: widget.backgroundColor,
    );
  }
} 