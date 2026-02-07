import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lexi_guess/core/theme/app_colors.dart';

class MapPathPainter extends CustomPainter {
  final List<Offset> positions;
  final int latestUnlockedLevel;

  MapPathPainter({required this.positions, required this.latestUnlockedLevel});

  @override
  void paint(Canvas canvas, Size size) {
    
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w
      ..strokeCap = StrokeCap.round;

    
    final unlockedPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w
      ..strokeCap = StrokeCap.round;

    if (positions.isEmpty) return;

    for (int i = 0; i < positions.length - 1; i++) {
      final p1 = positions[i];
      final p2 = positions[i + 1];

      
      
      
      
      
      final isUnlocked = (i + 2) <= latestUnlockedLevel;

      _drawDottedLine(
        canvas,
        p1,
        p2,
        isUnlocked ? unlockedPaint : paint,
        
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
    
    final double maskRadius = 40.r;

    final double totalDistance = (p2 - p1).distance;

    if (totalDistance <= maskRadius * 2) return; 

    
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
