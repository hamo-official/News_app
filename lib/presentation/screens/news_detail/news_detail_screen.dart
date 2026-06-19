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

  String _fullDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _readTime(String text) {
    final words = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    final minutes = (words / 200).ceil().clamp(1, 12);
    return '$minutes min read';
  }

  String _descriptionText() {
    final description = news.description.trim();
    if (description.isNotEmpty) {
      return description;
    }
    return 'No description available for this story yet.';
  }

  @override
  Widget build(BuildContext context) {
    final descriptionText = _descriptionText();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 0.5.sh,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: news.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                placeholder: (_, _) => Container(color: const Color.fromARGB(255, 10, 12, 15)),
              errorWidget: (_, _, err) => Container(
                color: AppColors.divider,
                child: Center(
                  child: Icon(Icons.image_not_supported_outlined,
                      color: AppColors.textSecondary, size: 48.sp),
                ),
              ),
            ),
          ),),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleActionButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  BlocBuilder<NewsCubit, NewsState>(
                    builder: (context, state) {
                      final isSaved = state is NewsLoaded &&
                          state.savedIds.contains(news.id);
                      return _CircleActionButton(
                        icon: isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        onTap: () =>
                            context.read<NewsCubit>().toggleSave(news.id),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: (0.5.sh - 70.h),
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [  Center(
                      child: Text(
                                _fullDate(news.createdAt),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                    ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            news.category ?? 'General',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Center(
                        child: Text(
                          news.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 14.sp, color: AppColors.textSecondary),
                          
                            Container(
                              width: 3.w,
                              height: 3.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              _readTime(descriptionText),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Divider(color: AppColors.divider, height: 1.h),
                      SizedBox(height: 18.h),
                      Text(
                        descriptionText,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          height: 1.72,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        timeago.format(news.createdAt),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18.sp),
      ),
    );
  }
}
