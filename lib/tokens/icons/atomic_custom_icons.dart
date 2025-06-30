import 'package:flutter/widgets.dart';

/// Atomic Custom Icons
/// Custom icon font definitions for the atomic design system
/// 
/// To use custom icons, add the icon font files to your project:
/// 1. Add font files to assets/fonts/
/// 2. Update pubspec.yaml:
/// ```yaml
/// flutter:
///   fonts:
///     - family: AtomicIcons
///       fonts:
///         - asset: assets/fonts/atomic-icons.ttf
/// ```
class AtomicCustomIcons {
  AtomicCustomIcons._();

  static const _kFontFam = 'AtomicIcons';
  static const String? _kFontPkg = null;

  // Location icons
  static const IconData locationAdd = IconData(0xe90a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData locationPin = IconData(0xe90b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData locationSearch = IconData(0xe90c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  
  // Custom UI icons
  static const IconData customHome = IconData(0xe900, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData customProfile = IconData(0xe901, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData customSettings = IconData(0xe902, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  
  // Social icons
  static const IconData socialFacebook = IconData(0xe910, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData socialTwitter = IconData(0xe911, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData socialLinkedin = IconData(0xe912, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData socialInstagram = IconData(0xe913, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  
  // Brand icons
  static const IconData brandLogo = IconData(0xe920, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData brandLogoSmall = IconData(0xe921, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  
  // Activity icons (added for random_activity app)
  static const IconData trash = IconData(0xe930, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData users = IconData(0xe931, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calendar = IconData(0xe932, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData notepadText = IconData(0xe933, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData star = IconData(0xe934, fontFamily: _kFontFam, fontPackage: _kFontPkg);
} 