library atomic_database_provider;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'package:atomic_flutter/services/supabase/database/atomic_database_service.dart';
import 'package:atomic_flutter/services/supabase/models/supabase_response.dart';
import 'package:atomic_flutter/services/supabase/models/supabase_error.dart';

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

  bool get hasData => data.isNotEmpty;
  bool get hasError => error != null;
  int get itemCount => data.length;
  T? get firstItem => data.isNotEmpty ? data.first : null;
  T? get lastItem => data.isNotEmpty ? data.last : null;
}

abstract class AtomicDatabaseNotifier<T> extends StateNotifier<AtomicDatabaseState<T>> {
  final AtomicDatabaseService _databaseService;
  final String tableName;

  AtomicDatabaseNotifier({
    required this.tableName,
    AtomicDatabaseService? databaseService,
    required AtomicDatabaseState<T> initialState,
  }) : _databaseService = databaseService ?? AtomicDatabaseService(),
       super(initialState);

  T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson(T model);

  String getId(T model);

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

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    
    await loadPaginated(append: true);
  }

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

  Future<void> refresh() async {
    await loadAll();
  }

  void clear() {
    state = AtomicDatabaseState<T>();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  T? getById(String id) {
    try {
      return state.data.firstWhere((item) => getId(item) == id);
    } catch (e) {
      return null;
    }
  }

  bool exists(String id) {
    return getById(id) != null;
  }

  int get count => state.data.length;
}

class AtomicDatabaseProviderFactory {
  static StateNotifierProvider<T, AtomicDatabaseState<M>> create<T extends AtomicDatabaseNotifier<M>, M>(
    T Function(Ref ref) create,
  ) {
    return StateNotifierProvider<T, AtomicDatabaseState<M>>((ref) => create(ref));
  }

  static StateNotifierProviderFamily<T, AtomicDatabaseState<M>, P> createFamily<T extends AtomicDatabaseNotifier<M>, M, P>(
    T Function(Ref ref, P parameter) create,
  ) {
    return StateNotifierProvider.family<T, AtomicDatabaseState<M>, P>((ref, param) => create(ref, param));
  }
} 