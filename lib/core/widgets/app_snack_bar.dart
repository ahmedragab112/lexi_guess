import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:lexi_guess/core/theme/app_colors.dart';
import 'package:lexi_guess/core/theme/app_text_styles.dart';



class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackBar(
        message: message,
        type: type,
        duration: duration,
        icon: icon,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }

  
  static void success(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      icon: icon ?? Icons.check_circle,
    );
  }

  
  static void error(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      icon: icon ?? Icons.error,
    );
  }

  
  static void hint(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message: message,
      type: SnackBarType.hint,
      icon: icon ?? Icons.lightbulb,
    );
  }

  
  static void info(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
      icon: icon ?? Icons.info,
    );
  }

  
  static void warning(BuildContext context, String message, {IconData? icon}) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      icon: icon ?? Icons.warning,
    );
  }
}

enum SnackBarType { success, error, hint, info, warning }

class _AnimatedSnackBar extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final IconData? icon;
  final VoidCallback onDismiss;

  const _AnimatedSnackBar({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.icon,
  });

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    switch (widget.type) {
      case SnackBarType.success:
        return AppColors.success;
      case SnackBarType.error:
        return AppColors.error;
      case SnackBarType.hint:
        return AppColors.accent;
      case SnackBarType.info:
        return AppColors.primary;
      case SnackBarType.warning:
        return Colors.orange;
    }
  }

  IconData get _icon {
    return widget.icon ??
        switch (widget.type) {
          SnackBarType.success => Icons.check_circle,
          SnackBarType.error => Icons.error,
          SnackBarType.hint => Icons.lightbulb,
          SnackBarType.info => Icons.info,
          SnackBarType.warning => Icons.warning,
        };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: _backgroundColor.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _backgroundColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_icon, color: Colors.white, size: 24.r),
                        SizedBox(width: 12.w),
                        Flexible(
                          child: Text(
                            widget.message,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
