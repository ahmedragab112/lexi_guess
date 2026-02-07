import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';

class ResultReviewsSection extends StatelessWidget {
  const ResultReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> reviews = [
      {
        'name': 'Alex J.',
        'comment': 'Top tier level! Challenging but fair.',
        'stars': '5',
      },
      {
        'name': 'Elena S.',
        'comment': 'The satire word was a clever pick!',
        'stars': '4',
      },
      {
        'name': 'Marcus.',
        'comment': 'Almost missed the timer. Intense!',
        'stars': '5',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LEVEL REVIEWS',
          style: AppTextStyles.caption.copyWith(letterSpacing: 2),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final r = reviews[index];
              return Container(
                width: 200.w,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          r['name']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFACC15),
                              size: 10,
                            ),
                            Text(
                              r['stars']!,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      r['comment']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
