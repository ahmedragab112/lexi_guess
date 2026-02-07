import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/network/audio_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: themeExt.scaffoldGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                
                const _HomeLogo().animate().fadeIn(duration: 800.ms).scale(),

                const Spacer(),

                
                _HomeOption(
                  title: 'START ADVENTURE',
                  subtitle: 'Explore the map & solve puzzles',
                  icon: Icons.map_outlined,
                  color: themeExt.accentColor,
                  onTap: () => context.push(AppRoutes.levels),
                ).animate().slideY(begin: 0.5, delay: 200.ms).fadeIn(),

                SizedBox(height: 20.h),

                _HomeOption(
                  title: 'SETTINGS',
                  subtitle: 'Customize your experience',
                  icon: Icons.settings_outlined,
                  color: AppColors.secondary,
                  onTap: () => context.push('/settings'),
                ).animate().slideY(begin: 0.5, delay: 400.ms).fadeIn(),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeLogo extends StatelessWidget {
  const _HomeLogo();

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;
    return Column(
      children: [
        Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeExt.accentColor.withOpacity(0.1),
                border: Border.all(
                  color: themeExt.accentColor.withOpacity(0.3),
                  width: 2.w,
                ),
              ),
              child: Icon(
                Icons.psychology,
                size: 80.r,
                color: themeExt.accentColor,
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .shimmer(duration: 2.seconds, color: Colors.white24),
        SizedBox(height: 20.h),
        Text(
          'WORD FLUX',
          style: AppTextStyles.h1.copyWith(
            fontSize: 40.sp,
            letterSpacing: 4.w,
            color: themeExt.textColor,
          ),
        ),
        Text(
          'The Lexi Guess Journey',
          style: AppTextStyles.bodyMedium.copyWith(
            color: themeExt.secondaryTextColor,
            letterSpacing: 1.w,
          ),
        ),
      ],
    );
  }
}

class _HomeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AudioService.playTap();
        onTap();
      },
      child: GlassContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 28.r),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h2.copyWith(fontSize: 20.sp),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
