import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_model.dart';

class NewsRepository {
  final SupabaseClient _client;
  static const int _pageSize = 10;

  NewsRepository(this._client);

  Future<List<NewsModel>> fetchNews({int page = 0}) async {
    final response = await _client
        .from('news')
        .select()
        .order('created_at', ascending: false)
        .range(page * _pageSize, (page + 1) * _pageSize - 1);

    return (response as List)
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NewsModel>> searchNews(String query) async {
    final response = await _client
        .from('news')
        .select()
        .or('title.ilike.%$query%,description.ilike.%$query%')
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => NewsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveNews(String userId, String newsId) async {
    await _client.from('saved_news').upsert({
      'user_id': userId,
      'news_id': newsId,
    });
  }

  Future<void> unsaveNews(String userId, String newsId) async {
    await _client
        .from('saved_news')
        .delete()
        .eq('user_id', userId)
        .eq('news_id', newsId);
  }

  Future<List<String>> getSavedNewsIds(String userId) async {
    final response = await _client
        .from('saved_news')
        .select('news_id')
        .eq('user_id', userId);

    return (response as List)
        .map((e) => e['news_id'] as String)
        .toList();
  }
}
