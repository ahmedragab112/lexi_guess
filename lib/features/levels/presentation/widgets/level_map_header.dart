import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/theme/app_theme_extension.dart';

class LevelMapHeader extends StatelessWidget {
  final int unlocked;
  const LevelMapHeader({super.key, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: themeExt.glassBaseColor,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: themeExt.textColor),
                onPressed: () => context.pop(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: themeExt.glassBaseColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'UNLOCKED: $unlocked',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeExt.textColor,
                ),
              ),
            ),
            // Help/Info
            CircleAvatar(
              backgroundColor: themeExt.glassBaseColor,
              child: Icon(Icons.info_outline, color: themeExt.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
