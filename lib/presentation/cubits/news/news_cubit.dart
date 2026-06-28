import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/news_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepo;
  final AuthRepository _authRepo;

  int _currentPage = 0;
  final List<NewsModel> _allNews = [];
  String? _category;

  NewsCubit(this._newsRepo, this._authRepo) : super(NewsInitial());

  /// Filter the feed by category. Pass null (or empty) for "All".
  Future<void> selectCategory(String? category) async {
    final normalized = (category == null || category.isEmpty) ? null : category;
    if (normalized == _category) return;
    _category = normalized;
    await loadNews(refresh: true);
  }

  Future<void> loadNews({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _allNews.clear();
    }
    if (_currentPage == 0) emit(NewsLoading());

    try {
      final news =
          await _newsRepo.fetchNews(page: _currentPage, category: _category);
      // ignore: avoid_print
      print('[NewsCubit] fetched ${news.length} articles (page $_currentPage)');
      final savedIds = await _getSavedIds(); // safe — returns {} for guests
      _allNews.addAll(news);
      _currentPage++;
      emit(NewsLoaded(
        news: List.from(_allNews),
        savedIds: savedIds,
        hasMore: news.length == 10,
        activeCategory: _category,
      ));
    } catch (e) {
      // ignore: avoid_print
      print('[NewsCubit] loadNews error: $e');
      // Keep any previously loaded news visible on refresh failure
      final prev = state;
      if (prev is NewsLoaded) {
        emit(prev);
      } else {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! NewsLoaded || !current.hasMore) return;

    try {
      final news =
          await _newsRepo.fetchNews(page: _currentPage, category: _category);
      final savedIds = await _getSavedIds();
      _allNews.addAll(news);
      _currentPage++;
      emit(current.copyWith(
        news: List.from(_allNews),
        savedIds: savedIds,
        hasMore: news.length == 10,
      ));
    } catch (_) {}
  }

  Future<void> toggleSave(String newsId) async {
    final user = _authRepo.currentUser;
    if (user == null) return;
    final current = state;
    if (current is! NewsLoaded) return;

    final isSaved = current.savedIds.contains(newsId);
    final newSavedIds = Set<String>.from(current.savedIds);

    if (isSaved) {
      newSavedIds.remove(newsId);
      await _newsRepo.unsaveNews(user.id, newsId);
    } else {
      newSavedIds.add(newsId);
      await _newsRepo.saveNews(user.id, newsId);
    }

    emit(current.copyWith(savedIds: newSavedIds));
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      loadNews(refresh: true);
      return;
    }
    emit(NewsSearchLoading());
    try {
      final results = await _newsRepo.searchNews(query);
      emit(NewsSearchLoaded(results));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<Set<String>> _getSavedIds() async {
    final user = _authRepo.currentUser;
    if (user == null) return {};
    try {
      return (await _newsRepo.getSavedNewsIds(user.id)).toSet();
    } catch (_) {
      return {};
    }
  }
}
