/// Atomic Loading State Enum
/// Represents different loading states in atomic components
enum AtomicLoadingState {
  /// Initial state or idle state
  idle,
  
  /// Currently loading/processing
  loading,
  
  /// Successfully completed
  success,
  
  /// Failed with error
  error,
  
  /// Refreshing existing data
  refreshing;

  /// Check if currently in a loading state
  bool get isLoading => this == loading || this == refreshing;

  /// Check if in error state
  bool get isError => this == error;

  /// Check if successful
  bool get isSuccess => this == success;

  /// Check if idle
  bool get isIdle => this == idle;

  /// Check if refreshing
  bool get isRefreshing => this == refreshing;

  /// Check if not loading (idle, success, or error)
  bool get isNotLoading => !isLoading;

  /// Get display text for the state
  String get displayText {
    switch (this) {
      case idle:
        return 'Ready';
      case loading:
        return 'Loading...';
      case success:
        return 'Success';
      case error:
        return 'Error';
      case refreshing:
        return 'Refreshing...';
    }
  }

  /// Get icon name for the state (can be used with IconData)
  String get iconName {
    switch (this) {
      case idle:
        return 'circle';
      case loading:
        return 'refresh';
      case success:
        return 'check_circle';
      case error:
        return 'error';
      case refreshing:
        return 'refresh';
    }
  }

  /// Create from string value
  static AtomicLoadingState fromString(String value) {
    switch (value.toLowerCase()) {
      case 'idle':
        return idle;
      case 'loading':
        return loading;
      case 'success':
        return success;
      case 'error':
        return error;
      case 'refreshing':
        return refreshing;
      default:
        return idle;
    }
  }

  /// Convert to string
  String get value => name;

  /// Get all states as list
  static List<AtomicLoadingState> get allStates => AtomicLoadingState.values;

  /// Check if transition is valid
  bool canTransitionTo(AtomicLoadingState newState) {
    switch (this) {
      case idle:
        return newState == loading || newState == refreshing;
      case loading:
        return newState == success || newState == error || newState == idle;
      case success:
        return newState == loading || newState == refreshing || newState == idle;
      case error:
        return newState == loading || newState == refreshing || newState == idle;
      case refreshing:
        return newState == success || newState == error || newState == idle;
    }
  }
} 