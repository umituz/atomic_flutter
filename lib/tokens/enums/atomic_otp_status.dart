import 'package:flutter/material.dart';
import '../../tokens/colors/atomic_colors.dart';

/// Atomic OTP Status Enum
/// Represents various states for OTP (One-Time Password) operations
enum AtomicOtpStatus {
  /// Verification in progress
  verifyLoading,
  
  /// General loading state
  loading,
  
  /// OTP operation timed out
  timeout,
  
  /// Error occurred during OTP process
  error,
  
  /// Duration/timer state
  duration,
}

/// Extension methods for OTP status
extension AtomicOtpStatusExtension on AtomicOtpStatus {
  /// Get display text for the status
  String get displayText {
    switch (this) {
      case AtomicOtpStatus.verifyLoading:
        return 'Verifying...';
      case AtomicOtpStatus.loading:
        return 'Loading...';
      case AtomicOtpStatus.timeout:
        return 'Timeout';
      case AtomicOtpStatus.error:
        return 'Error';
      case AtomicOtpStatus.duration:
        return 'In Progress';
    }
  }
  
  /// Get color for the status
  Color get color {
    switch (this) {
      case AtomicOtpStatus.verifyLoading:
      case AtomicOtpStatus.loading:
        return AtomicColors.info;
      case AtomicOtpStatus.timeout:
        return AtomicColors.warning;
      case AtomicOtpStatus.error:
        return AtomicColors.error;
      case AtomicOtpStatus.duration:
        return AtomicColors.primary;
    }
  }
  
  /// Get icon for the status
  IconData get icon {
    switch (this) {
      case AtomicOtpStatus.verifyLoading:
      case AtomicOtpStatus.loading:
        return Icons.hourglass_empty;
      case AtomicOtpStatus.timeout:
        return Icons.timer_off;
      case AtomicOtpStatus.error:
        return Icons.error_outline;
      case AtomicOtpStatus.duration:
        return Icons.timer;
    }
  }
  
  /// Check if status is loading
  bool get isLoading {
    return this == AtomicOtpStatus.verifyLoading || 
           this == AtomicOtpStatus.loading;
  }
  
  /// Check if status is error state
  bool get isError {
    return this == AtomicOtpStatus.error || 
           this == AtomicOtpStatus.timeout;
  }
  
  /// Legacy compatibility
  String get legacyName {
    switch (this) {
      case AtomicOtpStatus.verifyLoading:
        return 'VERIFY_LOADING';
      case AtomicOtpStatus.loading:
        return 'LOADING';
      case AtomicOtpStatus.timeout:
        return 'TIMEOUT';
      case AtomicOtpStatus.error:
        return 'ERROR';
      case AtomicOtpStatus.duration:
        return 'DURATION';
    }
  }
} 