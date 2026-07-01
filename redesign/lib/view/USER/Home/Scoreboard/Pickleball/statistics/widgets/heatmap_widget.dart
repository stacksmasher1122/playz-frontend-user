import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class HeatmapWidget extends StatelessWidget {
  const HeatmapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Heat Map: Shot Placement',
                  style: AppTypography.headlineSm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.grid_view, color: AppColors.primaryContainer, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 200),
                    painter: CourtGridPainter(),
                  ),
                  Center(
                    child: Text(
                      'Aggregated shot data from 3 games',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourtGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Outline
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Net
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    
    // Kitchen line
    canvas.drawLine(Offset(size.width / 2 - 40, 0), Offset(size.width / 2 - 40, size.height), paint);
    canvas.drawLine(Offset(size.width / 2 + 40, 0), Offset(size.width / 2 + 40, size.height), paint);
    
    // Centerline
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width / 2 - 40, size.height / 2), paint);
    canvas.drawLine(Offset(size.width / 2 + 40, size.height / 2), Offset(size.width, size.height / 2), paint);

    // Mock heat gradient overlay
    final rect = Rect.fromCenter(center: Offset(size.width * 0.75, size.height * 0.75), width: 100, height: 100);
    final gradient = RadialGradient(
      colors: [AppColors.primaryContainer.withOpacity(0.4), Colors.transparent],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = gradient);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
