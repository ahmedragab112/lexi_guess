import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/storage/objectbox_manager.dart';
import 'features/game/data/repositories/level_repository.dart';
import 'package:lexi_guess/features/home/presentation/cubit/settings_cubit.dart';
import 'package:lexi_guess/features/home/presentation/cubit/settings_state.dart';

late ObjectBoxManager objectBoxManager;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBoxManager = await ObjectBoxManager.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LevelRepository>(
          create: (context) => LevelRepositoryImpl(objectBoxManager),
        ),
      ],
      child: BlocProvider<SettingsCubit>(
        create: (context) => SettingsCubit(objectBoxManager),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) {
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp.router(
                  title: 'Lexi Guess: Wordflux',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: settings.themeMode,
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
