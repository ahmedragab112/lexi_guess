import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_routes.dart';
import '../../features/game/presentation/screens/game_screen.dart';
import '../../features/game/presentation/screens/result_screen.dart';
import '../../features/levels/presentation/screens/level_map_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/settings_screen.dart';
import '../../features/game/data/repositories/level_repository.dart';
import '../../features/game/presentation/cubit/game_cubit.dart';
import '../../features/game/presentation/cubit/levels_cubit.dart';
import 'game_route_args.dart';
import 'result_route_args.dart';

final router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.levels,
      name: 'levels',
      builder: (context, state) => BlocProvider(
        create: (context) =>
            LevelsCubit(context.read<LevelRepository>())..fetchProgress(),
        child: const LevelMapScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.game,
      name: 'game',
      builder: (context, state) {
        final args = state.extra as GameRouteArgs;
        return BlocProvider(
          create: (context) =>
              GameCubit(context.read<LevelRepository>())
             ,
          child: GameScreen(levelId: args.levelId),
        );
      },
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final args = state.extra as ResultRouteArgs;
        return ResultScreen(args: args);
      },
    ),
  ],
);
