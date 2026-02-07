import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ActionCircle({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 50.w,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 1),
            color: Colors.white10,
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 24.r),
          ),
        ),
      ),
    );
  }
}
