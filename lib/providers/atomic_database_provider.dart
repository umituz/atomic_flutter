/// Generic Database Provider Pattern for Riverpod
/// Provides reusable state management patterns for database operations
library atomic_database_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../services/supabase/database/atomic_database_service.dart';
import '../services/supabase/models/supabase_response.dart';
import '../services/supabase/models/supabase_error.dart';

/// Generic database state for any model type
@immutable
class AtomicDatabaseState<T> {
  final List<T> data;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  const AtomicDatabaseState({
    this.data = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  AtomicDatabaseState<T> copyWith({
    List<T>? data,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return AtomicDatabaseState<T>(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  // Helper getters
  bool get hasData => data.isNotEmpty;
  bool get hasError => error != null;
  int get itemCount => data.length;
  T? get firstItem => data.isNotEmpty ? data.first : null;
  T? get lastItem => data.isNotEmpty ? data.last : null;
}

/// Generic database notifier for CRUD operations
abstract class AtomicDatabaseNotifier<T> extends StateNotifier<AtomicDatabaseState<T>> {
  final AtomicDatabaseService _databaseService;
  final String tableName;

  AtomicDatabaseNotifier({
    required this.tableName,
    AtomicDatabaseService? databaseService,
  }) : _databaseService = databaseService ?? AtomicDatabaseService(),
       super(const AtomicDatabaseState());

  /// Convert JSON to model - must be implemented by subclasses
  T fromJson(Map<String, dynamic> json);

  /// Convert model to JSON - must be implemented by subclasses
  Map<String, dynamic> toJson(T model);

  /// Get model ID - must be implemented by subclasses
  String getId(T model);

  /// Load all records
  Future<void> loadAll({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _databaseService.select(
        tableName,
        filters: filters,
        orderBy: orderBy,
        ascending: ascending,
        limit: limit,
      );

      if (result.isSuccess && result.data != null) {
        final models = result.data!.map((json) => fromJson(json)).toList();
        state = state.copyWith(
          data: models,
          isLoading: false,
          hasMore: limit == null || models.length < limit,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error?.message ?? 'Failed to load data',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load paginated records
  Future<void> loadPaginated({
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int pageSize = 20,
    bool append = false,
  }) async {
    if (!append) {
      state = state.copyWith(isLoading: true, error: null, currentPage: 1);
    }

    try {
      final offset = append ? (state.currentPage - 1) * pageSize : 0;
      
      final result = await _databaseService.select(
        tableName,
        filters: filters,
        orderBy: orderBy,
        ascending: ascending,
        limit: pageSize,
        offset: offset,
      );

      if (result.isSuccess && result.data != null) {
        final models = result.data!.map((json) => fromJson(json)).toList();
        
        final newData = append ? [...state.data, ...models] : models;
        
        state = state.copyWith(
          data: newData,
          isLoading: false,
          hasMore: models.length == pageSize,
          currentPage: append ? state.currentPage + 1 : 1,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error?.message ?? 'Failed to load data',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load next page (append to existing data)
  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    
    await loadPaginated(append: true);
  }

  /// Add new record
  Future<bool> add(T model) async {
    try {
      final result = await _databaseService.insert(
        tableName,
        toJson(model),
      );

      if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
        final newModel = fromJson(result.data!.first);
        state = state.copyWith(
          data: [...state.data, newModel],
        );
        return true;
      } else {
        state = state.copyWith(
          error: result.error?.message ?? 'Failed to add record',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Update existing record
  Future<bool> update(T model) async {
    try {
      final id = getId(model);
      final result = await _databaseService.update(
        tableName,
        id,
        toJson(model),
      );

      if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
        final updatedModel = fromJson(result.data!.first);
        final updatedData = state.data.map((item) {
          return getId(item) == id ? updatedModel : item;
        }).toList();
        
        state = state.copyWith(data: updatedData);
        return true;
      } else {
        state = state.copyWith(
          error: result.error?.message ?? 'Failed to update record',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Delete record
  Future<bool> delete(String id) async {
    try {
      final result = await _databaseService.delete(tableName, id);

      if (result.isSuccess) {
        final updatedData = state.data.where((item) => getId(item) != id).toList();
        state = state.copyWith(data: updatedData);
        return true;
      } else {
        state = state.copyWith(
          error: result.error?.message ?? 'Failed to delete record',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Search/filter records
  Future<void> search({
    required List<DatabaseFilter> filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _databaseService.selectWithFilters(
        tableName,
        filters: filters,
        orderBy: orderBy,
        ascending: ascending,
        limit: limit,
      );

      if (result.isSuccess && result.data != null) {
        final models = result.data!.map((json) => fromJson(json)).toList();
        state = state.copyWith(
          data: models,
          isLoading: false,
          hasMore: limit == null || models.length < limit,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error?.message ?? 'Search failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get random records
  Future<void> loadRandom({
    Map<String, dynamic>? filters,
    List<String>? excludeIds,
    int limit = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _databaseService.selectRandom(
        tableName,
        filters: filters,
        excludeIds: excludeIds,
        limit: limit,
      );

      if (result.isSuccess && result.data != null) {
        final models = result.data!.map((json) => fromJson(json)).toList();
        state = state.copyWith(
          data: models,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error?.message ?? 'Failed to load random records',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadAll();
  }

  /// Clear all data and errors
  void clear() {
    state = const AtomicDatabaseState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get record by ID
  T? getById(String id) {
    try {
      return state.data.firstWhere((item) => getId(item) == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if record exists
  bool exists(String id) {
    return getById(id) != null;
  }

  /// Get records count
  int get count => state.data.length;
}

/// Generic database provider factory
class AtomicDatabaseProviderFactory {
  /// Create a StateNotifierProvider for any model type
  static StateNotifierProvider<T, AtomicDatabaseState<M>> create<T extends AtomicDatabaseNotifier<M>, M>(
    T Function(Ref ref) create,
  ) {
    return StateNotifierProvider<T, AtomicDatabaseState<M>>((ref) => create(ref));
  }

  /// Create a family provider for dynamic table/filter combinations
  static StateNotifierProviderFamily<T, AtomicDatabaseState<M>, P> createFamily<T extends AtomicDatabaseNotifier<M>, M, P>(
    T Function(Ref ref, P parameter) create,
  ) {
    return StateNotifierProvider.family<T, AtomicDatabaseState<M>, P>((ref, param) => create(ref, param));
  }
} 