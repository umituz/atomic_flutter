import 'package:flutter/services.dart';

class AtomicHapticService {
  AtomicHapticService._();

  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

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

  static Future<void> success() async {
    await mediumImpact();
  }

  static Future<void> error() async {
    await heavyImpact();
  }

  static Future<void> warning() async {
    await lightImpact();
  }

  static bool get isAvailable {
    return true;
  }
}

enum AtomicHapticType {
  light,
  
  medium,
  
  heavy,
  
  selection,
  
  vibrate,
  
  success,
  
  warning,
  
  error,
}

extension AtomicHapticTypeExtension on AtomicHapticType {
  Future<void> trigger() => AtomicHapticService.feedback(this);
  
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