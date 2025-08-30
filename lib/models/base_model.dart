import 'package:uuid/uuid.dart';

/// An abstract base model providing common fields and methods for data models.
///
/// Includes fields for `id`, `createdAt`, and `updatedAt`, along with utility
/// methods for generating UUIDs, handling creation/update timestamps, and
/// converting to/from JSON.
abstract class BaseModel {
  static final _uuid = const Uuid();

  /// The unique identifier for the model instance.
  String? id;

  /// The timestamp when the model instance was created.
  DateTime? createdAt;

  /// The timestamp when the model instance was last updated.
  DateTime? updatedAt;

  /// Creates a [BaseModel] instance.
  ///
  /// [id] is an optional unique identifier.
  /// [createdAt] is an optional creation timestamp.
  /// [updatedAt] is an optional last update timestamp.
  BaseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  /// Generates a new UUID (Universally Unique Identifier).
  static String generateUuid() {
    return _uuid.v4();
  }

  /// Hook method called before a new model instance is created.
  ///
  /// Automatically generates `id`, `createdAt`, and `updatedAt` if they are null.
  void beforeCreate() {
    id ??= generateUuid();
    createdAt ??= DateTime.now();
    updatedAt ??= DateTime.now();
  }

  /// Hook method called before a model instance is updated.
  ///
  /// Automatically updates the `updatedAt` timestamp.
  void beforeUpdate() {
    updatedAt = DateTime.now();
  }

  /// Converts the model instance to a JSON map.
  ///
  /// Includes `id`, `created_at`, and `updated_at` if they are not null.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  /// Converts the model instance to a JSON map suitable for insertion.
  ///
  /// Calls [beforeCreate] to set timestamps and ID before conversion.
  Map<String, dynamic> toInsertJson() {
    beforeCreate();
    return toJson();
  }

  /// Converts the model instance to a JSON map suitable for updating.
  ///
  /// Calls [beforeUpdate] to set the updated timestamp. Removes 'id' and 'created_at'
  /// from the JSON as they typically should not be updated.
  Map<String, dynamic> toUpdateJson() {
    beforeUpdate();
    final json = toJson();
    json.remove('id');
    json.remove('created_at');
    return json;
  }
}

/// A mixin that provides UUID generation utility.
mixin UuidMixin {
  static final _uuid = const Uuid();

  /// Generates a new UUID.
  String generateUuid() => _uuid.v4();

  /// Ensures that a UUID is present in the given data map for a specified field.
  ///
  /// If the field is null, a new UUID is generated and assigned.
  /// [data] the map to check and potentially update.
  /// [fieldName] the name of the field to check for a UUID. Defaults to 'id'.
  void ensureUuid(Map<String, dynamic> data, [String fieldName = 'id']) {
    data[fieldName] ??= generateUuid();
  }
}
