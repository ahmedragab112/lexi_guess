import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_guess/core/routes/app_routes.dart';
import 'package:lexi_guess/core/routes/game_route_args.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/core/theme/app_theme_extension.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';
import 'package:lexi_guess/features/game/presentation/cubit/levels_cubit.dart';
import 'package:lexi_guess/features/game/presentation/cubit/levels_state.dart';
import 'package:lexi_guess/features/game/data/models/level_entities.dart';
import 'package:lexi_guess/features/levels/presentation/widgets/level_map_header.dart';
import 'package:lexi_guess/features/levels/presentation/widgets/level_map_node.dart';
import 'package:lexi_guess/features/levels/presentation/widgets/level_map_painters.dart';

class LevelMapScreen extends StatefulWidget {
  const LevelMapScreen({super.key});

  @override
  State<LevelMapScreen> createState() => _LevelMapScreenState();
}

class _LevelMapScreenState extends State<LevelMapScreen>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();

  
  final List<Offset> _positions = [
    Offset(400.w, 1800.h),
    Offset(600.w, 1700.h),
    Offset(500.w, 1500.h),
    Offset(700.w, 1400.h),
    Offset(850.w, 1250.h),
    Offset(650.w, 1100.h),
    Offset(450.w, 1000.h),
    Offset(550.w, 850.h),
    Offset(750.w, 750.h),
    Offset(950.w, 650.h),
    Offset(800.w, 500.h),
    Offset(600.w, 400.h),
    Offset(400.w, 300.h),
    Offset(250.w, 150.h),
  ];

  bool _hasFocused = false;

  @override
  void initState() {
    super.initState();
    context.read<LevelsCubit>().fetchProgress();
  }

  void _focusOnPoint(Offset targetPos) {
    final double zoom = 1.0;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final translation = Offset(
      (screenWidth / 2) - (targetPos.dx * zoom),
      (screenHeight / 2) - (targetPos.dy * zoom),
    );

    final matrix = Matrix4.identity()
      ..translate(translation.dx, translation.dy)
      ..scale(zoom);

    
    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: matrix,
        ).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
        );

    animation.addListener(() {
      _transformationController.value = animation.value;
    });

    animationController.forward().then((_) => animationController.dispose());
  }

  void _focusOnCurrentLevel(LevelsState state) {
    
    if (state.status != LevelsStatus.loaded) return;

    final currentLevel = state.latestUnlockedLevel;
    
    
    final targetIndex = (currentLevel - 1) % _positions.length;

    
    
    
    
    
    
    

    
    

    if (!_hasFocused) {
      
      final targetPos = _positions[targetIndex];
      final double zoom = 1.0;
      final size = MediaQuery.of(context).size;
      final screenWidth = size.width;
      final screenHeight = size.height;
      final translation = Offset(
        (screenWidth / 2) - (targetPos.dx * zoom),
        (screenHeight / 2) - (targetPos.dy * zoom),
      );
      _transformationController.value = Matrix4.identity()
        ..translate(translation.dx, translation.dy)
        ..scale(zoom);

      setState(() {
        _hasFocused = true;
      });
    } else {
      
      _focusOnPoint(_positions[targetIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeExt.scaffoldGradient),
        child: BlocListener<LevelsCubit, LevelsState>(
          listenWhen: (previous, current) =>
              previous.status == LevelsStatus.loading &&
              current.status == LevelsStatus.loaded,
          listener: (context, state) {
            if (state.status == LevelsStatus.loaded && !_hasFocused) {
              
              
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _focusOnCurrentLevel(state);
              });
            }
          },
          child: BlocBuilder<LevelsCubit, LevelsState>(
            builder: (context, state) {
              if (state.status == LevelsStatus.loading && !state.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == LevelsStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 48.r,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Failed to load levels',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.errorMessage ?? 'Unknown error',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: themeExt.textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<LevelsCubit>().fetchProgress(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeExt.accentColor,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: CustomPaint(painter: GridPatternPainter()),
                    ),
                  ),

                  InteractiveViewer(
                    transformationController: _transformationController,
                    boundaryMargin: EdgeInsets.symmetric(
                      horizontal: 500.w,
                      vertical: 500.h,
                    ),
                    minScale: 0.1,
                    maxScale: 2.5,
                    constrained: false,
                    child: SizedBox(
                      width: 1200.w,
                      height: 2000.h,
                      child: Stack(
                        children: [
                          
                          CustomPaint(
                            painter: MapPathPainter(
                              positions: _positions,
                              latestUnlockedLevel: state.latestUnlockedLevel,
                            ),
                            size: Size(1200.w, 2000.h), 
                          ),

                          
                          ...List.generate(state.totalLevels, (index) {
                            final levelNumber = index + 1;
                            
                            final pos = _positions[index % _positions.length];
                            final progress = state.progress.firstWhere(
                              (p) => p.levelNumber == levelNumber,
                              orElse: () =>
                                  LevelProgress(levelNumber: levelNumber),
                            );

                            final isUnlocked =
                                levelNumber <= state.latestUnlockedLevel;
                            final isCurrent =
                                levelNumber == state.latestUnlockedLevel;

                            return Positioned(
                              left: pos.dx - 35.r,
                              top: pos.dy - 35.r,
                              child: LevelMapNode(
                                levelNumber: levelNumber,
                                isUnlocked: isUnlocked,
                                isCurrent: isCurrent,
                                progress: progress,
                                onTap: isUnlocked
                                    ? () => context.push(
                                        AppRoutes.game,
                                        extra: GameRouteArgs(
                                          levelId: levelNumber,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  
                  LevelMapHeader(unlocked: state.latestUnlockedLevel),

                  
                  Positioned(
                    bottom: 20.h,
                    right: 20.w,
                    child: GestureDetector(
                      onTap: () => _focusOnCurrentLevel(state),
                      child: GlassContainer(
                        child: Container(
                          padding: EdgeInsets.all(16.r),

                          child: Icon(
                            Icons.my_location,
                            color: themeExt.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
