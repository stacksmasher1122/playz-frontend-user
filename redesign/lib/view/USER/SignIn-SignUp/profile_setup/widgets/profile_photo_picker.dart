import 'dart:io';
import 'package:flutter/material.dart';

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
    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: imageFile == null
                    ? Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                        style: BorderStyle.none,
                      )
                    : null,
              ),
              child: imageFile != null
                  ? ClipOval(
                      child: Image.file(
                        imageFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : CustomPaint(
                      painter: DashedCirclePainter(
                        color: Colors.white24,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ADD PHOTO',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.5),
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
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF00FF7F),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    imageFile != null ? Icons.edit : Icons.add,
                    color: Colors.black,
                    size: 16,
                    weight: 800,
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
