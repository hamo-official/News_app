import '../../../data/models/news_model.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> news;
  final Set<String> savedIds;
  final bool hasMore;

  /// Currently selected category filter (null = "All").
  final String? activeCategory;

  NewsLoaded({
    required this.news,
    required this.savedIds,
    this.hasMore = true,
    this.activeCategory,
  });

  NewsLoaded copyWith({
    List<NewsModel>? news,
    Set<String>? savedIds,
    bool? hasMore,
    String? activeCategory,
  }) {
    return NewsLoaded(
      news: news ?? this.news,
      savedIds: savedIds ?? this.savedIds,
      hasMore: hasMore ?? this.hasMore,
      activeCategory: activeCategory ?? this.activeCategory,
    );
  }
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}

class NewsSearchLoading extends NewsState {}

class NewsSearchLoaded extends NewsState {
  final List<NewsModel> results;
  NewsSearchLoaded(this.results);
}
