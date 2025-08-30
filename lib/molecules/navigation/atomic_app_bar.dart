import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show ImageFilter;
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/atoms/display/atomic_text.dart';
import 'package:atomic_flutter_kit/atoms/buttons/atomic_icon_button.dart';

/// A customizable app bar component that integrates with the Atomic Design System.
///
/// The [AtomicAppBar] extends Flutter's [AppBar] with additional customization
/// options for variants, sizes, and visual effects like gradients and blur.
/// It provides a consistent navigation and branding experience across the application.
///
/// Features:
/// - Customizable leading, title, and actions.
/// - Multiple visual variants ([AtomicAppBarVariant]): standard, elevated, surface, transparent.
/// - Three predefined sizes ([AtomicAppBarSize]): compact, medium, large.
/// - Optional gradient background.
/// - Optional blur effect for the background.
/// - Automatic back button handling.
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// AtomicAppBar(
///   title: AtomicText('My App'),
///   actions: [
///     AtomicIconButton(
///       icon: Icons.settings,
///       onPressed: () {
///         print('Settings tapped!');
///       },
///     ),
///   ],
///   variant: AtomicAppBarVariant.elevated,
///   size: AtomicAppBarSize.large,
///   showBackButton: true,
/// )
/// ```
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

  /// A widget to display before the title.
  final Widget? leading;

  /// Controls whether a back button is automatically added.
  final bool automaticallyImplyLeading;

  /// The primary widget displayed in the app bar.
  final Widget? title;

  /// Widgets to display after the title.
  final List<Widget>? actions;

  /// A widget to display behind the app bar.
  final Widget? flexibleSpace;

  /// A widget to display at the bottom of the app bar.
  final PreferredSizeWidget? bottom;

  /// Controls the shadow below the app bar.
  final double? elevation;

  /// The color of the shadow.
  final Color? shadowColor;

  /// The surface tint color.
  final Color? surfaceTintColor;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// The color of the text and icons.
  final Color? foregroundColor;

  /// If true, the app bar is on the primary [Scaffold].
  final bool primary;

  /// Controls whether the title is centered.
  final bool? centerTitle;

  /// Excludes the header from semantics.
  final bool excludeHeaderSemantics;

  /// Controls the space around the title.
  final double? titleSpacing;

  /// Controls the opacity of the toolbar.
  final double toolbarOpacity;

  /// Controls the opacity of the bottom widget.
  final double bottomOpacity;

  /// Specifies the height of the toolbar.
  final double? toolbarHeight;

  /// Specifies the width of the leading widget area.
  final double? leadingWidth;

  /// Defines the visual style of the app bar. Defaults to [AtomicAppBarVariant.standard].
  final AtomicAppBarVariant variant;

  /// Defines the size of the app bar. Defaults to [AtomicAppBarSize.medium].
  final AtomicAppBarSize size;

  /// An optional gradient to paint behind the app bar.
  final Gradient? gradient;

  /// If true, applies a blur effect to the background. Defaults to false.
  final bool blur;

  /// If true, a back button is automatically added if possible. Defaults to true.
  final bool showBackButton;

  /// The callback function executed when the back button is pressed.
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
    final isDark =
        backgroundColor != null && backgroundColor.computeLuminance() < 0.5;

    return SystemUiOverlayStyle(
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
  }

  @override
  Size get preferredSize {
    final height = _getToolbarHeight() ?? kToolbarHeight;
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(height + bottomHeight);
  }
}

/// Defines the visual variants for an [AtomicAppBar].
enum AtomicAppBarVariant {
  /// Standard app bar appearance.
  standard,

  /// App bar with an elevated appearance (shadow).
  elevated,

  /// App bar with a surface-tinted background.
  surface,

  /// App bar with a transparent background.
  transparent,
}

/// Defines the predefined sizes for an [AtomicAppBar].
enum AtomicAppBarSize {
  /// A compact app bar.
  compact,

  /// A standard-sized app bar.
  medium,

  /// A large app bar.
  large,
}

/// A simplified app bar component for common use cases.
///
/// The [AtomicSimpleAppBar] provides a basic app bar with a title, optional
/// actions, and a back button. It's a convenient wrapper around [AtomicAppBar]
/// for quick setup of common app bar configurations.
///
/// Example usage:
/// ```dart
/// AtomicSimpleAppBar(
///   title: 'My Simple Screen',
///   showBackButton: true,
///   actions: [
///     IconButton(
///       icon: Icon(Icons.share),
///       onPressed: () {},
///     ),
///   ],
/// )
/// ```
class AtomicSimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [AtomicSimpleAppBar] widget.
  ///
  /// [title] is the text title of the app bar.
  /// [actions] are widgets to display after the title.
  /// [showBackButton] if true, a back button is automatically added. Defaults to true.
  /// [centerTitle] controls whether the title is centered.
  /// [backgroundColor] is the background color of the app bar.
  /// [variant] defines the visual style of the app bar. Defaults to [AtomicAppBarVariant.standard].
  const AtomicSimpleAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.centerTitle,
    this.backgroundColor,
    this.variant = AtomicAppBarVariant.standard,
  });

  /// The text title of the app bar.
  final String title;

  /// Widgets to display after the title.
  final List<Widget>? actions;

  /// If true, a back button is automatically added. Defaults to true.
  final bool showBackButton;

  /// Controls whether the title is centered.
  final bool? centerTitle;

  /// The background color of the app bar.
  final Color? backgroundColor;

  /// Defines the visual style of the app bar. Defaults to [AtomicAppBarVariant.standard].
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

/// A customizable app bar component with search functionality.
///
/// The [AtomicSearchAppBar] provides an app bar that integrates a search field
/// for filtering content. It supports a hint text, back button, and actions.
///
/// Features:
/// - Integrated search text field.
/// - Customizable hint text for the search field.
/// - Optional back button.
/// - Customizable actions.
/// - Callbacks for search input changes and submission.
/// - Integrates with the theme for consistent styling.
///
/// Example usage:
/// ```dart
/// AtomicSearchAppBar(
///   hintText: 'Search items...',
///   onSearchChanged: (query) {
///     print('Search query: $query');
///   },
///   onSearch: (query) {
///     print('Search submitted: $query');
///   },
///   showBackButton: true,
/// )
/// ```
class AtomicSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates an [AtomicSearchAppBar] widget.
  ///
  /// [onSearch] is the callback function executed when the search is submitted.
  /// [onSearchChanged] is the callback function executed when the search text changes.
  /// [hintText] is the hint text displayed in the search field. Defaults to 'Search...'.
  /// [showBackButton] if true, a back button is automatically added. Defaults to true.
  /// [actions] are widgets to display after the search field.
  /// [backgroundColor] is the background color of the app bar.
  const AtomicSearchAppBar({
    super.key,
    this.onSearch,
    this.onSearchChanged,
    this.hintText = 'Search...',
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
  });

  /// The callback function executed when the search is submitted.
  final ValueChanged<String>? onSearch;

  /// The callback function executed when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// The hint text displayed in the search field. Defaults to 'Search...'.
  final String hintText;

  /// If true, a back button is automatically added. Defaults to true.
  final bool showBackButton;

  /// Widgets to display after the search field.
  final List<Widget>? actions;

  /// The background color of the app bar.
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
