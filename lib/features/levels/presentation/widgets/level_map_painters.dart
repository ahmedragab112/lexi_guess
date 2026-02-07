import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';

class MapPathPainter extends CustomPainter {
  final List<Offset> positions;
  final int latestUnlockedLevel;

  MapPathPainter({required this.positions, required this.latestUnlockedLevel});

  @override
  void paint(Canvas canvas, Size size) {
    // Base Paint (Locked/Gray paths)
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w
      ..strokeCap = StrokeCap.round;

    // Unlocked Paint (Colored paths)
    final unlockedPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w
      ..strokeCap = StrokeCap.round;

    if (positions.isEmpty) return;

    for (int i = 0; i < positions.length - 1; i++) {
      final p1 = positions[i];
      final p2 = positions[i + 1];

      // Determine if this segment is unlocked
      // Segment i connects node i+1 (level i+1) to node i+2 (level i+2)
      // Actually, positions index 0 is Level 1.
      // So segment 0 connects Level 1 and Level 2.
      // It should be unlocked if Level 2 is unlocked (meaning we reached it).
      final isUnlocked = (i + 2) <= latestUnlockedLevel;

      _drawDottedLine(
        canvas,
        p1,
        p2,
        isUnlocked ? unlockedPaint : paint,
        // Increased dash width for better visibility
        dashWidth: 10.w,
        dashSpace: 10.w,
      );
    }
  }

  void _drawDottedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dashWidth = 10,
    double dashSpace = 5,
  }) {
    // Node radius + padding to ensure line doesn't show behind node
    final double maskRadius = 40.r;

    final double totalDistance = (p2 - p1).distance;

    if (totalDistance <= maskRadius * 2) return; // Too close to draw anything

    // Calculate effective start and end points (masked)
    final Offset direction = (p2 - p1) / totalDistance;
    final Offset start = p1 + (direction * maskRadius);
    final Offset end = p2 - (direction * maskRadius);

    final double drawDistance = (end - start).distance;
    double currentDistance = 0;

    final Path path = Path();
    while (currentDistance < drawDistance) {
      double len = dashWidth;
      if (currentDistance + len > drawDistance) {
        len = drawDistance - currentDistance;
      }
      // Calculate segment start/end
      final segStart = start + (direction * currentDistance);
      final segEnd = start + (direction * (currentDistance + len));

      path.moveTo(segStart.dx, segStart.dy);
      path.lineTo(segEnd.dx, segEnd.dy);

      currentDistance += dashWidth + dashSpace;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double step = 50.r;

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
