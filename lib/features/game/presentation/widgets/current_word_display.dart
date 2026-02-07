import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';

class CurrentWordDisplay extends StatelessWidget {
  final String currentInput;

  const CurrentWordDisplay({super.key, required this.currentInput});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child:
              Text(
                    currentInput.isEmpty ? 'Tap letters...' : currentInput,
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 28.sp,
                      color: AppColors.accent,
                    ),
                  )
                  .animate(target: currentInput.isNotEmpty ? 1 : 0)
                  .scale(duration: 200.ms, curve: Curves.easeOutBack),
        ),
      ],
    );
  }
}
