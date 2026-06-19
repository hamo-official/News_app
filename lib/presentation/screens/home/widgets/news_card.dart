import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel news;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const NewsCard({
    super.key,
    required this.news,
    required this.isSaved,
    required this.onTap,
    required this.onSave,
  });

  String _shortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22.r)),
                  child: CachedNetworkImage(
                    imageUrl: news.image,
                    height: 214.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      height: 214.h,
                      color: AppColors.divider,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => Container(
                      height: 214.h,
                      color: AppColors.divider,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
                if (news.category != null)
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        news.category!,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              size: 12.sp, color: AppColors.textSecondary),
                          SizedBox(width: 5.w),
                          Text(
                            _shortDate(news.createdAt),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 3.w,
                            height: 3.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _readTime(descriptionText),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: onSave,
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: isSaved
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 20.sp,
                          ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    news.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 29.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.22,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    descriptionText,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15.sp,
                      height: 1.65,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),
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
          ],
        ),
      ),
    );
  }
}
