import 'package:flutter/material.dart';
import '../../atoms/containers/atomic_card.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../utilities/atomic_responsive.dart';

/// Atomic Auth Template
/// Reusable template for authentication screens (login, register, forgot password, etc.)
class AtomicAuthTemplate extends StatelessWidget {
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

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? headerWidget;
  final Widget? footerWidget;
  final Gradient? backgroundGradient;
  final bool showLogo;
  final Widget? logoWidget;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final double cardElevation;
  final Color? cardColor;
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
        // Header/Logo Section
        if (showLogo || headerWidget != null)
          _buildHeader(theme),
        
        if (showLogo || headerWidget != null)
          SizedBox(height: theme.spacing.xl),
        
        // Main Card
        _buildCard(theme),
        
        // Footer Section
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
        // Logo
        if (showLogo)
          logoWidget ?? _buildDefaultLogo(theme),
        
        if (showLogo && (title != null || subtitle != null))
          SizedBox(height: theme.spacing.lg),
        
        // Title & Subtitle
        if (title != null) ...[
          Text(
            title!,
            style: theme.typography.headlineLarge.copyWith(
              color: theme.colors.textInverse,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null)
            SizedBox(height: theme.spacing.sm),
        ],
        
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.typography.bodyLarge.copyWith(
              color: theme.colors.textInverse.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        
        // Custom header widget
        if (headerWidget != null)
          headerWidget!,
      ],
    );
  }

  Widget _buildCard(AtomicThemeData theme) {
    return AtomicCard(
      padding: EdgeInsets.all(theme.spacing.xl),
      color: cardColor ?? theme.colors.surface,
      shadow: cardElevation > 0 ? AtomicCardShadow.medium : AtomicCardShadow.none,
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

  EdgeInsetsGeometry _getDefaultPadding(AtomicThemeData theme, BuildContext context) {
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

 