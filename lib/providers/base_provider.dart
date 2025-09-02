import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../tokens/enums/atomic_loading_state.dart';
import '../services/base_api_service.dart';
import '../models/http/api_response.dart';

/// Generic Base Provider for CRUD operations
/// 
/// Standardizes common data management patterns across all Flutter applications.
/// Eliminates repetitive provider code and ensures consistency.
/// 
/// Features:
/// - Generic CRUD operations (Create, Read, Update, Delete)
/// - Consistent state management with AtomicLoadingState
/// - Error handling and loading states
/// - Integration with BaseApiService
/// - Extensible for custom business logic
/// 
/// Example usage:
/// ```dart
/// class BudgetProvider extends BaseProvider<Budget> {
///   BudgetProvider(BaseApiService<Budget> apiService) : super(apiService);
/// 
///   // Override for custom business logic
///   @override
///   Future<void> afterCreate(Budget item) async {
///     // Custom logic after creating a budget
///     await calculateTotalBudget();
///   }
/// }
/// 
/// // Riverpod provider setup
/// final budgetApiServiceProvider = Provider<BaseApiService<Budget>>((ref) {
///   return BudgetApiService(); // Your concrete implementation
/// });
/// 
/// final budgetProvider = StateNotifierProvider<BudgetProvider, AtomicLoadingState>((ref) {
///   final apiService = ref.read(budgetApiServiceProvider);
///   return BudgetProvider(apiService);
/// });
/// ```
abstract class BaseProvider<T> extends StateNotifier<AtomicLoadingState> {
  /// Creates a BaseProvider with the specified API service
  BaseProvider(this._apiService) : super(AtomicLoadingState.initial);

  final BaseApiService<T> _apiService;
  
  List<T> _items = [];
  String? _lastError;
  T? _selectedItem;

  /// Current list of items
  List<T> get items => _items;

  /// Last error message, if any
  String? get lastError => _lastError;

  /// Currently selected item, if any
  T? get selectedItem => _selectedItem;

  /// Loads all items from the API
  Future<void> loadItems({Map<String, dynamic>? queryParams}) async {
    if (state == AtomicLoadingState.loading) return;
    
    _setLoading();
    
    try {
      await beforeLoadItems(queryParams: queryParams);
      
      final response = await _apiService.getItems(queryParams: queryParams);
      
      if (response.isSuccess && response.data != null) {
        _items = response.data!;
        _lastError = null;
        state = AtomicLoadingState.loaded;
        
        await afterLoadItems(_items, queryParams: queryParams);
      } else {
        _handleError('Failed to load items: ${response.message}');
      }
    } catch (e) {
      _handleError('Error loading items: $e');
    }
  }

  /// Loads a single item by UUID
  Future<void> loadItem(String uuid) async {
    if (state == AtomicLoadingState.loading) return;
    
    _setLoading();
    
    try {
      await beforeLoadItem(uuid);
      
      final response = await _apiService.getItem(uuid);
      
      if (response.isSuccess && response.data != null) {
        _selectedItem = response.data;
        _lastError = null;
        state = AtomicLoadingState.loaded;
        
        await afterLoadItem(_selectedItem!, uuid);
      } else {
        _handleError('Failed to load item: ${response.message}');
      }
    } catch (e) {
      _handleError('Error loading item: $e');
    }
  }

  /// Creates a new item
  Future<bool> createItem(T item) async {
    if (state == AtomicLoadingState.loading) return false;
    
    _setLoading();
    
    try {
      await beforeCreate(item);
      
      final response = await _apiService.createItem(item);
      
      if (response.isSuccess && response.data != null) {
        _items.add(response.data!);
        _lastError = null;
        state = AtomicLoadingState.loaded;
        
        await afterCreate(response.data!);
        return true;
      } else {
        _handleError('Failed to create item: ${response.message}');
        return false;
      }
    } catch (e) {
      _handleError('Error creating item: $e');
      return false;
    }
  }

  /// Updates an existing item
  Future<bool> updateItem(String uuid, T item) async {
    if (state == AtomicLoadingState.loading) return false;
    
    _setLoading();
    
    try {
      await beforeUpdate(uuid, item);
      
      final response = await _apiService.updateItem(uuid, item);
      
      if (response.isSuccess && response.data != null) {
        final index = _items.indexWhere((element) => getUuid(element) == uuid);
        if (index >= 0) {
          _items[index] = response.data!;
        }
        
        if (_selectedItem != null && getUuid(_selectedItem!) == uuid) {
          _selectedItem = response.data;
        }
        
        _lastError = null;
        state = AtomicLoadingState.loaded;
        
        await afterUpdate(response.data!, uuid);
        return true;
      } else {
        _handleError('Failed to update item: ${response.message}');
        return false;
      }
    } catch (e) {
      _handleError('Error updating item: $e');
      return false;
    }
  }

  /// Deletes an item
  Future<bool> deleteItem(String uuid) async {
    if (state == AtomicLoadingState.loading) return false;
    
    _setLoading();
    
    try {
      await beforeDelete(uuid);
      
      final response = await _apiService.deleteItem(uuid);
      
      if (response.isSuccess) {
        _items.removeWhere((element) => getUuid(element) == uuid);
        
        if (_selectedItem != null && getUuid(_selectedItem!) == uuid) {
          _selectedItem = null;
        }
        
        _lastError = null;
        state = AtomicLoadingState.loaded;
        
        await afterDelete(uuid);
        return true;
      } else {
        _handleError('Failed to delete item: ${response.message}');
        return false;
      }
    } catch (e) {
      _handleError('Error deleting item: $e');
      return false;
    }
  }

  /// Refreshes the current data
  Future<void> refresh({Map<String, dynamic>? queryParams}) async {
    await loadItems(queryParams: queryParams);
  }

  /// Clears all data and resets state
  void clear() {
    _items = [];
    _selectedItem = null;
    _lastError = null;
    state = AtomicLoadingState.initial;
  }

  /// Selects an item
  void selectItem(T item) {
    _selectedItem = item;
    state = AtomicLoadingState.loaded;
  }

  /// Clears the selected item
  void clearSelection() {
    _selectedItem = null;
    state = AtomicLoadingState.loaded;
  }

  /// Clears the last error
  void clearError() {
    _lastError = null;
    if (_items.isNotEmpty) {
      state = AtomicLoadingState.loaded;
    } else {
      state = AtomicLoadingState.initial;
    }
  }

  // Private helper methods
  void _setLoading() {
    state = AtomicLoadingState.loading;
    _lastError = null;
  }

  void _handleError(String error) {
    debugPrint('BaseProvider Error: $error');
    _lastError = error;
    state = AtomicLoadingState.error;
  }

  // Abstract/Virtual methods for subclass customization

  /// Override to provide custom UUID extraction logic
  /// Default implementation assumes the object has a 'uuid' property
  /// This follows Laravel backend standards which use UUID as primary keys
  String getUuid(T item) {
    if (item is Map<String, dynamic>) {
      return (item as Map<String, dynamic>)['uuid']?.toString() ?? '';
    }
    
    // Use reflection or custom logic based on your model structure
    try {
      final dynamic dynamicItem = item;
      return dynamicItem.uuid?.toString() ?? '';
    } catch (e) {
      throw UnimplementedError(
        'Override getUuid() method to provide custom UUID extraction for type ${T.runtimeType}'
      );
    }
  }

  // Lifecycle hooks for custom business logic

  /// Called before loading items
  @protected
  Future<void> beforeLoadItems({Map<String, dynamic>? queryParams}) async {}

  /// Called after successfully loading items
  @protected
  Future<void> afterLoadItems(List<T> items, {Map<String, dynamic>? queryParams}) async {}

  /// Called before loading a single item
  @protected
  Future<void> beforeLoadItem(String uuid) async {}

  /// Called after successfully loading a single item
  @protected
  Future<void> afterLoadItem(T item, String uuid) async {}

  /// Called before creating an item
  @protected
  Future<void> beforeCreate(T item) async {}

  /// Called after successfully creating an item
  @protected
  Future<void> afterCreate(T item) async {
    // Call the standardized lifecycle hook
    await onItemCreated(item);
  }

  /// Called before updating an item
  @protected
  Future<void> beforeUpdate(String uuid, T item) async {}

  /// Called after successfully updating an item
  @protected
  Future<void> afterUpdate(T item, String uuid) async {
    // Call the standardized lifecycle hook
    await onItemUpdated(item);
  }

  /// Called before deleting an item
  @protected
  Future<void> beforeDelete(String uuid) async {}

  /// Called after successfully deleting an item
  @protected
  Future<void> afterDelete(String uuid) async {
    // Call the standardized lifecycle hook
    await onItemDeleted(uuid);
  }

  // Standardized lifecycle hooks following FLUTTER_API_DEVELOPMENT.md patterns

  /// Override this method to handle item creation in your provider
  /// This method is called automatically after successfully creating an item
  @protected
  Future<void> onItemCreated(T item) async {}

  /// Override this method to handle item updates in your provider  
  /// This method is called automatically after successfully updating an item
  @protected
  Future<void> onItemUpdated(T item) async {}

  /// Override this method to handle item deletion in your provider
  /// This method is called automatically after successfully deleting an item
  @protected
  Future<void> onItemDeleted(String uuid) async {}
}