import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/widgets/glass_container.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onTap;

  const SubmitButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 1),
            color: Colors.white10,
          ),
          child: Icon(Icons.check, color: AppColors.primary, size: 32.r),
        ),
      ),
    );
  }
}
