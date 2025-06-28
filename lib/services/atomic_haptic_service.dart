import 'package:flutter/services.dart';

/// Atomic Haptic Service
/// Provides haptic feedback functionality using Flutter's built-in HapticFeedback API
class AtomicHapticService {
  // Private constructor to prevent instantiation
  AtomicHapticService._();

  /// Trigger light impact haptic feedback
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Trigger medium impact haptic feedback  
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Trigger heavy impact haptic feedback
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Trigger selection click haptic feedback
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Trigger vibrate haptic feedback (standard vibration)
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

  /// Trigger haptic feedback based on type
  static Future<void> feedback(AtomicHapticType type) async {
    switch (type) {
      case AtomicHapticType.light:
        await lightImpact();
        break;
      case AtomicHapticType.medium:
        await mediumImpact();
        break;
      case AtomicHapticType.heavy:
        await heavyImpact();
        break;
      case AtomicHapticType.selection:
        await selectionClick();
        break;
      case AtomicHapticType.vibrate:
        await vibrate();
        break;
      case AtomicHapticType.success:
        await mediumImpact();
        break;
      case AtomicHapticType.warning:
        await lightImpact();
        break;
      case AtomicHapticType.error:
        await heavyImpact();
        break;
    }
  }

  /// Trigger success feedback (medium impact)
  static Future<void> success() async {
    await mediumImpact();
  }

  /// Trigger error feedback (heavy impact)
  static Future<void> error() async {
    await heavyImpact();
  }

  /// Trigger warning feedback (light impact)
  static Future<void> warning() async {
    await lightImpact();
  }

  /// Check if haptic feedback is available on the device
  /// Note: This always returns true on supported platforms (iOS 10+, Android)
  static bool get isAvailable {
    // HapticFeedback is available on iOS 10+ and Android
    // We can't check availability directly, but it's safe to assume it's available
    return true;
  }
}

/// Haptic feedback types for atomic components
enum AtomicHapticType {
  /// Light impact feedback
  light,
  
  /// Medium impact feedback
  medium,
  
  /// Heavy impact feedback
  heavy,
  
  /// Selection click feedback
  selection,
  
  /// Standard vibration
  vibrate,
  
  /// Success feedback (medium impact)
  success,
  
  /// Warning feedback (light impact)
  warning,
  
  /// Error feedback (heavy impact)
  error,
}

/// Extension on AtomicHapticType for convenient usage
extension AtomicHapticTypeExtension on AtomicHapticType {
  /// Trigger the haptic feedback for this type
  Future<void> trigger() => AtomicHapticService.feedback(this);
  
  /// Get a descriptive name for this haptic type
  String get name {
    switch (this) {
      case AtomicHapticType.light:
        return 'Light Impact';
      case AtomicHapticType.medium:
        return 'Medium Impact';
      case AtomicHapticType.heavy:
        return 'Heavy Impact';
      case AtomicHapticType.selection:
        return 'Selection Click';
      case AtomicHapticType.vibrate:
        return 'Vibrate';
      case AtomicHapticType.success:
        return 'Success';
      case AtomicHapticType.warning:
        return 'Warning';
      case AtomicHapticType.error:
        return 'Error';
    }
  }
} 