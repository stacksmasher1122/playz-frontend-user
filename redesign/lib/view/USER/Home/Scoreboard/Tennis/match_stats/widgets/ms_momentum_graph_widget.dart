import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';

class MsMomentumGraphWidget extends StatelessWidget {
  const MsMomentumGraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MATCH MOMENTUM',
                style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 2.0),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('ALCARAZ', style: AppTypography.labelCaps.copyWith(color: AppColors.primary, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.onSurfaceVariant, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('SINNER', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(
              painter: _MomentumPainter(),
            ),
          ),
          
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('START', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 10)),
              Text('SET 1', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 10)),
              Text('SET 2', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 10)),
              Text('SET 3', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 10)),
              Text('FINISH', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MomentumPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dashPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final step = size.height / 6;
    for (int i = 0; i <= 6; i++) {
      if (i == 3) { // Center line dashed
        _drawDashedLine(canvas, Offset(0, i * step), Offset(size.width, i * step), dashPaint);
      } else {
        canvas.drawLine(Offset(0, i * step), Offset(size.width, i * step), gridPaint);
      }
    }

    // Points representing the SVG path:
    // M0,150 L100,80 L200,120 L300,50 L400,200 L500,250 L600,180 L700,40 L800,100 L900,30 L1000,60
    final pointsX = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
    final pointsY = [0.5, 0.26, 0.4, 0.16, 0.66, 0.83, 0.6, 0.13, 0.33, 0.1, 0.2];

    final path = Path();
    path.moveTo(pointsX[0] * size.width, pointsY[0] * size.height);
    for (int i = 1; i < pointsX.length; i++) {
      path.lineTo(pointsX[i] * size.width, pointsY[i] * size.height);
    }

    // Draw Fill Gradient
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillGradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(0, size.height),
      [
        AppColors.primaryContainer.withValues(alpha: 0.3),
        AppColors.primaryContainer.withValues(alpha: 0.0),
      ],
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = fillGradient
        ..style = PaintingStyle.fill,
    );

    // Draw Stroke Line
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primaryContainer
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 5;
    const double dashSpace = 5;
    double startX = p1.dx;
    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset(startX + dashWidth, p2.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
