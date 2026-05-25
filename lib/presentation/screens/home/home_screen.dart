import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';
import '../../cubits/news/news_cubit.dart';
import '../../cubits/news/news_state.dart';
import 'widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().loadNews();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NewsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.neutral,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () {},
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Icon(Icons.article_rounded,
                  color: Colors.white, size: 16.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              'NovaNews',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching
                  ? Icons.close_rounded
                  : Icons.search_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<NewsCubit>().loadNews(refresh: true);
                }
              });
            },
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.person_outline_rounded,
                    color: AppColors.textPrimary),
                onPressed: () {
                  if (state is AuthAuthenticated) {
                    context.push(AppRouter.profile);
                  } else {
                    context.push(AppRouter.login);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSearching)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  hintStyle: TextStyle(
                      color: AppColors.textSecondary, fontSize: 14.sp),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onChanged: (q) => context.read<NewsCubit>().search(q),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.fromLTRB(50.w, 8.h, 25.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'The Morning Brief',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50.w, 8.h/, 25.w, 0),
                    child: SizedBox(height: 10.h,),
                  ),
                  Text(
                    '   Curated insights for the modern \nprofessional. Stay ahead of the curve.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
          Expanded(
            child: BlocBuilder<NewsCubit, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading || state is NewsSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  );
                }

                if (state is NewsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: AppColors.tertiary, size: 48.sp),
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              context.read<NewsCubit>().loadNews(refresh: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is NewsSearchLoaded) {
                  if (state.results.isEmpty) {
                    return _buildEmptyState('No results found.');
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.results.length,
                    itemBuilder: (context, index) {
                      final news = state.results[index];
                      return NewsCard(
                        news: news,
                        isSaved: false,
                        onTap: () =>
                            context.push(AppRouter.newsDetail, extra: news),
                        onSave: () {},
                      );
                    },
                  );
                }

                if (state is NewsLoaded) {
                  if (state.news.isEmpty) {
                    return _buildEmptyState('No news available.');
                  }
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        context.read<NewsCubit>().loadNews(refresh: true),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: state.news.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.news.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }
                        final news = state.news[index];
                        return NewsCard(
                          news: news,
                          isSaved: state.savedIds.contains(news.id),
                          onTap: () =>
                              context.push(AppRouter.newsDetail, extra: news),
                          onSave: () =>
                              context.read<NewsCubit>().toggleSave(news.id),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.newspaper_rounded,
              color: AppColors.textSecondary, size: 64.sp),
          SizedBox(height: 16.h),
          Text(
            message,
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
