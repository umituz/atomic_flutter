/// Atomic Caching Service for Database Operations
/// Provides intelligent caching to improve performance and reduce API calls
library atomic_caching_service;

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import '../models/supabase_response.dart';
import '../models/supabase_error.dart';
import 'atomic_database_service.dart';

/// Cache entry with expiration
class CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  final Duration ttl;

  CacheEntry(this.data, {Duration? ttl}) 
    : timestamp = DateTime.now(),
      ttl = ttl ?? const Duration(minutes: 10);

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}

/// Caching service wrapper for AtomicDatabaseService
class AtomicCachingService {
  final AtomicDatabaseService _databaseService;
  final Map<String, CacheEntry<List<Map<String, dynamic>>>> _cache = {};
  final Map<String, CacheEntry<Map<String, dynamic>>> _singleItemCache = {};
  
  // Cache configuration
  final Duration defaultTtl;
  final int maxCacheSize;
  final bool enableDebugLogs;

  AtomicCachingService({
    AtomicDatabaseService? databaseService,
    this.defaultTtl = const Duration(minutes: 10),
    this.maxCacheSize = 1000,
    this.enableDebugLogs = false,
  }) : _databaseService = databaseService ?? AtomicDatabaseService();

  /// Generate cache key for list operations
  String _generateListCacheKey(
    String table, {
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
  }) {
    final params = {
      'table': table,
      'filters': filters?.toString() ?? '',
      'orderBy': orderBy ?? '',
      'ascending': ascending,
      'limit': limit ?? 0,
      'offset': offset ?? 0,
    };
    return 'list_${params.toString().hashCode}';
  }

  /// Generate cache key for single item operations
  String _generateItemCacheKey(String table, String id) {
    return '${table}_$id';
  }

  /// Clear expired entries from cache
  void _cleanupExpiredEntries() {
    _cache.removeWhere((key, entry) => entry.isExpired);
    _singleItemCache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Ensure cache doesn't exceed max size
  void _enforceCacheSize() {
    if (_cache.length > maxCacheSize) {
      // Remove oldest entries
      final sortedEntries = _cache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      final toRemove = sortedEntries.take(_cache.length - maxCacheSize);
      for (final entry in toRemove) {
        _cache.remove(entry.key);
      }
    }
  }

  /// Log cache operations if debug is enabled
  void _log(String message) {
    if (enableDebugLogs) {
      developer.log('[AtomicCaching] $message');
    }
  }

  /// Select with caching
  Future<SupabaseResponse<List<Map<String, dynamic>>>> select(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
    Duration? cacheTtl,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _generateListCacheKey(
      table,
      filters: filters,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
      offset: offset,
    );

    // Check cache first (unless force refresh)
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      final entry = _cache[cacheKey]!;
      if (!entry.isExpired) {
        _log('Cache HIT for key: $cacheKey');
        return SupabaseResponse.success(entry.data);
      } else {
        _cache.remove(cacheKey);
        _log('Cache EXPIRED for key: $cacheKey');
      }
    }

    _log('Cache MISS for key: $cacheKey');

    // Fetch from database
    final result = await _databaseService.select(
      table,
      columns: columns,
      filters: filters,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
      offset: offset,
    );

    // Cache successful results
    if (result.isSuccess && result.data != null) {
      _cache[cacheKey] = CacheEntry(
        result.data!,
        ttl: cacheTtl ?? defaultTtl,
      );
      _log('Cached result for key: $cacheKey');
      
      // Cleanup if needed
      _cleanupExpiredEntries();
      _enforceCacheSize();
    }

    return result;
  }

  /// Select by ID with caching
  Future<SupabaseResponse<Map<String, dynamic>?>> selectById(
    String table,
    String id, {
    String columns = '*',
    String idColumn = 'id',
    Duration? cacheTtl,
    bool forceRefresh = false,
  }) async {
    final cacheKey = _generateItemCacheKey(table, id);

    // Check cache first (unless force refresh)
    if (!forceRefresh && _singleItemCache.containsKey(cacheKey)) {
      final entry = _singleItemCache[cacheKey]!;
      if (!entry.isExpired) {
        _log('Cache HIT for item: $cacheKey');
        return SupabaseResponse.success(entry.data);
      } else {
        _singleItemCache.remove(cacheKey);
        _log('Cache EXPIRED for item: $cacheKey');
      }
    }

    _log('Cache MISS for item: $cacheKey');

    // Fetch from database
    final result = await _databaseService.selectById(
      table,
      id,
      columns: columns,
      idColumn: idColumn,
    );

    // Cache successful results
    if (result.isSuccess && result.data != null) {
      _singleItemCache[cacheKey] = CacheEntry(
        result.data!,
        ttl: cacheTtl ?? defaultTtl,
      );
      _log('Cached item for key: $cacheKey');
    }

    return result;
  }

  /// Insert with cache invalidation
  Future<SupabaseResponse<List<Map<String, dynamic>>>> insert(
    String table,
    Map<String, dynamic> data, {
    bool returning = true,
  }) async {
    final result = await _databaseService.insert(table, data, returning: returning);

    // Invalidate related cache entries on successful insert
    if (result.isSuccess) {
      _invalidateTableCache(table);
      _log('Invalidated cache for table: $table after insert');
    }

    return result;
  }

  /// Update with cache invalidation
  Future<SupabaseResponse<List<Map<String, dynamic>>>> update(
    String table,
    String id,
    Map<String, dynamic> data, {
    String idColumn = 'id',
    bool returning = true,
  }) async {
    final result = await _databaseService.update(
      table,
      id,
      data,
      idColumn: idColumn,
      returning: returning,
    );

    // Invalidate related cache entries on successful update
    if (result.isSuccess) {
      _invalidateTableCache(table);
      _invalidateItemCache(table, id);
      _log('Invalidated cache for table: $table and item: $id after update');
    }

    return result;
  }

  /// Delete with cache invalidation
  Future<SupabaseResponse<void>> delete(
    String table,
    String id, {
    String idColumn = 'id',
  }) async {
    final result = await _databaseService.delete(table, id, idColumn: idColumn);

    // Invalidate related cache entries on successful delete
    if (result.isSuccess) {
      _invalidateTableCache(table);
      _invalidateItemCache(table, id);
      _log('Invalidated cache for table: $table and item: $id after delete');
    }

    return result;
  }

  /// Random selection (not cached due to randomness)
  Future<SupabaseResponse<List<Map<String, dynamic>>>> selectRandom(
    String table, {
    String columns = '*',
    Map<String, dynamic>? filters,
    List<String>? excludeIds,
    String idColumn = 'id',
    int limit = 1,
  }) async {
    // Random selections are not cached
    return await _databaseService.selectRandom(
      table,
      columns: columns,
      filters: filters,
      excludeIds: excludeIds,
      idColumn: idColumn,
      limit: limit,
    );
  }

  /// Advanced filtering with selective caching
  Future<SupabaseResponse<List<Map<String, dynamic>>>> selectWithFilters(
    String table, {
    String columns = '*',
    List<DatabaseFilter>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    int? offset,
    Duration? cacheTtl,
    bool forceRefresh = false,
  }) async {
    // Use regular select with caching for filtered queries
    final filtersMap = filters?.fold<Map<String, dynamic>>({}, (map, filter) {
      map[filter.column] = filter.value;
      return map;
    });

    return await select(
      table,
      columns: columns,
      filters: filtersMap,
      orderBy: orderBy,
      ascending: ascending,
      limit: limit,
      offset: offset,
      cacheTtl: cacheTtl,
      forceRefresh: forceRefresh,
    );
  }

  /// Invalidate all cache entries for a table
  void _invalidateTableCache(String table) {
    _cache.removeWhere((key, entry) => key.contains(table));
  }

  /// Invalidate specific item cache
  void _invalidateItemCache(String table, String id) {
    final itemKey = _generateItemCacheKey(table, id);
    _singleItemCache.remove(itemKey);
  }

  /// Manually invalidate cache for table
  void invalidateTableCache(String table) {
    _invalidateTableCache(table);
    _log('Manually invalidated cache for table: $table');
  }

  /// Clear all cache
  void clearCache() {
    _cache.clear();
    _singleItemCache.clear();
    _log('Cleared all cache');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    _cleanupExpiredEntries();
    
    return {
      'listCacheSize': _cache.length,
      'itemCacheSize': _singleItemCache.length,
      'totalCacheSize': _cache.length + _singleItemCache.length,
      'maxCacheSize': maxCacheSize,
      'defaultTtl': defaultTtl.inMinutes,
    };
  }

  /// Dispose and clear all resources
  void dispose() {
    clearCache();
  }
} 