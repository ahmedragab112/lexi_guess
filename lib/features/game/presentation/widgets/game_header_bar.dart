import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';
import 'package:lexi_guess/features/game/presentation/cubit/game_cubit.dart';
import 'package:lexi_guess/features/game/presentation/cubit/game_state.dart';

class GameHeaderBar extends StatelessWidget {
  final int levelId;

  const GameHeaderBar({super.key, required this.levelId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Back Button
          GlassContainer(
            borderRadius: 12.r,
            padding: EdgeInsets.all(8.r),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18.r,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Level Label
          Text(
            'LEVEL $levelId',
            style: AppTextStyles.h3.copyWith(color: Colors.white70),
          ),
          const Spacer(),
          // Score Badge
          BlocBuilder<GameCubit, GameState>(
            buildWhen: (previous, current) =>
                previous.foundWords.length != current.foundWords.length,
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.stars, color: AppColors.accent, size: 18.r),
                    SizedBox(width: 4.w),
                    Text(
                      '${state.foundWords.length * 100}',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
