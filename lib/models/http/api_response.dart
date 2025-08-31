/// 🌐 Centralized API Response Models
/// 
/// Consistent response handling across all Flutter applications.
/// Supports both single objects and paginated lists.

/// Generic API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool success;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    this.data,
    this.message,
    this.success = false,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T? data, {String? message}) {
    return ApiResponse<T>(
      data: data,
      message: message,
      success: true,
      statusCode: 200,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      message: message,
      success: false,
      statusCode: statusCode,
      errors: errors,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, statusCode: $statusCode, data: $data)';
  }
}

/// List API response with pagination support
class ApiListResponse<T> {
  final List<T> items;
  final Map<String, dynamic>? meta;
  final Map<String, dynamic>? links;
  final String? message;
  final bool success;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiListResponse({
    this.items = const [],
    this.meta,
    this.links,
    this.message,
    this.success = false,
    this.statusCode,
    this.errors,
  });

  factory ApiListResponse.success({
    required List<T> items,
    Map<String, dynamic>? meta,
    Map<String, dynamic>? links,
    String? message,
  }) {
    return ApiListResponse<T>(
      items: items,
      meta: meta,
      links: links,
      message: message,
      success: true,
      statusCode: 200,
    );
  }

  factory ApiListResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiListResponse<T>(
      message: message,
      success: false,
      statusCode: statusCode,
      errors: errors,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;

  // Pagination helpers
  int get total => meta?['total'] ?? 0;
  int get currentPage => meta?['current_page'] ?? 1;
  int get totalPages => meta?['total_pages'] ?? 1;
  bool get hasMorePages => meta?['has_more_pages'] ?? false;
  int get perPage => meta?['per_page'] ?? items.length;

  @override
  String toString() {
    return 'ApiListResponse(success: $success, items: ${items.length}, total: $total, currentPage: $currentPage)';
  }
}