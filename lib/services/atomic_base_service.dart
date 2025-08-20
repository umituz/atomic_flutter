import 'package:flutter/foundation.dart';
import '../utilities/atomic_debouncer.dart';

abstract class AtomicBaseService extends ChangeNotifier {
  AtomicBaseService({
    this.initialPage = 1,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : _page = initialPage,
       _searchDebouncer = AtomicDebouncer(delay: debounceDuration);

  int _page;
  int _lastPage = 1;
  bool _pageLoading = false;
  
  String _searchQuery = '';
  final AtomicDebouncer _searchDebouncer;
  
  final int initialPage;
  final Duration debounceDuration;

  int get page => _page;
  
  int get lastPage => _lastPage;
  
  bool get pageLoading => _pageLoading;
  
  String get searchQuery => _searchQuery;
  
  bool get hasMorePages => _page < _lastPage;
  
  bool get isFirstPage => _page == 1;
  
  bool get isLastPage => _page >= _lastPage;

  void increasePage() {
    if (hasMorePages) {
      _page++;
      notifyListeners();
    }
  }

  void decreasePage() {
    if (_page > 1) {
      _page--;
      notifyListeners();
    }
  }

  void setPage(int page) {
    if (page > 0 && page <= _lastPage) {
      _page = page;
      notifyListeners();
    }
  }

  void setLastPage(int lastPage) {
    if (lastPage > 0) {
      _lastPage = lastPage;
      notifyListeners();
    }
  }

  set pageLoading(bool value) {
    if (_pageLoading != value) {
      _pageLoading = value;
      notifyListeners();
    }
  }

  set searchQuery(String value) {
    if (_searchQuery != value) {
      _searchQuery = value;
      notifyListeners();
    }
  }

  void updateSearchQuery(String query, {VoidCallback? onDebounce}) {
    searchQuery = query;
    _searchDebouncer.debounce(() {
      onDebounce?.call();
    });
  }

  void setDebouncerDuration(Duration duration) {
    _searchDebouncer.delay = duration;
  }

  void debounce(VoidCallback callback) {
    _searchDebouncer.debounce(callback);
  }

  void resetPagination() {
    _page = initialPage;
    _lastPage = 1;
    _pageLoading = false;
    notifyListeners();
  }

  void resetSearch() {
    _searchQuery = '';
    _searchDebouncer.cancel();
    notifyListeners();
  }

  void reset() {
    resetPagination();
    resetSearch();
  }

  Future<void> loadData();

  Future<void> refresh() async {
    reset();
    await loadData();
  }

  Future<void> loadNextPage() async {
    if (hasMorePages && !pageLoading) {
      increasePage();
      await loadData();
    }
  }

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

