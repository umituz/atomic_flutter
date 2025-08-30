import 'package:uuid/uuid.dart';

abstract class BaseModel {
  static final _uuid = const Uuid();
  
  String? id;
  
  DateTime? createdAt;
  
  DateTime? updatedAt;
  
  BaseModel({
    this.id,
    this.createdAt,
    this.updatedAt,
  });
  
  static String generateUuid() {
    return _uuid.v4();
  }
  
  void beforeCreate() {
    id ??= generateUuid();
    createdAt ??= DateTime.now();
    updatedAt ??= DateTime.now();
  }
  
  void beforeUpdate() {
    updatedAt = DateTime.now();
  }
  
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
  
  Map<String, dynamic> toInsertJson() {
    beforeCreate();
    return toJson();
  }
  
  Map<String, dynamic> toUpdateJson() {
    beforeUpdate();
    final json = toJson();
    json.remove('id');
    json.remove('created_at');
    return json;
  }
}

mixin UuidMixin {
  static final _uuid = const Uuid();
  
  String generateUuid() => _uuid.v4();
  
  void ensureUuid(Map<String, dynamic> data, [String fieldName = 'id']) {
    data[fieldName] ??= generateUuid();
  }
} 