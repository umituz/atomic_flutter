import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/http/api_response.dart';
import '../services/http/atomic_http_client.dart';

/// Generic Base API Service for standardized backend communication
/// 
/// Provides a consistent interface for CRUD operations across all Flutter applications.
/// Eliminates repetitive API service code and ensures consistency with Laravel backend.
/// 
/// Features:
/// - Standardized CRUD operations (Create, Read, Update, Delete)
/// - Integration with AtomicHttpClient for robust HTTP handling
/// - Support for Laravel API patterns and conventions
/// - Generic type support for any model
/// - Extensible for custom endpoints and business logic
/// - Consistent error handling and response parsing
/// 
/// Example usage:
/// ```dart
/// class BudgetApiService extends BaseApiService<Budget> {
///   @override
///   String get endpoint => '/budget-manager/budgets';
/// 
///   @override
///   Budget fromJson(Map<String, dynamic> json) => Budget.fromJson(json);
/// 
///   @override
///   Map<String, dynamic> toJson(Budget item) => item.toJson();
/// 
///   // Override for custom endpoints
///   Future<ApiResponse<List<Budget>>> getActiveBudgets() async {
///     return await getItems(queryParams: {'status': 'active'});
///   }
/// }
/// ```
abstract class BaseApiService<T> {
  /// AtomicHttpClient instance for HTTP operations
  AtomicHttpClient get _httpClient => AtomicHttpClient.instance;

  /// API endpoint path (without base URL)
  /// Example: '/budget-manager/budgets', '/habit-tracker/habits'
  String get endpoint;

  /// Convert JSON to model instance
  T fromJson(Map<String, dynamic> json);

  /// Convert model instance to JSON
  Map<String, dynamic> toJson(T item);

  /// Get all items with optional query parameters
  /// 
  /// Supports Laravel pagination and filtering:
  /// - page: Page number for pagination
  /// - per_page: Items per page
  /// - search: Search query
  /// - Any model-specific filters
  Future<ApiResponse<List<T>>> getItems({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      debugPrint('🌐 BaseApiService.getItems: Fetching from $endpoint');
      
      await beforeGetItems(queryParams: queryParams);
      
      final response = await _httpClient.get(
        endpoint,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        List<T> items;
        
        // Handle Laravel paginated response format
        if (response.data is Map<String, dynamic> && 
            (response.data as Map<String, dynamic>).containsKey('data')) {
          final data = (response.data as Map<String, dynamic>)['data'] as List;
          items = data.map((json) => fromJson(json as Map<String, dynamic>)).toList();
        }
        // Handle direct array response
        else if (response.data is List) {
          final data = response.data as List;
          items = data.map((json) => fromJson(json as Map<String, dynamic>)).toList();
        }
        else {
          throw Exception('Unexpected response format for items list');
        }

        final result = ApiResponse<List<T>>.success(items);
        await afterGetItems(result, queryParams: queryParams);
        
        debugPrint('🌐 BaseApiService.getItems: Successfully loaded ${items.length} items');
        return result;
      } else {
        final error = 'Failed to load items: ${response.message ?? 'Unknown error'}';
        debugPrint('🌐 BaseApiService.getItems: Error - $error');
        return ApiResponse<List<T>>.error(error);
      }
    } catch (e) {
      final error = 'Error fetching items: $e';
      debugPrint('🌐 BaseApiService.getItems: Exception - $error');
      return ApiResponse<List<T>>.error(error);
    }
  }

  /// Get a single item by UUID
  Future<ApiResponse<T>> getItem(String uuid) async {
    try {
      debugPrint('🌐 BaseApiService.getItem: Fetching $endpoint/$uuid');
      
      await beforeGetItem(uuid);
      
      final response = await _httpClient.get('$endpoint/$uuid');

      if (response.isSuccess && response.data != null) {
        T item;
        
        // Handle Laravel single resource response format
        if (response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('data')) {
          final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
          item = fromJson(data);
        }
        // Handle direct object response
        else if (response.data is Map<String, dynamic>) {
          item = fromJson(response.data as Map<String, dynamic>);
        }
        else {
          throw Exception('Unexpected response format for single item');
        }

        final result = ApiResponse<T>.success(item);
        await afterGetItem(result, uuid);
        
        debugPrint('🌐 BaseApiService.getItem: Successfully loaded item with UUID: $uuid');
        return result;
      } else {
        final error = 'Failed to load item: ${response.message ?? 'Unknown error'}';
        debugPrint('🌐 BaseApiService.getItem: Error - $error');
        return ApiResponse<T>.error(error);
      }
    } catch (e) {
      final error = 'Error fetching item: $e';
      debugPrint('🌐 BaseApiService.getItem: Exception - $error');
      return ApiResponse<T>.error(error);
    }
  }

  /// Create a new item
  Future<ApiResponse<T>> createItem(T item) async {
    try {
      debugPrint('🌐 BaseApiService.createItem: Creating at $endpoint');
      
      await beforeCreateItem(item);
      
      final requestData = toJson(item);
      final response = await _httpClient.post(
        endpoint,
        data: requestData,
      );

      if (response.isSuccess && response.data != null) {
        T createdItem;
        
        // Handle Laravel create response format
        if (response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('data')) {
          final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
          createdItem = fromJson(data);
        }
        // Handle direct object response
        else if (response.data is Map<String, dynamic>) {
          createdItem = fromJson(response.data as Map<String, dynamic>);
        }
        else {
          throw Exception('Unexpected response format for created item');
        }

        final result = ApiResponse<T>.success(createdItem);
        await afterCreateItem(result, item);
        
        debugPrint('🌐 BaseApiService.createItem: Successfully created item');
        return result;
      } else {
        final error = 'Failed to create item: ${response.message ?? 'Unknown error'}';
        debugPrint('🌐 BaseApiService.createItem: Error - $error');
        return ApiResponse<T>.error(error);
      }
    } catch (e) {
      final error = 'Error creating item: $e';
      debugPrint('🌐 BaseApiService.createItem: Exception - $error');
      return ApiResponse<T>.error(error);
    }
  }

  /// Update an existing item
  Future<ApiResponse<T>> updateItem(String uuid, T item) async {
    try {
      debugPrint('🌐 BaseApiService.updateItem: Updating $endpoint/$uuid');
      
      await beforeUpdateItem(uuid, item);
      
      final requestData = toJson(item);
      final response = await _httpClient.put(
        '$endpoint/$uuid',
        data: requestData,
      );

      if (response.isSuccess && response.data != null) {
        T updatedItem;
        
        // Handle Laravel update response format
        if (response.data is Map<String, dynamic> &&
            (response.data as Map<String, dynamic>).containsKey('data')) {
          final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
          updatedItem = fromJson(data);
        }
        // Handle direct object response
        else if (response.data is Map<String, dynamic>) {
          updatedItem = fromJson(response.data as Map<String, dynamic>);
        }
        else {
          throw Exception('Unexpected response format for updated item');
        }

        final result = ApiResponse<T>.success(updatedItem);
        await afterUpdateItem(result, uuid, item);
        
        debugPrint('🌐 BaseApiService.updateItem: Successfully updated item with UUID: $uuid');
        return result;
      } else {
        final error = 'Failed to update item: ${response.message ?? 'Unknown error'}';
        debugPrint('🌐 BaseApiService.updateItem: Error - $error');
        return ApiResponse<T>.error(error);
      }
    } catch (e) {
      final error = 'Error updating item: $e';
      debugPrint('🌐 BaseApiService.updateItem: Exception - $error');
      return ApiResponse<T>.error(error);
    }
  }

  /// Delete an item
  Future<ApiResponse<void>> deleteItem(String uuid) async {
    try {
      debugPrint('🌐 BaseApiService.deleteItem: Deleting $endpoint/$uuid');
      
      await beforeDeleteItem(uuid);
      
      final response = await _httpClient.delete('$endpoint/$uuid');

      if (response.isSuccess) {
        final result = ApiResponse<void>.success(null);
        await afterDeleteItem(result, uuid);
        
        debugPrint('🌐 BaseApiService.deleteItem: Successfully deleted item with UUID: $uuid');
        return result;
      } else {
        final error = 'Failed to delete item: ${response.message ?? 'Unknown error'}';
        debugPrint('🌐 BaseApiService.deleteItem: Error - $error');
        return ApiResponse<void>.error(error);
      }
    } catch (e) {
      final error = 'Error deleting item: $e';
      debugPrint('🌐 BaseApiService.deleteItem: Exception - $error');
      return ApiResponse<void>.error(error);
    }
  }

  /// Get paginated items with Laravel pagination support
  /// 
  /// Returns both the data and pagination metadata
  Future<Map<String, dynamic>> getPaginatedItems({
    int page = 1,
    int perPage = 10,
    String? search,
    Map<String, dynamic>? additionalParams,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (additionalParams != null) ...additionalParams,
      };

      final response = await _httpClient.get(
        endpoint,
        queryParams: queryParams,
      );

      if (response.isSuccess && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Parse items from Laravel pagination response
        final itemsData = responseData['data'] as List;
        final items = itemsData.map((json) => fromJson(json as Map<String, dynamic>)).toList();
        
        return {
          'data': items,
          'meta': responseData['meta'] ?? {},
          'links': responseData['links'] ?? {},
        };
      } else {
        throw Exception('Failed to load paginated items: ${response.message}');
      }
    } catch (e) {
      throw Exception('Error fetching paginated items: $e');
    }
  }

  // Lifecycle hooks for custom business logic

  /// Called before getting items
  @protected
  Future<void> beforeGetItems({Map<String, dynamic>? queryParams}) async {}

  /// Called after successfully getting items
  @protected
  Future<void> afterGetItems(ApiResponse<List<T>> result, {Map<String, dynamic>? queryParams}) async {}

  /// Called before getting a single item
  @protected
  Future<void> beforeGetItem(String uuid) async {}

  /// Called after successfully getting a single item
  @protected
  Future<void> afterGetItem(ApiResponse<T> result, String uuid) async {}

  /// Called before creating an item
  @protected
  Future<void> beforeCreateItem(T item) async {}

  /// Called after successfully creating an item
  @protected
  Future<void> afterCreateItem(ApiResponse<T> result, T item) async {}

  /// Called before updating an item
  @protected
  Future<void> beforeUpdateItem(String uuid, T item) async {}

  /// Called after successfully updating an item
  @protected
  Future<void> afterUpdateItem(ApiResponse<T> result, String uuid, T item) async {}

  /// Called before deleting an item
  @protected
  Future<void> beforeDeleteItem(String uuid) async {}

  /// Called after successfully deleting an item
  @protected
  Future<void> afterDeleteItem(ApiResponse<void> result, String uuid) async {}
}