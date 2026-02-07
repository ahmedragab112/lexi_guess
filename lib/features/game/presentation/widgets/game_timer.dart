import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';

class GameTimer extends StatelessWidget {
  final int timeLeft;
  final String Function(int) formatTime;

  const GameTimer({
    super.key,
    required this.timeLeft,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = timeLeft <= 10;
    final timerColor = isUrgent ? AppColors.error : AppColors.primary;

    return GlassContainer(
      borderRadius: 30.r,
      borderColor: isUrgent ? AppColors.error : AppColors.glassBorder,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Text(
          formatTime(timeLeft),
          style: AppTextStyles.h2.copyWith(
            color: timerColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }
}
