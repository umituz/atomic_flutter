import 'package:uuid/uuid.dart';

/// Base model class that provides common functionality for all database models
/// Similar to Laravel's BaseObserver pattern
abstract class BaseModel {
  static final _uuid = const Uuid();
  
  /// Unique identifier for the model
  String? id;
  
  /// Timestamp when the record was created
  DateTime? createdAt;
  
  /// Timestamp when the record was last updated
  DateTime? updatedAt;
  
  BaseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
  });
  
  /// Generates a new UUID v4
  static String generateUuid() {
    return _uuid.v4();
  }
  
  /// Called before creating a new record
  /// Automatically sets id if not provided
  void beforeCreate() {
    if (id == null) {
      id = generateUuid();
      print('🔑 [BaseModel] Generated new UUID: $id');
    } else {
      print('🔑 [BaseModel] Using existing UUID: $id');
    }
    createdAt ??= DateTime.now();
    updatedAt ??= DateTime.now();
    print('🔑 [BaseModel] Created at: $createdAt, Updated at: $updatedAt');
  }
  
  /// Called before updating a record
  /// Automatically updates the updatedAt timestamp
  void beforeUpdate() {
    updatedAt = DateTime.now();
  }
  
  /// Converts the model to a map for database operations
  /// Subclasses should override and call super.toJson()
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
  
  /// Creates a map for database insert operations
  /// Automatically calls beforeCreate()
  Map<String, dynamic> toInsertJson() {
    beforeCreate();
    return toJson();
  }
  
  /// Creates a map for database update operations
  /// Automatically calls beforeUpdate()
  Map<String, dynamic> toUpdateJson() {
    beforeUpdate();
    final json = toJson();
    // Remove id from update operations
    json.remove('id');
    // Remove created_at from update operations
    json.remove('created_at');
    return json;
  }
}

/// Mixin to add UUID functionality to existing models
mixin UuidMixin {
  static final _uuid = const Uuid();
  
  String generateUuid() => _uuid.v4();
  
  void ensureUuid(Map<String, dynamic> data, [String fieldName = 'id']) {
    data[fieldName] ??= generateUuid();
  }
} 