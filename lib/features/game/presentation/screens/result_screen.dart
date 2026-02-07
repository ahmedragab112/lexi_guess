import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/features/game/presentation/cubit/levels_cubit.dart';
import 'package:lexi_guess/core/routes/app_routes.dart';
import 'package:lexi_guess/core/routes/result_route_args.dart';
import 'package:lexi_guess/features/game/presentation/widgets/result_header_section.dart';
import 'package:lexi_guess/features/game/presentation/widgets/result_star_section.dart';
import 'package:lexi_guess/features/game/presentation/widgets/result_stat_card.dart';
import 'package:lexi_guess/features/game/presentation/widgets/result_reviews_section.dart';
import 'package:lexi_guess/features/game/presentation/utils/game_helpers.dart';

class ResultScreen extends StatelessWidget {
  final ResultRouteArgs args;

  const ResultScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Colors.black],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                ResultHeaderSection(level: args.level),
                SizedBox(height: 30.h),
                ResultStarSection(stars: args.stars),
                SizedBox(height: 15.h),
                Text(
                  GameHelpers.getFeedbackComment(args.stars),
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 36.sp,
                    color: const Color(0xFFFACC15),
                  ),
                ).animate().fadeIn(delay: 600.ms).scale(),
                SizedBox(height: 10.h),
                Text(
                  'Level ${args.level} Completed!',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 20.sp,
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 800.ms),
                SizedBox(height: 30.h),

                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 15.h,
                  crossAxisSpacing: 15.w,
                  childAspectRatio: 1.4,
                  children: [
                    ResultStatCard(
                      title: 'World Rank',
                      value: '#1,429',
                      icon: Icons.public,
                      color: AppColors.accent,
                    ).animate().fadeIn(delay: 1.seconds).slideX(),
                    ResultStatCard(
                      title: 'Winning Rate',
                      value: '94.2%',
                      icon: Icons.trending_up,
                      color: AppColors.blockGreen,
                    ).animate().fadeIn(delay: 1.1.seconds).slideX(),
                    ResultStatCard(
                      title: 'Score',
                      value: '${args.foundWords.length * 100}',
                      icon: Icons.emoji_events,
                      color: const Color(0xFFFACC15),
                    ).animate().fadeIn(delay: 1.2.seconds).slideX(),
                    ResultStatCard(
                      title: 'Avg. Wins',
                      value: '4.8 stars',
                      icon: Icons.star_half,
                      color: AppColors.blockIndigo,
                    ).animate().fadeIn(delay: 1.3.seconds).slideX(),
                  ],
                ),

                SizedBox(height: 30.h),

                
                const ResultReviewsSection().animate().fadeIn(
                  delay: 1.5.seconds,
                ),

                SizedBox(height: 30.h),

                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.levels),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'NEXT ADVENTURE',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2.w,
                    ),
                  ),
                ).animate().fadeIn(delay: 1.8.seconds).scale(),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
