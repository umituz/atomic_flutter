import 'dart:isolate';

extension AtomicCloneExtension<T> on T {
  Future<T> clone() async {
    final receive = ReceivePort();

    try {
      receive.sendPort.send(this);

      final cloned = await receive.first;

      return cloned as T;
    } catch (e) {
      throw CloneException('Failed to clone object: $e');
    } finally {
      receive.close();
    }
  }

  T cloneSync() {
    if (this == null) return this;

    if (this is num || this is String || this is bool) {
      return this;
    }

    if (this is List) {
      return List.from(this as List) as T;
    }

    if (this is Map) {
      return Map.from(this as Map) as T;
    }

    if (this is Set) {
      return Set.from(this as Set) as T;
    }

    throw const CloneException(
        'cloneSync() only supports primitives, lists, maps, and sets. Use clone() for complex objects.');
  }
}

class CloneException implements Exception {
  final String message;

  const CloneException(this.message);

  @override
  String toString() => 'CloneException: $message';
}
