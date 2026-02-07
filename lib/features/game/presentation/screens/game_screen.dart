import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/routes/result_route_args.dart';
import 'package:lexi_guess/core/widgets/bottom_curve_clipper.dart';
import 'package:lexi_guess/features/game/presentation/cubit/game_cubit.dart';
import 'package:lexi_guess/features/game/presentation/cubit/game_state.dart';
import 'package:lexi_guess/features/game/presentation/widgets/found_words_display.dart';
import 'package:lexi_guess/features/game/presentation/widgets/letter_grid.dart';
import 'package:lexi_guess/features/game/presentation/widgets/game_header_bar.dart';
import 'package:lexi_guess/features/game/presentation/widgets/game_timer.dart';
import 'package:lexi_guess/features/game/presentation/widgets/current_word_display.dart';
import 'package:lexi_guess/features/game/presentation/utils/game_helpers.dart';
import 'package:lexi_guess/core/theme/app_theme_extension.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';
import 'package:lexi_guess/core/widgets/app_snack_bar.dart';

class GameScreen extends StatefulWidget {
  final int levelId;
  const GameScreen({super.key, this.levelId = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    context.read<GameCubit>().loadLevel(widget.levelId);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(gradient: themeExt.scaffoldGradient),
      child: Scaffold(
        backgroundColor: AppColors.surface,
        extendBody: true,
        bottomNavigationBar: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            if (state.status == GameStatus.initial ||
                state.status == GameStatus.loading) {
              return const SizedBox.shrink();
            }
            return SafeArea(
              child: GlassContainer(
                color:
                    Theme.of(
                      context,
                    ).bottomNavigationBarTheme.backgroundColor ??
                    Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GlassContainer(
                      borderRadius: BorderRadius.circular(20.r),
                      padding: EdgeInsets.all(12.r),
                      child: GestureDetector(
                        onTap: () {
                          context.read<GameCubit>().clearInput();
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 24.r,
                        ),
                      ),
                    ),

                    GlassContainer(
                      borderRadius: BorderRadius.circular(25.r),
                      padding: EdgeInsets.symmetric(
                        horizontal: 35.w,
                        vertical: 12.h,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.read<GameCubit>().submitInput();
                        },
                        child: Text(
                          'SUBMIT',
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GlassContainer(
                          borderRadius: BorderRadius.circular(20.r),
                          padding: EdgeInsets.all(12.r),
                          child: GestureDetector(
                            onTap: () {
                              context.read<GameCubit>().useHint();
                            },
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: AppColors.accent,
                              size: 24.r,
                            ),
                          ),
                        ),
                        if (state.hintsRemaining > 0)
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                              constraints: BoxConstraints(
                                minWidth: 18.r,
                                minHeight: 18.r,
                              ),
                              child: Text(
                                '${state.hintsRemaining}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        body: BlocListener<GameCubit, GameState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.status == GameStatus.won) {
              _confettiController.play();
              _showWinOverlay(context, state);

              Future.delayed(const Duration(seconds: 4), () {
                if (mounted) {
                  final puzzle = state.currentPuzzle;
                  if (puzzle != null) {
                    context.push(
                      '/result',
                      extra: ResultRouteArgs(
                        level: puzzle.level,
                        stars: state.starsEarned,
                        timeTaken: puzzle.timeLimitSeconds - state.timeLeft,
                        foundWords: state.foundWords.toList(),
                        totalWords: puzzle.targetWords.length,
                      ),
                    );
                  }
                }
              });
            } else if (state.status == GameStatus.lost) {
              _showFailedDialog(context, state);
            } else if (state.status == GameStatus.error &&
                state.errorMessage != null) {
              AppSnackBar.error(context, state.errorMessage!);
            } else if (state.errorMessage != null &&
                state.errorMessage!.startsWith('HINT:')) {
              AppSnackBar.hint(
                context,
                state.errorMessage!.replaceFirst('HINT: ', ''),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipPath(
                                    clipper: BottomCurveClipper(),
                                    child: SizedBox(
                                      height: 0.30.sh,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          GameHeaderBar(
                                            levelId: widget.levelId,
                                          ),
                                          Expanded(
                                            child: BlocBuilder<GameCubit, GameState>(
                                              builder: (context, state) {
                                                return Center(
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16.r,
                                                          ),
                                                      child: FoundWordsDisplay(
                                                        foundWords: state
                                                            .foundWords
                                                            .toList(),
                                                        targetWords:
                                                            state
                                                                .currentPuzzle
                                                                ?.targetWords ??
                                                            [],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Transform.translate(
                                    offset: Offset(0, 0.13.sh),
                                    child: BlocBuilder<GameCubit, GameState>(
                                      buildWhen: (previous, current) =>
                                          previous.timeLeft != current.timeLeft,
                                      builder: (context, state) {
                                        return GameTimer(
                                          timeLeft: state.timeLeft,
                                          formatTime: GameHelpers.formatTime,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50.h),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CONNECT LETTERS',
                                      style: AppTextStyles.caption.copyWith(
                                        color: themeExt.textColor.withOpacity(
                                          0.5,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    BlocBuilder<GameCubit, GameState>(
                                      builder: (context, state) {
                                        if (state.status ==
                                            GameStatus.loading) {
                                          return Text(
                                            ' Loading...',
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                  color: themeExt.textColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),

                              BlocBuilder<GameCubit, GameState>(
                                buildWhen: (previous, current) =>
                                    previous.currentInput !=
                                    current.currentInput,
                                builder: (context, state) {
                                  return CurrentWordDisplay(
                                    currentInput: state.currentInput,
                                  );
                                },
                              ),
                              SizedBox(height: 15.h),

                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 15.h,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 0.40.sh,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.r),
                                    topRight: Radius.circular(40.r),
                                  ),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: BlocBuilder<GameCubit, GameState>(
                                  builder: (context, state) {
                                    if (state.currentPuzzle == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return LetterGrid(
                                      letters:
                                          state.currentPuzzle!.availableLetters,
                                      onLetterTap: (String letter) {
                                        context.read<GameCubit>().addLetter(
                                          letter,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWinOverlay(BuildContext context, GameState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Container(
            padding: EdgeInsets.all(30.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                ),
                Icon(
                      Icons.emoji_events,
                      size: 80.r,
                      color: const Color(0xFFFACC15),
                    )
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.elasticOut)
                    .shake(delay: 500.ms),
                SizedBox(height: 20.h),
                Text(
                  'Level Complete!',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28.sp,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) =>
                        Icon(
                              index < state.starsEarned
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 40.r,
                              color: const Color(0xFFFACC15),
                            )
                            .animate(
                              delay: Duration(
                                milliseconds: 500 + (index * 100),
                              ),
                            )
                            .scale(curve: Curves.elasticOut),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'Navigating to results...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFailedDialog(BuildContext context, GameState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Container(
            padding: EdgeInsets.all(30.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_off, size: 80.r, color: AppColors.error)
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.elasticOut)
                    .shake(delay: 500.ms),
                SizedBox(height: 20.h),
                Text(
                  'Time\'s Up!',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28.sp,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                SizedBox(height: 10.h),
                Text(
                  'You ran out of time. Try again!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 500.ms),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        context.go('/levels');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map, color: Colors.white, size: 18.r),
                            SizedBox(width: 8.w),
                            Text(
                              'Levels',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        context.read<GameCubit>().loadLevel(widget.levelId);
                      },
                      child: GlassContainer(
                        borderRadius: BorderRadius.circular(25.r),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 18.r,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Retry',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
