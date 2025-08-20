enum AtomicStatus {
  loading,
  
  success,
  
  error,
  
  empty,
  
  cannot,
  
  timeout,
  
  idle,
  
  cancelled,
  
  warning;

  bool get isLoading => this == loading;

  bool get isSuccess => this == success;

  bool get isError => this == error;

  bool get isEmpty => this == empty;

  bool get isCannot => this == cannot;

  bool get isTimeout => this == timeout;

  bool get isIdle => this == idle;

  bool get isCancelled => this == cancelled;

  bool get isWarning => this == warning;

  bool get isFinal => !isLoading && !isIdle;

  bool get isFailed => isError || isTimeout || isCannot;

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

  String get value => name;

  bool get canRetry => isFailed || isCancelled;

  bool get isComplete => isSuccess || isEmpty;
} 