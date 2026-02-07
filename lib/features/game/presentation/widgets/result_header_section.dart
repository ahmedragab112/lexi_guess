import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lexi_guess/core/routes/app_routes.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';
import 'package:lexi_guess/features/game/presentation/cubit/levels_cubit.dart';

class ResultHeaderSection extends StatelessWidget {
  final int level;

  const ResultHeaderSection({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white12,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              context.read<LevelsCubit>().fetchProgress();
              context.go(AppRoutes.levels);
            },
          ),
        ),
        Text(
          'LEVEL $level',
          style: AppTextStyles.h2.copyWith(color: Colors.white70),
        ),
        CircleAvatar(
          backgroundColor: Colors.white12,
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing your score...')),
              );
            },
          ),
        ),
      ],
    );
  }
}
