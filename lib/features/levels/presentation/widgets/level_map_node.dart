import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/theme/app_theme_extension.dart';
import 'package:lexi_guess/features/game/data/models/level_entities.dart';

class LevelMapNode extends StatelessWidget {
  final int levelNumber;
  final bool isUnlocked;
  final bool isCurrent;
  final LevelProgress? progress;
  final VoidCallback? onTap;

  const LevelMapNode({
    super.key,
    required this.levelNumber,
    required this.isUnlocked,
    required this.isCurrent,
    this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
                width: 70.r,
                height: 70.r,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? themeExt.accentColor
                      : Colors.grey.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? Colors.white : themeExt.glassBorderColor,
                    width: isCurrent ? 3.r : 1.r,
                  ),
                  boxShadow: [
                    if (isUnlocked)
                      BoxShadow(
                        color: (isCurrent ? themeExt.accentColor : Colors.black)
                            .withOpacity(0.3),
                        blurRadius: 10.r,
                        spreadRadius: 1.r,
                      ),
                  ],
                ),
                child: Center(
                  child: isUnlocked
                      ? Text(
                          '$levelNumber',
                          style: AppTextStyles.h2.copyWith(
                            color: isCurrent
                                ? Colors.white
                                : themeExt.textColor,
                            fontSize: 24.sp,
                            shadows: [
                              if (isCurrent)
                                const Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                            ],
                          ),
                        )
                      : Icon(Icons.lock, color: Colors.white54, size: 30.r),
                ),
              )
              .animate(
                target: isCurrent ? 1 : 0,
                onPlay: (c) => c.repeat(reverse: true),
              )
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 1000.ms,
                curve: Curves.easeInOut,
              ),
          if (isUnlocked)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final isEarned = index < (progress?.starsEarned ?? 0);
                  return Icon(
                        Icons.star_rounded,
                        color: isEarned
                            ? const Color(0xFFFACC15)
                            : Colors.white.withOpacity(0.2), // Gold or Glass
                        size: 16.r,
                      )
                      .animate(delay: (index * 100).ms)
                      .scale(duration: 400.ms, curve: Curves.elasticOut)
                      .fadeIn(duration: 300.ms);
                }),
              ),
            ),
        ],
      ),
    );
  }
}
