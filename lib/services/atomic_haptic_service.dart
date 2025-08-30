import 'package:flutter/services.dart';

/// A utility service for triggering haptic feedback on the device.
///
/// The [AtomicHapticService] provides a simplified interface for generating
/// various types of haptic feedback, such as light, medium, or heavy impacts,
/// selection clicks, and vibrations. It also includes convenience methods
/// for common feedback types like success, warning, and error.
///
/// This service wraps Flutter's [HapticFeedback] and provides a more
/// semantic way to trigger haptics within an application.
///
/// Example usage:
/// ```dart
/// // Trigger a light impact
/// AtomicHapticService.lightImpact();
///
/// // Trigger haptic feedback for a success event
/// AtomicHapticService.success();
///
/// // Trigger haptic feedback using the enum extension
/// AtomicHapticType.heavy.trigger();
/// ```
class AtomicHapticService {
  AtomicHapticService._();

  /// Triggers a light haptic feedback.
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Triggers a medium haptic feedback.
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Triggers a heavy haptic feedback.
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Triggers a selection haptic feedback.
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Triggers a generic vibration haptic feedback.
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

  /// Triggers haptic feedback based on the specified [AtomicHapticType].
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

  /// Triggers haptic feedback for a success event (medium impact).
  static Future<void> success() async {
    await mediumImpact();
  }

  /// Triggers haptic feedback for an error event (heavy impact).
  static Future<void> error() async {
    await heavyImpact();
  }

  /// Triggers haptic feedback for a warning event (light impact).
  static Future<void> warning() async {
    await lightImpact();
  }

  /// Returns true if haptic feedback is available on the device.
  static bool get isAvailable {
    return true; // HapticFeedback.canVibrate is not available in stable Flutter yet
  }
}

/// Defines various types of haptic feedback.
enum AtomicHapticType {
  /// A light haptic impact.
  light,

  /// A medium haptic impact.
  medium,

  /// A heavy haptic impact.
  heavy,

  /// A haptic feedback for a selection event.
  selection,

  /// A generic vibration haptic feedback.
  vibrate,

  /// Haptic feedback indicating a successful operation.
  success,

  /// Haptic feedback indicating a warning.
  warning,

  /// Haptic feedback indicating an error.
  error,
}

/// Extension methods on [AtomicHapticType] for easy triggering and naming.
extension AtomicHapticTypeExtension on AtomicHapticType {
  /// Triggers the haptic feedback corresponding to this type.
  Future<void> trigger() => AtomicHapticService.feedback(this);

  /// Returns a human-readable name for the haptic type.
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
