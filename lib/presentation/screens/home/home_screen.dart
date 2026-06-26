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
import '../../widgets/app_bottom_nav.dart';
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

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      backgroundColor: AppColors.neutral,
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
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
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return GestureDetector(
                  onTap: () => context.go(AppRouter.profile),
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        _initials(state.profile?.fullName ??
                            state.profile?.email ?? 'U'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.person_outline_rounded,
                    color: AppColors.textPrimary),
                onPressed: () => context.push(AppRouter.login),
              );
            },
          ),
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
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Morning Brief',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Curated insights for the modern professional.',
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
                          onPressed: () => context
                              .read<NewsCubit>()
                              .loadNews(refresh: true),
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
                      itemCount:
                          state.news.length + (state.hasMore ? 1 : 0),
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
                          onSave: () => context
                              .read<NewsCubit>()
                              .toggleSave(news.id),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final profile =
                    state is AuthAuthenticated ? state.profile : null;
                final name = profile?.fullName?.isNotEmpty == true
                    ? profile!.fullName!
                    : 'Guest';
                final email = profile?.email ?? '';
                final isAuth = state is AuthAuthenticated;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 24.h),
                  decoration: const BoxDecoration(
                    color: AppColors.textPrimary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32.r,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          _initials(
                              profile?.fullName ?? profile?.email ?? 'G'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        isAuth ? name : 'Welcome!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (isAuth && email.isNotEmpty) ...[
                        SizedBox(height: 2.h),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),
            // Menu items
            _drawerItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.profile);
              },
            ),
            _drawerDivider(),
            _drawerItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                Navigator.of(context).pop();
                context.go(AppRouter.settings);
              },
            ),
            _drawerDivider(),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isAuth = state is AuthAuthenticated;
                if (isAuth) {
                  return _drawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    color: AppColors.tertiary,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.read<AuthCubit>().signOut();
                    },
                  );
                }
                return _drawerItem(
                  icon: Icons.login_rounded,
                  label: 'Sign In',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(AppRouter.login);
                  },
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.article_rounded,
                        color: Colors.white, size: 20.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'NovaNews',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color == AppColors.textPrimary ? AppColors.primary : color,
        size: 22.sp,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
    );
  }

  Widget _drawerDivider() => Divider(
        height: 1,
        thickness: 1,
        indent: 20.w,
        endIndent: 20.w,
        color: AppColors.divider,
      );

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
            style: TextStyle(
                color: AppColors.textSecondary, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
