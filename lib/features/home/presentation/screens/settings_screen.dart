import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: AppTextStyles.h2.copyWith(fontSize: 20.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            _SettingTile(
              title: 'App Theme',
              subtitle: 'Switch between light and dark mode',
              icon: Icons.palette_outlined,
              trailing: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settings) {
                  final isDark = settings.themeMode == ThemeMode.dark;
                  return Switch.adaptive(
                    value: isDark,
                    activeColor: AppColors.accent,
                    onChanged: (_) =>
                        context.read<SettingsCubit>().toggleTheme(),
                  );
                },
              ),
            ).animate().fadeIn().slideX(),

            SizedBox(height: 20.h),

            _SettingTile(
              title: 'Sound Effects',
              subtitle: 'Audio cues during gameplay',
              icon: Icons.volume_up_outlined,
              trailing: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settings) {
                  return Switch.adaptive(
                    value: settings.isSoundEnabled,
                    activeColor: AppColors.accent,
                    onChanged: (_) =>
                        context.read<SettingsCubit>().toggleSound(),
                  );
                },
              ),
            ).animate().fadeIn(delay: 200.ms).slideX(),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget trailing;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.accent, size: 24.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
            trailing,
          ],
        ),
      ),
    );
  }
}
