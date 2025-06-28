import 'package:flutter/foundation.dart';
import '../utilities/atomic_debouncer.dart';

/// Atomic Base Service
/// Abstract base class for services with pagination, loading states, and listener management
abstract class AtomicBaseService extends ChangeNotifier {
  AtomicBaseService({
    this.initialPage = 1,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : _page = initialPage,
       _searchDebouncer = AtomicDebouncer(delay: debounceDuration);

  // Pagination
  int _page;
  int _lastPage = 1;
  bool _pageLoading = false;
  
  // Search
  String _searchQuery = '';
  final AtomicDebouncer _searchDebouncer;
  
  // Initial values
  final int initialPage;
  final Duration debounceDuration;

  /// Current page number
  int get page => _page;
  
  /// Last page number for pagination
  int get lastPage => _lastPage;
  
  /// Current loading state
  bool get pageLoading => _pageLoading;
  
  /// Current search query
  String get searchQuery => _searchQuery;
  
  /// Check if has more pages
  bool get hasMorePages => _page < _lastPage;
  
  /// Check if on first page
  bool get isFirstPage => _page == 1;
  
  /// Check if on last page
  bool get isLastPage => _page >= _lastPage;

  /// Increase page number
  void increasePage() {
    if (hasMorePages) {
      _page++;
      notifyListeners();
    }
  }

  /// Decrease page number
  void decreasePage() {
    if (_page > 1) {
      _page--;
      notifyListeners();
    }
  }

  /// Set specific page
  void setPage(int page) {
    if (page > 0 && page <= _lastPage) {
      _page = page;
      notifyListeners();
    }
  }

  /// Set last page
  void setLastPage(int lastPage) {
    if (lastPage > 0) {
      _lastPage = lastPage;
      notifyListeners();
    }
  }

  /// Set loading state
  set pageLoading(bool value) {
    if (_pageLoading != value) {
      _pageLoading = value;
      notifyListeners();
    }
  }

  /// Set search query
  set searchQuery(String value) {
    if (_searchQuery != value) {
      _searchQuery = value;
      notifyListeners();
    }
  }

  /// Update search query with debounce
  void updateSearchQuery(String query, {VoidCallback? onDebounce}) {
    searchQuery = query;
    _searchDebouncer.debounce(() {
      onDebounce?.call();
    });
  }

  /// Set debouncer duration
  void setDebouncerDuration(Duration duration) {
    _searchDebouncer.delay = duration;
  }

  /// Execute function with debounce
  void debounce(VoidCallback callback) {
    _searchDebouncer.debounce(callback);
  }

  /// Reset pagination to initial state
  void resetPagination() {
    _page = initialPage;
    _lastPage = 1;
    _pageLoading = false;
    notifyListeners();
  }

  /// Reset search
  void resetSearch() {
    _searchQuery = '';
    _searchDebouncer.cancel();
    notifyListeners();
  }

  /// Reset all states
  void reset() {
    resetPagination();
    resetSearch();
  }

  /// Load data (to be implemented by subclasses)
  Future<void> loadData();

  /// Refresh data (reset and reload)
  Future<void> refresh() async {
    reset();
    await loadData();
  }

  /// Load next page
  Future<void> loadNextPage() async {
    if (hasMorePages && !pageLoading) {
      increasePage();
      await loadData();
    }
  }

  /// Search with debounce
  void search(String query) {
    updateSearchQuery(query, onDebounce: () async {
      resetPagination();
      await loadData();
    });
  }

  @override
  void dispose() {
    _searchDebouncer.cancel();
    super.dispose();
  }
}

/// Example usage:
/// ```dart
/// class UserService extends AtomicBaseService {
///   final List<User> _users = [];
///   
///   List<User> get users => List.unmodifiable(_users);
///   
///   @override
///   Future<void> loadData() async {
///     pageLoading = true;
///     
///     try {
///       final response = await api.getUsers(
///         page: page,
///         query: searchQuery,
///       );
///       
///       if (page == 1) {
///         _users.clear();
///       }
///       
///       _users.addAll(response.users);
///       setLastPage(response.totalPages);
///     } finally {
///       pageLoading = false;
///     }
///   }
/// }
/// ``` 