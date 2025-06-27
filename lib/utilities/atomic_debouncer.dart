import 'dart:async';
import 'package:flutter/material.dart';

/// Atomic Debouncer Utility
/// Prevents excessive function calls by delaying execution
class AtomicDebouncer {
  AtomicDebouncer({
    this.delay = const Duration(milliseconds: 500),
  });

  Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  /// Debounce a callback function
  void debounce(VoidCallback callback) {
    _callback = callback;
    cancel();
    _timer = Timer(delay, flush);
  }

  /// Cancel the current debounce timer
  void cancel() {
    _timer?.cancel();
  }

  /// Execute the callback immediately and cancel timer
  void flush() {
    _callback?.call();
    cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    cancel();
  }
}

/// Atomic Search Debouncer
/// Specialized debouncer for search operations
class AtomicSearchDebouncer {
  AtomicSearchDebouncer({
    this.delay = const Duration(milliseconds: 300),
    required this.onSearch,
  });

  final Duration delay;
  final ValueChanged<String> onSearch;
  Timer? _timer;
  String _lastQuery = '';

  /// Debounce search query
  void search(String query) {
    _lastQuery = query;
    _timer?.cancel();
    
    if (query.isEmpty) {
      onSearch(query);
      return;
    }

    _timer = Timer(delay, () {
      if (_lastQuery == query) {
        onSearch(query);
      }
    });
  }

  /// Cancel current search
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the search debouncer
  void dispose() {
    cancel();
  }
}

/// Atomic Throttle Utility
/// Limits function calls to a maximum frequency
class AtomicThrottle {
  AtomicThrottle({
    required this.duration,
  });

  final Duration duration;
  DateTime? _lastRun;

  /// Throttle a callback function
  void throttle(VoidCallback callback) {
    final now = DateTime.now();
    if (_lastRun == null || now.difference(_lastRun!) >= duration) {
      _lastRun = now;
      callback();
    }
  }

  /// Reset the throttle
  void reset() {
    _lastRun = null;
  }
}

/// Atomic Function Controller
/// Combines debounce and throttle capabilities
class AtomicFunctionController {
  AtomicFunctionController({
    this.debounceDelay = const Duration(milliseconds: 500),
    this.throttleDuration = const Duration(seconds: 1),
  });

  final Duration debounceDelay;
  final Duration throttleDuration;
  
  Timer? _debounceTimer;
  DateTime? _lastThrottleRun;
  VoidCallback? _pendingCallback;

  /// Debounce a callback
  void debounce(VoidCallback callback) {
    _pendingCallback = callback;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, () {
      _pendingCallback?.call();
    });
  }

  /// Throttle a callback
  void throttle(VoidCallback callback) {
    final now = DateTime.now();
    if (_lastThrottleRun == null || 
        now.difference(_lastThrottleRun!) >= throttleDuration) {
      _lastThrottleRun = now;
      callback();
    }
  }

  /// Debounce with throttle fallback
  /// Ensures function is called at least once per throttle duration
  void debounceWithThrottle(VoidCallback callback) {
    _pendingCallback = callback;
    
    // Check if we should throttle
    final now = DateTime.now();
    if (_lastThrottleRun == null || 
        now.difference(_lastThrottleRun!) >= throttleDuration) {
      _lastThrottleRun = now;
      callback();
      _debounceTimer?.cancel();
      return;
    }
    
    // Otherwise debounce
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, () {
      _pendingCallback?.call();
    });
  }

  /// Cancel all pending operations
  void cancel() {
    _debounceTimer?.cancel();
    _pendingCallback = null;
  }

  /// Dispose the controller
  void dispose() {
    cancel();
  }
}
