import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultStarSection extends StatelessWidget {
  final int stars;

  const ResultStarSection({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isFilled = index < stars;
        return Icon(
              isFilled ? Icons.star : Icons.star_border,
              color: isFilled ? const Color(0xFFFACC15) : Colors.white10,
              size: 48.r,
            )
            .animate(target: isFilled ? 1 : 0)
            .scale(
              delay: (index * 100).ms,
              duration: 400.ms,
              curve: Curves.elasticOut,
            )
            .shimmer(delay: 1.seconds, duration: 2.seconds);
      }),
    );
  }
}
