import 'dart:async';
import 'package:flutter/material.dart';

class AtomicDebouncer {
  AtomicDebouncer({
    this.delay = const Duration(milliseconds: 500),
  });

  Duration delay;
  Timer? _timer;
  VoidCallback? _callback;

  void debounce(VoidCallback callback) {
    _callback = callback;
    cancel();
    _timer = Timer(delay, flush);
  }

  void cancel() {
    _timer?.cancel();
  }

  void flush() {
    _callback?.call();
    cancel();
  }

  void dispose() {
    cancel();
  }
}

class AtomicSearchDebouncer {
  AtomicSearchDebouncer({
    this.delay = const Duration(milliseconds: 300),
    required this.onSearch,
  });

  final Duration delay;
  final ValueChanged<String> onSearch;
  Timer? _timer;
  String _lastQuery = '';

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

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    cancel();
  }
}

class AtomicThrottle {
  AtomicThrottle({
    required this.duration,
  });

  final Duration duration;
  DateTime? _lastRun;

  void throttle(VoidCallback callback) {
    final now = DateTime.now();
    if (_lastRun == null || now.difference(_lastRun!) >= duration) {
      _lastRun = now;
      callback();
    }
  }

  void reset() {
    _lastRun = null;
  }
}

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

  void debounce(VoidCallback callback) {
    _pendingCallback = callback;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, () {
      _pendingCallback?.call();
    });
  }

  void throttle(VoidCallback callback) {
    final now = DateTime.now();
    if (_lastThrottleRun == null || 
        now.difference(_lastThrottleRun!) >= throttleDuration) {
      _lastThrottleRun = now;
      callback();
    }
  }

  void debounceWithThrottle(VoidCallback callback) {
    _pendingCallback = callback;
    
    final now = DateTime.now();
    if (_lastThrottleRun == null || 
        now.difference(_lastThrottleRun!) >= throttleDuration) {
      _lastThrottleRun = now;
      callback();
      _debounceTimer?.cancel();
      return;
    }
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDelay, () {
      _pendingCallback?.call();
    });
  }

  void cancel() {
    _debounceTimer?.cancel();
    _pendingCallback = null;
  }

  void dispose() {
    cancel();
  }
}
