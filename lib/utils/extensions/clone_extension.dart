import 'dart:isolate';

/// Clone Extension for Atomic Flutter
/// Provides deep cloning functionality for objects using isolates
/// 
/// This extension creates a deep copy of objects by sending them through
/// an isolate port, which serializes and deserializes the object,
/// creating a new instance with the same data.
///
/// Example:
/// ```dart
/// final original = MyObject();
/// final cloned = await original.clone();
/// ```
///
/// Note: The object must be serializable (primitives, lists, maps, etc.)
/// Custom classes need to be serializable to work with this extension.
extension AtomicCloneExtension<T> on T {
  /// Creates a deep clone of the object using isolate serialization
  /// 
  /// This method works by:
  /// 1. Creating a ReceivePort to receive the cloned data
  /// 2. Sending the object through the port (which serializes it)
  /// 3. Receiving the serialized data (which deserializes it into a new instance)
  /// 4. Closing the port and returning the cloned object
  ///
  /// Throws an exception if the object cannot be serialized.
  Future<T> clone() async {
    final receive = ReceivePort();
    
    try {
      // Send the object through the port to trigger serialization
      receive.sendPort.send(this);
      
      // Receive the cloned object
      final cloned = await receive.first;
      
      // Cast back to original type
      return cloned as T;
    } catch (e) {
      throw CloneException('Failed to clone object: $e');
    } finally {
      // Always close the port
      receive.close();
    }
  }
  
  /// Synchronous clone for simple objects (primitives, lists, maps)
  /// 
  /// Use with caution - only works for simple serializable objects
  /// For complex objects, use the async clone() method
  T cloneSync() {
    if (this == null) return this;
    
    // Handle primitives
    if (this is num || this is String || this is bool) {
      return this;
    }
    
    // Handle lists
    if (this is List) {
      return List.from(this as List) as T;
    }
    
    // Handle maps
    if (this is Map) {
      return Map.from(this as Map) as T;
    }
    
    // Handle sets
    if (this is Set) {
      return Set.from(this as Set) as T;
    }
    
    // For other types, throw exception
    throw CloneException('cloneSync() only supports primitives, lists, maps, and sets. Use clone() for complex objects.');
  }
}

/// Exception thrown when cloning fails
class CloneException implements Exception {
  final String message;
  
  const CloneException(this.message);
  
  @override
  String toString() => 'CloneException: $message';
} 