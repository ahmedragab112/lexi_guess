import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';

class FoundWordsDisplay extends StatelessWidget {
  final List<String> targetWords;
  final List<String> foundWords;

  const FoundWordsDisplay({
    super.key,
    required this.targetWords,
    required this.foundWords,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        alignment: WrapAlignment.center,
        children: targetWords.map((word) {
          final bool isFound = foundWords.contains(word);

          return AnimatedContainer(
                duration: 300.ms,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isFound
                      ? AppColors.blockGreen.withOpacity(0.9)
                      : AppColors.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isFound ? AppColors.blockGreen : Colors.white12,
                    width: 1.w,
                  ),
                  boxShadow: isFound
                      ? [
                          BoxShadow(
                            color: AppColors.blockGreen.withOpacity(0.3),
                            blurRadius: 10.r,
                            spreadRadius: 2.r,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  isFound ? word : '•' * word.length,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isFound ? Colors.white : Colors.white38,
                    fontWeight: isFound ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: isFound ? 0 : 2.w,
                    fontSize: 14.sp,
                  ),
                ),
              )
              .animate(target: isFound ? 1 : 0)
              .shimmer(delay: 0.ms, duration: 1000.ms, color: Colors.white24)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                curve: Curves.elasticOut,
              )
              .then()
              .scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1));
        }).toList(),
      ),
    );
  }
}
