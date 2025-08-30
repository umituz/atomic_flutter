import 'package:flutter/foundation.dart';
import 'package:atomic_flutter_kit/utilities/atomic_debouncer.dart';

/// An abstract base class for services that manage data loading, pagination, and searching.
///
/// The [AtomicBaseService] extends [ChangeNotifier] and provides common
/// functionalities for services that interact with data sources, such as
/// managing pagination state, handling search queries with debouncing,
/// and providing methods for loading and refreshing data.
///
/// Subclasses should implement the [loadData] method to define how data is fetched.
///
/// Features:
/// - Pagination management (current page, last page, loading state).
/// - Search query management with debouncing.
/// - Methods for increasing/decreasing page, setting page, and resetting pagination.
/// - Methods for updating and resetting search queries.
/// - Abstract [loadData] method to be implemented by concrete services.
/// - [refresh] method to reset and reload data.
/// - [loadNextPage] method to load the next page of data.
///
/// Example usage (subclass implementation):
/// ```dart
/// class MyDataService extends AtomicBaseService {
///   List<String> _data = [];
///
///   List<String> get data => _data;
///
///   @override
///   Future<void> loadData() async {
///     if (pageLoading) return;
///     pageLoading = true;
///
///     try {
///       // Simulate API call
///       await Future.delayed(const Duration(seconds: 1));
///
///       final newData = List.generate(10, (index) => 'Item ${page * 10 + index} for query "$searchQuery"');
///
///       if (page == 1) {
///         _data = newData;
///       } else {
///         _data.addAll(newData);
///       }
///
///       setLastPage(page + 1); // Simulate having more pages
///       notifyListeners();
///     } finally {
///       pageLoading = false;
///     }
///   }
///
///   void addData(String item) {
///     _data.add(item);
///     notifyListeners();
///   }
/// }
///
/// // Usage in a widget:
/// // final myService = Provider.of<MyDataService>(context);
/// // myService.loadData();
/// // myService.search('new query');
/// ```
abstract class AtomicBaseService extends ChangeNotifier {
  /// Creates an [AtomicBaseService].
  ///
  /// [initialPage] is the starting page number. Defaults to 1.
  /// [debounceDuration] is the duration for debouncing search queries. Defaults to 500ms.
  AtomicBaseService({
    this.initialPage = 1,
    this.debounceDuration = const Duration(milliseconds: 500),
  })  : _page = initialPage,
        _searchDebouncer = AtomicDebouncer(delay: debounceDuration);

  int _page;
  int _lastPage = 1;
  bool _pageLoading = false;

  String _searchQuery = '';
  final AtomicDebouncer _searchDebouncer;

  /// The initial page number for pagination.
  final int initialPage;

  /// The duration for debouncing search queries.
  final Duration debounceDuration;

  /// The current page number in pagination.
  int get page => _page;

  /// The last available page number in pagination.
  int get lastPage => _lastPage;

  /// True if a page is currently being loaded.
  bool get pageLoading => _pageLoading;

  /// The current search query.
  String get searchQuery => _searchQuery;

  /// True if there are more pages to load.
  bool get hasMorePages => _page < _lastPage;

  /// True if the current page is the first page.
  bool get isFirstPage => _page == 1;

  /// True if the current page is the last page.
  bool get isLastPage => _page >= _lastPage;

  /// Increases the current page number by one.
  ///
  /// Notifies listeners.
  void increasePage() {
    if (hasMorePages) {
      _page++;
      notifyListeners();
    }
  }

  /// Decreases the current page number by one.
  ///
  /// Notifies listeners.
  void decreasePage() {
    if (_page > 1) {
      _page--;
      notifyListeners();
    }
  }

  /// Sets the current page number.
  ///
  /// [page] must be greater than 0 and less than or equal to [lastPage].
  /// Notifies listeners.
  void setPage(int page) {
    if (page > 0 && page <= _lastPage) {
      _page = page;
      notifyListeners();
    }
  }

  /// Sets the last available page number.
  ///
  /// [lastPage] must be greater than 0.s
  /// Notifies listeners.
  void setLastPage(int lastPage) {
    if (lastPage > 0) {
      _lastPage = lastPage;
      notifyListeners();
    }
  }

  /// Sets the loading state of the page.
  ///
  /// Notifies listeners if the value changes.
  set pageLoading(bool value) {
    if (_pageLoading != value) {
      _pageLoading = value;
      notifyListeners();
    }
  }

  /// Sets the current search query.
  ///
  /// Notifies listeners if the value changes.
  set searchQuery(String value) {
    if (_searchQuery != value) {
      _searchQuery = value;
      notifyListeners();
    }
  }

  /// Updates the search query and debounces a callback.
  ///
  /// [query] is the new search string.
  /// [onDebounce] is an optional callback executed after the debounce delay.
  void updateSearchQuery(String query, {VoidCallback? onDebounce}) {
    searchQuery = query;
    _searchDebouncer.debounce(() {
      onDebounce?.call();
    });
  }

  /// Sets the debounce duration for search queries.
  void setDebouncerDuration(Duration duration) {
    _searchDebouncer.delay = duration;
  }

  /// Debounces a given callback function.
  void debounce(VoidCallback callback) {
    _searchDebouncer.debounce(callback);
  }

  /// Resets the pagination state to its initial values.
  ///
  /// Notifies listeners.
  void resetPagination() {
    _page = initialPage;
    _lastPage = 1;
    _pageLoading = false;
    notifyListeners();
  }

  /// Resets the search query and cancels any pending debounced searches.
  ///
  /// Notifies listeners.
  void resetSearch() {
    _searchQuery = '';
    _searchDebouncer.cancel();
    notifyListeners();
  }

  /// Resets both pagination and search states.
  ///
  /// Notifies listeners.
  void reset() {
    resetPagination();
    resetSearch();
  }

  /// Abstract method to be implemented by subclasses for loading data.
  ///
  /// This method should contain the logic for fetching data based on the
  /// current pagination and search states.
  @mustCallSuper
  Future<void> loadData();

  /// Refreshes the data by resetting pagination and reloading data.
  ///
  /// Calls [reset] and then [loadData].
  Future<void> refresh() async {
    reset();
    await loadData();
  }

  /// Loads the next page of data if available and not currently loading.
  ///
  /// Calls [increasePage] and then [loadData].
  Future<void> loadNextPage() async {
    if (hasMorePages && !pageLoading) {
      increasePage();
      await loadData();
    }
  }

  /// Initiates a search operation.
  ///
  /// Updates the search query, resets pagination, and then loads data.
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
