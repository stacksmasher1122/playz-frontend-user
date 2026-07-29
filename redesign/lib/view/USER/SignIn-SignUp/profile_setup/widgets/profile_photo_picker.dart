import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProfilePhotoPicker extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onPickImage;

  const ProfilePhotoPicker({
    super.key,
    required this.imageFile,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final pickerSize = context.minDimensionPct(25).clamp(84.0, 110.0);

    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            Container(
              width: pickerSize,
              height: pickerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: imageFile == null
                    ? Border.all(
                        color: AppColors.borderDark,
                        width: 1.5,
                      )
                    : null,
              ),
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile!,
                        width: pickerSize,
                        height: pickerSize,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CustomPaint(
                      painter: DashedCirclePainter(
                        color: AppColors.borderDark,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.muted,
                              size: pickerSize * 0.28,
                            ),
                            SizedBox(height: context.heightPct(0.5)),
                            Text(
                              'ADD PHOTO',
                              style: AppTypography.labelCaps10.copyWith(
                                fontSize: context.responsiveFont(9.5),
                                fontWeight: FontWeight.bold,
                                color: AppColors.muted,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(context.widthPct(1)),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: EdgeInsets.all(context.widthPct(1.2)),
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    imageFile != null ? Icons.edit_rounded : Icons.add_rounded,
                    color: AppColors.background,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double dashWidth = 8;
    final double dashSpace = 6;
    double currentAngle = 0;

    final double circumference = 2 * 3.14159 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final double sweepAngle = 2 * 3.14159 / dashCount;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle * (dashWidth / (dashWidth + dashSpace)),
        false,
        paint,
      );
      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
