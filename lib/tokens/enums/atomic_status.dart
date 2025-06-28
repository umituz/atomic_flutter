/// Atomic Status Enum
/// Represents different status states for operations and data
enum AtomicStatus {
  /// Currently loading/processing
  loading,
  
  /// Successfully completed
  success,
  
  /// Failed with error
  error,
  
  /// Empty result or no data
  empty,
  
  /// Cannot perform operation
  cannot,
  
  /// Operation timed out
  timeout,
  
  /// Initial/idle state
  idle,
  
  /// Cancelled by user
  cancelled,
  
  /// Warning state
  warning;

  /// Check if in loading state
  bool get isLoading => this == loading;

  /// Check if in success state
  bool get isSuccess => this == success;

  /// Check if in error state
  bool get isError => this == error;

  /// Check if empty
  bool get isEmpty => this == empty;

  /// Check if cannot perform
  bool get isCannot => this == cannot;

  /// Check if timed out
  bool get isTimeout => this == timeout;

  /// Check if idle
  bool get isIdle => this == idle;

  /// Check if cancelled
  bool get isCancelled => this == cancelled;

  /// Check if warning
  bool get isWarning => this == warning;

  /// Check if in final state (success, error, empty, cannot, timeout, cancelled)
  bool get isFinal => !isLoading && !isIdle;

  /// Check if failed (error, timeout, cannot)
  bool get isFailed => isError || isTimeout || isCannot;

  /// Get display text for the status
  String get displayText {
    switch (this) {
      case loading:
        return 'Loading...';
      case success:
        return 'Success';
      case error:
        return 'Error';
      case empty:
        return 'No Data';
      case cannot:
        return 'Cannot Perform';
      case timeout:
        return 'Timeout';
      case idle:
        return 'Ready';
      case cancelled:
        return 'Cancelled';
      case warning:
        return 'Warning';
    }
  }

  /// Get icon name for the status
  String get iconName {
    switch (this) {
      case loading:
        return 'refresh';
      case success:
        return 'check_circle';
      case error:
        return 'error';
      case empty:
        return 'inbox';
      case cannot:
        return 'block';
      case timeout:
        return 'schedule';
      case idle:
        return 'circle';
      case cancelled:
        return 'cancel';
      case warning:
        return 'warning';
    }
  }

  /// Get color semantic for the status
  String get colorSemantic {
    switch (this) {
      case loading:
        return 'info';
      case success:
        return 'success';
      case error:
        return 'error';
      case empty:
        return 'neutral';
      case cannot:
        return 'error';
      case timeout:
        return 'warning';
      case idle:
        return 'neutral';
      case cancelled:
        return 'warning';
      case warning:
        return 'warning';
    }
  }

  /// Create from string value
  static AtomicStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'loading':
        return loading;
      case 'success':
        return success;
      case 'error':
        return error;
      case 'empty':
        return empty;
      case 'cannot':
      case 'cant':
        return cannot;
      case 'timeout':
        return timeout;
      case 'idle':
        return idle;
      case 'cancelled':
        return cancelled;
      case 'warning':
        return warning;
      default:
        return idle;
    }
  }

  /// Convert to string
  String get value => name;

  /// Check if can retry operation
  bool get canRetry => isFailed || isCancelled;

  /// Check if operation is complete
  bool get isComplete => isSuccess || isEmpty;
} 