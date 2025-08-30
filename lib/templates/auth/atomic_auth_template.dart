import 'package:flutter/material.dart';
import 'package:atomic_flutter_kit/atoms/containers/atomic_card.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/utilities/atomic_responsive.dart';

/// A customizable template for authentication-related screens (login, register, etc.).
///
/// The [AtomicAuthTemplate] provides a consistent layout for authentication
/// flows, featuring a background gradient, optional logo, title, subtitle,
/// and a central content area (typically a form) within a card.
///
/// Features:
/// - Customizable background gradient.
/// - Optional logo widget.
/// - Customizable title and subtitle.
/// - Flexible content area ([child]) for forms or other widgets.
/// - Optional header and footer widgets.
/// - Adjustable maximum width for the content card.
/// - Customizable padding and card styling.
/// - Scrollable content for smaller screens or longer forms.
///
/// Example usage:
/// ```dart
/// AtomicAuthTemplate(
///   title: 'Welcome',
///   subtitle: 'Please log in to continue',
///   backgroundGradient: LinearGradient(
///     colors: [Colors.blue.shade800, Colors.blue.shade400],
///     begin: Alignment.topLeft,
///     end: Alignment.bottomRight,
///   ),
///   logoWidget: Image.asset('assets/app_logo.png', height: 80),
///   child: Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       TextField(decoration: InputDecoration(labelText: 'Email')),
///       SizedBox(height: 16),
///       TextField(decoration: InputDecoration(labelText: 'Password', obscureText: true)),
///       SizedBox(height: 24),
///       ElevatedButton(onPressed: () {}, child: Text('Login')),
///     ],
///   ),
/// )
/// ```
class AtomicAuthTemplate extends StatelessWidget {
  /// Creates an [AtomicAuthTemplate] widget.
  ///
  /// [child] is the main content of the template, typically an authentication form.
  /// [title] is the main title displayed on the screen.
  /// [subtitle] is a secondary title or message displayed below the main title.
  /// [headerWidget] is an optional custom widget to display above the logo/title area.
  /// [footerWidget] is an optional custom widget to display below the main content card.
  /// [backgroundGradient] is the background gradient for the entire screen.
  /// [showLogo] if true, displays a default or custom logo. Defaults to true.
  /// [logoWidget] is an optional custom widget to use as the logo. Overrides the default logo.
  /// [maxWidth] specifies the maximum width of the central content card. Defaults to 400.
  /// [padding] is the internal padding around the central content card.s
  /// [cardElevation] controls the shadow of the central content card. Defaults to 0.
  /// [cardColor] is the background color of the central content card.
  /// [scrollable] if true, the content area will be scrollable. Defaults to true.
  const AtomicAuthTemplate({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.headerWidget,
    this.footerWidget,
    this.backgroundGradient,
    this.showLogo = true,
    this.logoWidget,
    this.maxWidth = 400,
    this.padding,
    this.cardElevation = 0,
    this.cardColor,
    this.scrollable = true,
  });

  /// The main content of the template, typically an authentication form.
  final Widget child;

  /// The main title displayed on the screen.
  final String? title;

  /// A secondary title or message displayed below the main title.
  final String? subtitle;

  /// An optional custom widget to display above the logo/title area.
  final Widget? headerWidget;

  /// An optional custom widget to display below the main content card.
  final Widget? footerWidget;

  /// The background gradient for the entire screen.
  final Gradient? backgroundGradient;

  /// If true, displays a default or custom logo. Defaults to true.
  final bool showLogo;

  /// An optional custom widget to use as the logo. Overrides the default logo.
  final Widget? logoWidget;

  /// The maximum width of the central content card. Defaults to 400.
  final double maxWidth;

  /// The internal padding around the central content card.
  final EdgeInsetsGeometry? padding;

  /// Controls the shadow of the central content card. Defaults to 0.
  final double cardElevation;

  /// The background color of the central content card.
  final Color? cardColor;

  /// If true, the content area will be scrollable. Defaults to true.
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient ?? _defaultGradient,
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: scrollable
                  ? SingleChildScrollView(
                      padding: padding ?? _getDefaultPadding(theme, context),
                      child: _buildContent(theme, screenHeight),
                    )
                  : Padding(
                      padding: padding ?? _getDefaultPadding(theme, context),
                      child: _buildContent(theme, screenHeight),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AtomicThemeData theme, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLogo || headerWidget != null) _buildHeader(theme),
        if (showLogo || headerWidget != null)
          SizedBox(height: theme.spacing.xl),
        _buildCard(theme),
        if (footerWidget != null) ...[
          SizedBox(height: theme.spacing.xl),
          footerWidget!,
        ],
      ],
    );
  }

  Widget _buildHeader(AtomicThemeData theme) {
    return Column(
      children: [
        if (showLogo) logoWidget ?? _buildDefaultLogo(theme),
        if (showLogo && (title != null || subtitle != null))
          SizedBox(height: theme.spacing.lg),
        if (title != null) ...[
          Text(
            title!,
            style: theme.typography.headlineLarge.copyWith(
              color: theme.colors.textInverse,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) SizedBox(height: theme.spacing.sm),
        ],
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.typography.bodyLarge.copyWith(
              color: theme.colors.textInverse.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        if (headerWidget != null) headerWidget!,
      ],
    );
  }

  Widget _buildCard(AtomicThemeData theme) {
    return AtomicCard(
      padding: EdgeInsets.all(theme.spacing.xl),
      color: cardColor ?? theme.colors.surface,
      shadow:
          cardElevation > 0 ? AtomicCardShadow.medium : AtomicCardShadow.none,
      child: child,
    );
  }

  Widget _buildDefaultLogo(AtomicThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colors.textInverse.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(theme.borders.radiusXl),
        border: Border.all(
          color: theme.colors.textInverse.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.lock_outline,
        color: theme.colors.textInverse,
        size: 40,
      ),
    );
  }

  EdgeInsetsGeometry _getDefaultPadding(
      AtomicThemeData theme, BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: AtomicResponsive.isMobile(context)
          ? theme.spacing.lg
          : theme.spacing.xl,
      vertical: theme.spacing.lg,
    );
  }

  Gradient get _defaultGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF667eea),
          Color(0xFF764ba2),
        ],
      );
}
