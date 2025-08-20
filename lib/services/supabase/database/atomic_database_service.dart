library atomic_database_service;
import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:atomic_flutter/services/supabase/models/supabase_response.dart';
import 'package:atomic_flutter/services/supabase/models/supabase_error.dart';
import 'package:atomic_flutter/services/supabase/exceptions/supabase_exceptions.dart';

class AtomicDatabaseService {
  final SupabaseClient _client;
  
  AtomicDatabaseService({SupabaseClient? client}) 
    : _client = client ?? Supabase.instance.client;

  Future<SupabaseResponse<List<Map<String, dynamic>>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _client.from(table).select(columns);
      
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 100) - 1);
      }
      
      final result = await query;
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch records: ${e.toString()}'),
      );
    }
  }

  Future<SupabaseResponse<Map<String, dynamic>?>> selectById(
    String table,
    String id, {
    String columns = '*',
    String idColumn = 'id',
  }) async {
    try {
      final result = await _client
          .from(table)
          .select(columns)
          .eq(idColumn, id)
          .maybeSingle();
      
      return SupabaseResponse.success(result);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch record: ${e.toString()}'),
      );
    }
  }

  Future<SupabaseResponse<List<Map<String, dynamic>>>> insert(
    String table,
    Map<String, dynamic> data, {
    bool returning = true,
  }) async {
    try {
      if (returning) {
        final result = await _client.from(table).insert(data).select();
        return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
      } else {
        await _client.from(table).insert(data);
        return SupabaseResponse.success([]);
      }
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to insert record: ${e.toString()}'),
      );
    }
  }

  Future<SupabaseResponse<List<Map<String, dynamic>>>> update(
    String table,
    String id,
    Map<String, dynamic> data, {
    String idColumn = 'id',
    bool returning = true,
  }) async {
    try {
      if (returning) {
        final result = await _client
            .from(table)
            .update(data)
            .eq(idColumn, id)
            .select();
        return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
      } else {
        await _client
            .from(table)
            .update(data)
            .eq(idColumn, id);
        return SupabaseResponse.success([]);
      }
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to update record: ${e.toString()}'),
      );
    }
  }

  Future<SupabaseResponse<void>> delete(
    String table,
    String id, {
    String idColumn = 'id',
  }) async {
    try {
      await _client
          .from(table)
          .delete()
          .eq(idColumn, id);
      
      return SupabaseResponse.success(null);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to delete record: ${e.toString()}'),
      );
    }
  }

  Future<bool> exists(
    String table,
    String id, {
    String idColumn = 'id',
  }) async {
    try {
      final result = await _client
          .from(table)
          .select(idColumn)
          .eq(idColumn, id)
          .maybeSingle();
      
      return result != null;
    } catch (e) {
      return false;
    }
  }

  Future<SupabaseResponse<int>> count(
    String table, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      dynamic query = _client.from(table).select('*');
      
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      
      final result = await query;
      final count = (result as List).length;
      return SupabaseResponse.success(count);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to count records: ${e.toString()}'),
      );
    }
  }

  Future<SupabaseResponse<List<Map<String, dynamic>>>> selectRandom(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    List<String>? excludeIds,
    String idColumn = 'id',
    int limit = 1,
  }) async {
    try {
      dynamic query = _client.from(table).select(columns);
      
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      
      if (excludeIds != null && excludeIds.isNotEmpty) {
        query = query.not(idColumn, 'in', excludeIds);
      }
      
      final result = await query;
      
      if (result.isEmpty) {
        return SupabaseResponse.success([]);
      }
      
      final random = math.Random();
      final selectedRecords = <Map<String, dynamic>>[];
      final availableRecords = List<Map<String, dynamic>>.from(result);
      
      for (int i = 0; i < limit && availableRecords.isNotEmpty; i++) {
        final randomIndex = random.nextInt(availableRecords.length);
        selectedRecords.add(availableRecords.removeAt(randomIndex));
      }
      
      return SupabaseResponse.success(selectedRecords);
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch random records: ${e.toString()}'),
      );
    }
  }

  Future<SupabaseResponse<List<Map<String, dynamic>>>> selectWithFilters(
    String table, {
    String columns = '*',
    List<DatabaseFilter>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) async {
    try {
      dynamic query = _client.from(table).select(columns);
      
      if (filters != null) {
        for (final filter in filters) {
          switch (filter.operator) {
            case FilterOperator.equals:
              query = query.eq(filter.column, filter.value);
              break;
            case FilterOperator.notEquals:
              query = query.neq(filter.column, filter.value);
              break;
            case FilterOperator.greaterThan:
              query = query.gt(filter.column, filter.value);
              break;
            case FilterOperator.greaterThanOrEqual:
              query = query.gte(filter.column, filter.value);
              break;
            case FilterOperator.lessThan:
              query = query.lt(filter.column, filter.value);
              break;
            case FilterOperator.lessThanOrEqual:
              query = query.lte(filter.column, filter.value);
              break;
            case FilterOperator.contains:
              query = query.ilike(filter.column, '%${filter.value}%');
              break;
            case FilterOperator.inList:
              query = query.inFilter(filter.column, filter.value as List);
              break;
            case FilterOperator.notInList:
              query = query.not(filter.column, 'in', filter.value as List);
              break;
          }
        }
      }
      
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 100) - 1);
      }
      
      final result = await query;
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
    } catch (e) {
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch filtered records: ${e.toString()}'),
      );
    }
  }
}

class DatabaseFilter {
  final String column;
  final FilterOperator operator;
  final dynamic value;

  const DatabaseFilter({
    required this.column,
    required this.operator,
    required this.value,
  });

  factory DatabaseFilter.equals(String column, dynamic value) =>
      DatabaseFilter(column: column, operator: FilterOperator.equals, value: value);

  factory DatabaseFilter.notEquals(String column, dynamic value) =>
      DatabaseFilter(column: column, operator: FilterOperator.notEquals, value: value);

  factory DatabaseFilter.greaterThan(String column, dynamic value) =>
      DatabaseFilter(column: column, operator: FilterOperator.greaterThan, value: value);

  factory DatabaseFilter.lessThan(String column, dynamic value) =>
      DatabaseFilter(column: column, operator: FilterOperator.lessThan, value: value);

  factory DatabaseFilter.contains(String column, String value) =>
      DatabaseFilter(column: column, operator: FilterOperator.contains, value: value);

  factory DatabaseFilter.inList(String column, List value) =>
      DatabaseFilter(column: column, operator: FilterOperator.inList, value: value);
}

enum FilterOperator {
  equals,
  notEquals,
  greaterThan,
  greaterThanOrEqual,
  lessThan,
  lessThanOrEqual,
  contains,
  inList,
  notInList,
} 