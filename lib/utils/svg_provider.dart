import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart' as svg;
import 'package:flutter/services.dart' show rootBundle;

/// An [Enum] of the possible image path sources.
enum SvgSource {
  file,
  asset,
  network,
}

/// Rasterizes given svg picture for displaying in [Image] widget:
///
/// ```dart
/// Image(
///   width: 32,
///   height: 32,
///   image: SvgProvider('assets/my_icon.svg'),
/// )
/// ```
class SvgProvider extends ImageProvider<SvgImageKey> {
  /// Path to svg file or asset
  final String path;

  /// Size in logical pixels to render.
  /// Useful for [DecorationImage].
  /// If not specified, will use size from [Image].
  /// If [Image] not specifies size too, will use default size 100x100.
  final Size? size;

  /// Color to tint the SVG
  final Color? color;

  /// Source of svg image
  final SvgSource source;

  /// Image scale.
  final double? scale;

  /// Width and height can also be specified from [Image] constructor.
  /// Default size is 100x100 logical pixels.
  /// Different size can be specified in [Image] parameters
  const SvgProvider(
    this.path, {
    this.size,
    this.scale,
    this.color,
    this.source = SvgSource.asset,
  });

  @override
  Future<SvgImageKey> obtainKey(ImageConfiguration configuration) {
    final Color effectiveColor = color ?? Colors.transparent;
    final double effectiveScale = scale ?? configuration.devicePixelRatio ?? 1.0;
    final double logicWidth = size?.width ?? configuration.size?.width ?? 100;
    final double logicHeight = size?.height ?? configuration.size?.height ?? 100;

    return SynchronousFuture<SvgImageKey>(
      SvgImageKey(
        path: path,
        scale: effectiveScale,
        color: effectiveColor,
        source: source,
        pixelWidth: (logicWidth * effectiveScale).round(),
        pixelHeight: (logicHeight * effectiveScale).round(),
      ),
    );
  }

  @override
  ImageStreamCompleter loadImage(SvgImageKey key, ImageDecoderCallback decode) {
    return OneFrameImageStreamCompleter(_loadAsync(key));
  }

  static Future<String> _getSvgString(SvgImageKey key) async {
    switch (key.source) {
      case SvgSource.network:
        return await http.read(Uri.parse(key.path));
      case SvgSource.asset:
        return await rootBundle.loadString(key.path);
      case SvgSource.file:
        return await File(key.path).readAsString();
    }
  }

  static Future<ImageInfo> _loadAsync(SvgImageKey key) async {
    final String rawSvg = await _getSvgString(key);
    
    // Parse SVG string
    final PictureInfo pictureInfo = await svg.vg.loadPicture(
      svg.SvgStringLoader(rawSvg),
      null,
    );
    
    // Create a new picture with the desired size and color filter
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    
    // Apply color filter if needed
    if (key.color != null && key.color != Colors.transparent) {
      final Paint paint = Paint()
        ..colorFilter = ColorFilter.mode(
          _getFilterColor(key.color),
          BlendMode.srcIn,
        );
      canvas.saveLayer(null, paint);
    }
    
    // Scale the picture to fit the desired size
    final double scaleX = key.pixelWidth / pictureInfo.size.width;
    final double scaleY = key.pixelHeight / pictureInfo.size.height;
    canvas.scale(scaleX, scaleY);
    
    canvas.drawPicture(pictureInfo.picture);
    
    if (key.color != null && key.color != Colors.transparent) {
      canvas.restore();
    }
    
    final ui.Picture picture = recorder.endRecording();
    final ui.Image image = await picture.toImage(
      key.pixelWidth,
      key.pixelHeight,
    );
    
    pictureInfo.picture.dispose();

    return ImageInfo(
      image: image,
      scale: key.scale,
    );
  }

  @override
  String toString() => '$runtimeType(${describeIdentity(path)})';

  // Running on web with Colors.transparent may throw exception
  static Color _getFilterColor(Color? color) {
    if (kIsWeb && color == Colors.transparent) {
      return const Color(0x01ffffff);
    } else {
      return color ?? Colors.transparent;
    }
  }
}

@immutable
class SvgImageKey {
  const SvgImageKey({
    required this.path,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.scale,
    required this.source,
    this.color,
  });

  /// Path to svg asset.
  final String path;

  /// Width in physical pixels.
  /// Used when rasterizing.
  final int pixelWidth;

  /// Height in physical pixels.
  /// Used when rasterizing.
  final int pixelHeight;

  /// Color to tint the SVG
  final Color? color;

  /// Image source.
  final SvgSource source;

  /// Used to calculate logical size from physical, i.e.
  /// logicalWidth = [pixelWidth] / [scale],
  /// logicalHeight = [pixelHeight] / [scale].
  /// Should be equal to [MediaQueryData.devicePixelRatio].
  final double scale;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is SvgImageKey &&
        other.path == path &&
        other.pixelWidth == pixelWidth &&
        other.pixelHeight == pixelHeight &&
        other.scale == scale &&
        other.source == source &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(path, pixelWidth, pixelHeight, scale, source, color);

  @override
  String toString() => '${objectRuntimeType(this, 'SvgImageKey')}'
      '(path: "$path", pixelWidth: $pixelWidth, pixelHeight: $pixelHeight, scale: $scale, source: $source)';
} 