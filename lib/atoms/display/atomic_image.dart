import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_provider.dart';
import 'package:atomic_flutter_kit/themes/atomic_theme_data.dart';
import 'package:atomic_flutter_kit/tokens/borders/atomic_borders.dart';
import 'package:atomic_flutter_kit/tokens/colors/atomic_colors.dart';
import 'package:atomic_flutter_kit/atoms/feedback/atomic_shimmer.dart';

/// A versatile image display widget that supports network, asset, and file images.
///
/// The [AtomicImage] provides a unified way to load and display images from
/// various sources. It includes built-in placeholder and error handling,
/// and supports common image properties like fit, color, border radius, and border.
///
/// Features:
/// - Load images from network URLs, local assets, or file paths.
/// - Customizable width, height, and BoxFit.
/// - Optional color tinting for the image.
/// - Adjustable border radius and border.
/// - Automatic shimmer placeholder during loading.
/// - Default error widget for failed image loads.
///
/// Example usage:
/// ```dart
/// // Network image
/// AtomicImage.network(
///   url: 'https://picsum.photos/200/300',
///   width: 150,
///   height: 150,
///   borderRadius: BorderRadius.circular(8),
/// )
///
/// // Asset image
/// AtomicImage.asset(
///   path: 'assets/my_image.png',
///   width: 100,
///   height: 100,
///   fit: BoxFit.contain,
/// )
/// ```
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

  /// Creates an [AtomicImage] from a network URL.
  ///
  /// [url] is the URL of the image to load.
  /// [width], [height], [fit], [color], [borderRadius], [border]
  /// customize the image display.
  /// [placeholder] is an optional widget to show while the image is loading.
  /// [errorWidget] is an optional widget to show if the image fails to load.
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

  /// Creates an [AtomicImage] from a local asset path.
  ///
  /// [path] is the asset path of the image (e.g., 'assets/images/my_image.png').
  /// [width], [height], [fit], [color], [borderRadius], [border]
  /// customize the image display.
  /// [placeholder] is an optional widget to show while the image is loading.
  /// [errorWidget] is an optional widget to show if the image fails to load.
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

  /// Creates an [AtomicImage] from a local file path.
  ///
  /// [path] is the absolute file path of the image.
  /// [width], [height], [fit], [color], [borderRadius], [border]
  /// customize the image display.
  /// [placeholder] is an optional widget to show while the image is loading.
  /// [errorWidget] is an optional widget to show if the image fails to load.
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

/// A widget for displaying SVG images from network or asset sources.
///
/// The [AtomicSvg] provides a convenient way to render scalable vector graphics.
/// It supports loading SVGs from network URLs or local assets, and allows
/// for customization of dimensions, fit, and color tinting.
///
/// Features:
/// - Load SVGs from network URLs or local assets.
/// - Customizable width, height, and BoxFit.
/// - Optional color tinting for the SVG.
/// - Built-in placeholder during loading.
///
/// Example usage:
/// ```dart
/// // Network SVG
/// AtomicSvg.network(
///   url: 'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/atom.svg',
///   width: 50,
///   height: 50,
///   color: Colors.blue,
/// )
///
/// // Asset SVG
/// AtomicSvg.asset(
///   path: 'assets/icons/my_icon.svg',
///   width: 30,
///   height: 30,
///   fit: BoxFit.contain,
/// )
/// ```
class AtomicSvg extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final AtomicSvgSource source;

  /// Creates an [AtomicSvg] from a network URL.
  ///
  /// [url] is the URL of the SVG to load.
  /// [width], [height], [fit], and [color] customize the SVG display.
  const AtomicSvg.network({
    super.key,
    required String url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  })  : path = url,
        source = AtomicSvgSource.network;

  /// Creates an [AtomicSvg] from a local asset path.
  ///
  /// [path] is the asset path of the SVG (e.g., 'assets/icons/my_icon.svg').
  /// [width], [height], [fit], and [color] customize the SVG display.
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
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
          placeholderBuilder: (context) => _buildPlaceholder(theme),
        );
      case AtomicSvgSource.asset:
        return SvgPicture.asset(
          path!,
          width: width,
          height: height,
          fit: fit,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
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

/// Defines the source types for [AtomicImage].
enum AtomicImageSource {
  /// Image loaded from a network URL.
  network,

  /// Image loaded from a local asset.
  asset,

  /// Image loaded from a local file path.
  file,
}

/// Defines the source types for [AtomicSvg].
enum AtomicSvgSource {
  /// SVG loaded from a network URL.
  network,

  /// SVG loaded from a local asset.
  asset,
}
