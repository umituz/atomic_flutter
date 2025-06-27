import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../themes/atomic_theme_provider.dart';
import '../../themes/atomic_theme_data.dart';
import '../../tokens/borders/atomic_borders.dart';
import '../../tokens/colors/atomic_colors.dart';
import '../feedback/atomic_shimmer.dart';

/// Atomic Image Component
/// Flexible image component with multiple sources and loading states
class AtomicImage extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BorderRadius? borderRadius;
  final Border? border;
  final Widget? placeholder;
  final Widget? errorWidget;
  final AtomicImageSource source;

  const AtomicImage.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
    this.border,
    this.placeholder,
    this.errorWidget,
  })  : path = url,
        source = AtomicImageSource.network;

  const AtomicImage.asset({
    super.key,
    required String path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
    this.border,
    this.placeholder,
    this.errorWidget,
  })  : path = path,
        source = AtomicImageSource.asset;

  const AtomicImage.file({
    super.key,
    required String path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
    this.border,
    this.placeholder,
    this.errorWidget,
  })  : path = path,
        source = AtomicImageSource.file;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.maybeOf(context);
    final effectiveBorderRadius = borderRadius ?? AtomicBorders.md;

    Widget imageWidget;

    switch (source) {
      case AtomicImageSource.network:
        imageWidget = Image.network(
          path!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder(theme);
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget(theme);
          },
        );
        break;
      case AtomicImageSource.asset:
        imageWidget = Image.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget(theme);
          },
        );
        break;
      case AtomicImageSource.file:
        imageWidget = Image.file(
          File(path!),
          width: width,
          height: height,
          fit: fit,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget(theme);
          },
        );
        break;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: imageWidget,
      ),
    );
  }

  Widget _buildPlaceholder(AtomicThemeData? theme) {
    if (placeholder != null) return placeholder!;
    
    return AtomicShimmer(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
    );
  }

  Widget _buildErrorWidget(AtomicThemeData? theme) {
    if (errorWidget != null) return errorWidget!;
    
    return Container(
      width: width,
      height: height,
      color: theme?.colors.gray100 ?? AtomicColors.gray100,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: theme?.colors.gray400 ?? AtomicColors.gray400,
        size: 32,
      ),
    );
  }
}

/// Atomic SVG Component
/// SVG image component with theme integration
class AtomicSvg extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AtomicSvgSource source;

  const AtomicSvg.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  })  : path = url,
        source = AtomicSvgSource.network;

  const AtomicSvg.asset({
    super.key,
    required String path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  })  : path = path,
        source = AtomicSvgSource.asset;

  @override
  Widget build(BuildContext context) {
    final theme = AtomicTheme.maybeOf(context);

    switch (source) {
      case AtomicSvgSource.network:
        return SvgPicture.network(
          path!,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null 
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
          placeholderBuilder: (context) => _buildPlaceholder(theme),
        );
      case AtomicSvgSource.asset:
        return SvgPicture.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          colorFilter: color != null 
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
          placeholderBuilder: (context) => _buildPlaceholder(theme),
        );
    }
  }

  Widget _buildPlaceholder(AtomicThemeData? theme) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            theme?.colors.primary ?? AtomicColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Image source types
enum AtomicImageSource {
  network,
  asset,
  file,
}

/// SVG source types
enum AtomicSvgSource {
  network,
  asset,
} 