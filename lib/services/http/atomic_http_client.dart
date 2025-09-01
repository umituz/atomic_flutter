import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/http/api_response.dart';
import '../auth/token_storage_service.dart';

/// 🌐 Centralized HTTP Client Service
/// 
/// Powerful HTTP client built with Dio, featuring:
/// - Request/Response interceptors
/// - Automatic token management
/// - Error handling and retries
/// - Request logging
/// - Timeout configuration
/// - Generic response handling
class AtomicHttpClient {
  static AtomicHttpClient? _instance;
  static AtomicHttpClient get instance => _instance ??= AtomicHttpClient._internal();
  
  AtomicHttpClient._internal() {
    _setupInterceptors();
  }

  late final Dio _dio = Dio();
  final _tokenStorage = TokenStorageService.instance;
  String? _baseUrl;

  /// Initialize with base URL and optional configuration
  void initialize({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    bool enableLogging = kDebugMode,
  }) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    
    _dio.options = BaseOptions(
      baseUrl: _baseUrl!,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      sendTimeout: sendTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        error: true,
        logPrint: (object) => debugPrint(object.toString()),
      ));
    }
  }

  /// Setup request/response interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Auto-add authentication token if available
          final token = await _tokenStorage.getAuthHeader();
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - clear invalid tokens
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clearToken();
          }
          
          return handler.next(error);
        },
      ),
    );
  }

  /// Generic GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Generic DELETE request
  Future<ApiResponse<void>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<void>(response, null);
    } catch (e) {
      return _handleError<void>(e);
    }
  }

  /// GET request for paginated lists
  Future<ApiListResponse<T>> getList<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleListResponse<T>(response, fromJson);
    } catch (e) {
      return _handleListError<T>(e);
    }
  }

  /// Handle successful responses
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      // Handle standard API response format
      if (data.containsKey('success') && data['success'] == true) {
        final responseData = data['data'];
        
        if (responseData != null && fromJson != null) {
          if (responseData is List) {
            final items = responseData
                .map((item) => fromJson(item as Map<String, dynamic>))
                .toList();
            return ApiResponse<T>.success(items as T, message: data['message']);
          } else {
            return ApiResponse<T>.success(
              fromJson(responseData as Map<String, dynamic>),
              message: data['message'],
            );
          }
        } else {
          return ApiResponse<T>.success(null, message: data['message']);
        }
      } else {
        return ApiResponse<T>.error(
          message: data['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
          errors: data['errors'],
        );
      }
    } else {
      // Handle direct data responses
      if (fromJson != null && data != null) {
        return ApiResponse<T>.success(fromJson(data));
      } else {
        return ApiResponse<T>.success(data as T?);
      }
    }
  }

  /// Handle list responses with pagination
  ApiListResponse<T> _handleListResponse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      if (data.containsKey('success') && data['success'] == true) {
        final items = data['data'] as List? ?? [];
        final parsedItems = items
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
        
        return ApiListResponse<T>.success(
          items: parsedItems,
          meta: data['meta'],
          links: data['links'],
          message: data['message'],
        );
      } else {
        return ApiListResponse<T>.error(
          message: data['message'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
          errors: data['errors'],
        );
      }
    } else if (data is List) {
      // Handle direct list responses
      final parsedItems = data
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
      
      return ApiListResponse<T>.success(items: parsedItems);
    } else {
      return ApiListResponse<T>.error(
        message: 'Invalid response format',
        statusCode: response.statusCode,
      );
    }
  }

  /// Handle request errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiResponse<T>.error(
            message: 'Connection timeout. Please try again.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.receiveTimeout:
          return ApiResponse<T>.error(
            message: 'Receive timeout. Please try again.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.sendTimeout:
          return ApiResponse<T>.error(
            message: 'Send timeout. Please try again.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.connectionError:
          return ApiResponse<T>.error(
            message: 'No internet connection.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.badResponse:
          final data = error.response?.data;
          if (data is Map<String, dynamic>) {
            return ApiResponse<T>.error(
              message: data['message'] ?? 'Server error occurred.',
              statusCode: error.response?.statusCode,
              errors: data['errors'],
            );
          }
          return ApiResponse<T>.error(
            message: 'Server error occurred.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.cancel:
          return ApiResponse<T>.error(
            message: 'Request was cancelled.',
            statusCode: error.response?.statusCode,
          );
        default:
          return ApiResponse<T>.error(
            message: 'An unexpected error occurred.',
            statusCode: error.response?.statusCode,
          );
      }
    }
    
    return ApiResponse<T>.error(
      message: 'An unexpected error occurred: $error',
    );
  }

  /// Handle list request errors
  ApiListResponse<T> _handleListError<T>(dynamic error) {
    final apiError = _handleError<T>(error);
    
    return ApiListResponse<T>.error(
      message: apiError.message!,
      statusCode: apiError.statusCode,
      errors: apiError.errors,
    );
  }

  /// Get current Dio instance for advanced usage
  Dio get dio => _dio;
}