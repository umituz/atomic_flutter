/// Generic Database Service for Supabase operations
/// Provides reusable CRUD operations with typed responses and error handling
library atomic_database_service;

import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/supabase_response.dart';
import '../models/supabase_error.dart';
import '../exceptions/supabase_exceptions.dart';

/// Generic database service for common CRUD operations
class AtomicDatabaseService {
  final SupabaseClient _client;
  
  AtomicDatabaseService({SupabaseClient? client}) 
    : _client = client ?? Supabase.instance.client;

  /// Select records with typed response
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
      
      // Apply filters
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      
      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      // Apply pagination
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 100) - 1);
      }
      
      final result = await query;
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
    } catch (e) {
      developer.log('Database select error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch records: ${e.toString()}'),
      );
    }
  }

  /// Select single record by ID
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
      developer.log('Database selectById error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch record: ${e.toString()}'),
      );
    }
  }

  /// Insert record with typed response
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
      developer.log('Database insert error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to insert record: ${e.toString()}'),
      );
    }
  }

  /// Update record with typed response
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
      developer.log('Database update error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to update record: ${e.toString()}'),
      );
    }
  }

  /// Delete record with typed response
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
      developer.log('Database delete error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to delete record: ${e.toString()}'),
      );
    }
  }

  /// Check if record exists
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
      developer.log('Database exists check error: $e', error: e);
      return false;
    }
  }

  /// Count records with filters
  Future<SupabaseResponse<int>> count(
    String table, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      dynamic query = _client.from(table).select('*');
      
      // Apply filters
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      
      final result = await query;
      final count = (result as List).length;
      return SupabaseResponse.success(count);
    } catch (e) {
      developer.log('Database count error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to count records: ${e.toString()}'),
      );
    }
  }

  /// Get random record(s) from table
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
      
      // Apply filters
      if (filters != null) {
        for (final entry in filters.entries) {
          query = query.eq(entry.key, entry.value);
        }
      }
      
      // Exclude specific IDs
      if (excludeIds != null && excludeIds.isNotEmpty) {
        query = query.not(idColumn, 'in', excludeIds);
      }
      
      final result = await query;
      
      if (result.isEmpty) {
        return SupabaseResponse.success([]);
      }
      
      // Select random records
      final random = math.Random();
      final selectedRecords = <Map<String, dynamic>>[];
      final availableRecords = List<Map<String, dynamic>>.from(result);
      
      for (int i = 0; i < limit && availableRecords.isNotEmpty; i++) {
        final randomIndex = random.nextInt(availableRecords.length);
        selectedRecords.add(availableRecords.removeAt(randomIndex));
      }
      
      return SupabaseResponse.success(selectedRecords);
    } catch (e) {
      developer.log('Database selectRandom error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch random records: ${e.toString()}'),
      );
    }
  }

  /// Advanced filtering with multiple conditions
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
      
      // Apply filters
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
      
      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }
      
      // Apply pagination
      if (limit != null) {
        query = query.limit(limit);
      }
      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 100) - 1);
      }
      
      final result = await query;
      return SupabaseResponse.success(List<Map<String, dynamic>>.from(result));
    } catch (e) {
      developer.log('Database selectWithFilters error: $e', error: e);
      return SupabaseResponse.error(
        SupabaseError.database('Failed to fetch filtered records: ${e.toString()}'),
      );
    }
  }
}

/// Database filter for advanced queries
class DatabaseFilter {
  final String column;
  final FilterOperator operator;
  final dynamic value;

  const DatabaseFilter({
    required this.column,
    required this.operator,
    required this.value,
  });

  /// Factory constructors for common filters
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

/// Filter operators for database queries
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