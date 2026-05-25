import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/constants/app_colors.dart';
import '../../../data/models/news_model.dart';
import '../../cubits/news/news_cubit.dart';
import '../../cubits/news/news_state.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary, size: 18),
              ),
            ),
            actions: [
              BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  final isSaved =
                      state is NewsLoaded && state.savedIds.contains(news.id);
                  return GestureDetector(
                    onTap: () =>
                        context.read<NewsCubit>().toggleSave(news.id),
                    child: Container(
                      margin: EdgeInsets.all(8.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: isSaved
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: news.image,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: AppColors.divider),
                errorWidget: (_, _, err) => Container(
                  color: AppColors.divider,
                  child: Icon(Icons.image_not_supported_outlined,
                      color: AppColors.textSecondary, size: 48.sp),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.category != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        news.category!,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  Text(
                    news.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14.sp, color: AppColors.textSecondary),
                      SizedBox(width: 4.w),
                      Text(
                        timeago.format(news.createdAt),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  const Divider(color: AppColors.divider, height: 1),
                  SizedBox(height: 20.h),
                  Text(
                    news.description,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      height: 1.75,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
