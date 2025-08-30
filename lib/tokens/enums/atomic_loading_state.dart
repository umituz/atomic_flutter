enum AtomicLoadingState {
  idle,

  loading,

  success,

  error,

  refreshing;

  bool get isLoading => this == loading || this == refreshing;

  bool get isError => this == error;

  bool get isSuccess => this == success;

  bool get isIdle => this == idle;

  bool get isRefreshing => this == refreshing;

  bool get isNotLoading => !isLoading;

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

  String get value => name;

  static List<AtomicLoadingState> get allStates => AtomicLoadingState.values;

  bool canTransitionTo(AtomicLoadingState newState) {
    switch (this) {
      case idle:
        return newState == loading || newState == refreshing;
      case loading:
        return newState == success || newState == error || newState == idle;
      case success:
        return newState == loading ||
            newState == refreshing ||
            newState == idle;
      case error:
        return newState == loading ||
            newState == refreshing ||
            newState == idle;
      case refreshing:
        return newState == success || newState == error || newState == idle;
    }
  }
}
