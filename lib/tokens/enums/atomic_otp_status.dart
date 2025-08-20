import 'package:flutter/material.dart';
import 'package:atomic_flutter/tokens/colors/atomic_colors.dart';

enum AtomicOtpStatus {
  verifyLoading,
  
  loading,
  
  timeout,
  
  error,
  
  duration,
}

extension AtomicOtpStatusExtension on AtomicOtpStatus {
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
  
  bool get isLoading {
    return this == AtomicOtpStatus.verifyLoading || 
           this == AtomicOtpStatus.loading;
  }
  
  bool get isError {
    return this == AtomicOtpStatus.error || 
           this == AtomicOtpStatus.timeout;
  }
} 