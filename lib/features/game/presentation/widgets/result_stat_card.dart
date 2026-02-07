import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';

class ResultStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ResultStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16.r),
                SizedBox(width: 6.w),
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(color: Colors.white38),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(value, style: AppTextStyles.h2.copyWith(fontSize: 18.sp)),
          ],
        ),
      ),
    );
  }
}
