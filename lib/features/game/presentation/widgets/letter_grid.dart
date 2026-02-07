import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';

class LetterGrid extends StatelessWidget {
  final List<String> letters;
  final Function(String) onLetterTap;

  const LetterGrid({
    super.key,
    required this.letters,
    required this.onLetterTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> blockColors = [
      AppColors.blockBlue,
      AppColors.blockIndigo,
      AppColors.blockTerracotta,
      AppColors.blockDarkGrey,
      AppColors.blockBeige,
      AppColors.accent,
      AppColors.blockGreen,
      AppColors.secondary,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1.15, // Wider than tall to save vertical space
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final color = blockColors[index % blockColors.length];
        final isLight = color.computeLuminance() > 0.5;

        return GestureDetector(
          onTap: () => onLetterTap(letters[index]),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              letters[index],
              style: AppTextStyles.h2.copyWith(
                color: isLight ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp, // Slightly smaller
              ),
            ),
          ),
        );
      },
    );
  }
}
