import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/user_profile_model.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _activeCategory; // null = "All"

  // Category filter chips, seeded from saved Reading Preferences.
  static const List<String> _defaultCategories = [
    'Technology',
    'Business',
    'Sports',
    'Health',
    'Politics',
    'Entertainment',
  ];
  List<String> _chipCategories = _defaultCategories;

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().loadNews();
    _scrollController.addListener(_onScroll);
    _loadChipCategories();
  }

  Future<void> _loadChipCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('preferred_categories');
    if (!mounted) return;
    setState(() {
      _chipCategories =
          (saved != null && saved.isNotEmpty) ? saved : _defaultCategories;
    });
  }

  void _onCategoryTap(String? category) {
    setState(() => _activeCategory = category);
    context.read<NewsCubit>().selectCategory(category);
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
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: AppColors.neutral,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final profile =
                      state is AuthAuthenticated ? state.profile : null;
                  final name = (profile?.fullName?.isNotEmpty ?? false)
                      ? profile!.fullName!
                      : 'NovaNews Reader';
                  final email = profile?.email ?? 'Not signed in';
                  return InkWell(
                    onTap: profile == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            context.go(AppRouter.profile);
                          },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 22.h),
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.brightBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.r),
                          bottomRight: Radius.circular(24.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          _drawerAvatar(profile),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isAuthenticated = state is AuthAuthenticated;
                  return ListTile(
                    leading: Icon(
                      isAuthenticated
                          ? Icons.settings_outlined
                          : Icons.person_outline_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      isAuthenticated ? 'Settings' : 'Sign In',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: isAuthenticated
                        ? null
                        : Text(
                            'Access your account',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                    onTap: () {
                      Navigator.of(context).pop();
                      if (isAuthenticated) {
                        context.push(AppRouter.settings);
                      } else {
                        context.push(AppRouter.login);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.neutral,
      appBar: AppBar(
        backgroundColor: AppColors.neutral,
        elevation: 1,
        leadingWidth: 64.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 18.r,
              icon: const Icon(Icons.menu_rounded,
                  color: AppColors.textPrimary, size: 20),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
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
              padding: EdgeInsets.fromLTRB(75.w, 8.h, 25.w, 0),
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
                    padding: EdgeInsets.fromLTRB(75.w, 2.h, 25.w, 0),
                    child: SizedBox(height: 10.h,),
                  ),
                  Text(
                    '   Curated insights for the modern ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("professional. Stay ahead of the curve.",style:TextStyle(color: AppColors.textSecondary,fontSize: 13.sp) ,),
                )],
              ),
            ),
          if (!_isSearching) ...[
            SizedBox(height: 14.h),
            _buildCategoryChips(),
          ],
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
                    return _buildEmptyState(
                      _activeCategory != null
                          ? 'No news in $_activeCategory yet.'
                          : 'No news available.',
                    );
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

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Widget _drawerAvatar(UserProfileModel? profile) {
    final url = profile?.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 28.r,
        backgroundColor: Colors.white24,
        backgroundImage: NetworkImage(url),
      );
    }
    return CircleAvatar(
      radius: 28.r,
      backgroundColor: AppColors.navy,
      child: Text(
        _initials(profile?.fullName ?? profile?.email ?? 'U'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp, 
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    // Full ordered list of chips: All + categories + "Add more".
    final chips = <Widget>[
      _categoryChip(
        label: 'All',
        selected: _activeCategory == null,
        onTap: () => _onCategoryTap(null),
      ),
      for (final cat in _chipCategories)
        _categoryChip(
          label: cat,
          selected: _activeCategory == cat,
          onTap: () => _onCategoryTap(cat),
        ),
      _addMoreChip(),
    ];

    // Split into two balanced rows -> always exactly two lines.
    final half = (chips.length / 2).ceil();
    return Column(
      children: [
        _chipRow(chips.sublist(0, half)),
        SizedBox(height: 8.h),
        _chipRow(chips.sublist(half)),
      ],
    );
  }

  Widget _chipRow(List<Widget> chips) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          for (int i = 0; i < chips.length; i++) ...[
            if (i > 0) SizedBox(width: 8.w),
            chips[i],
          ],
        ],
      ),
    );
  }

  Widget _categoryChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: selected ? AppColors.navy : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _addMoreChip() {
    return GestureDetector(
      onTap: () async {
        await context.push(AppRouter.readingPreferences);
        _loadChipCategories();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryFixed.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16.sp, color: AppColors.navy),
            SizedBox(width: 4.w),
            Text(
              'Add more',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
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
