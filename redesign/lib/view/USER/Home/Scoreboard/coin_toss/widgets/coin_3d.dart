import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Coin3D extends StatelessWidget {
  final double angle;
  final double verticalShift;
  final double idleWobble;
  final double wobbleAngle;
  final double randomTilt;
  final double xOffset;
  final double randomDriftScale;
  final double verticalVelocityRatio;
  final double scaleValue;
  final double controllerValue;
  final double glowPulse;
  final double rimLightProgress;
  final bool isTossing;
  final bool isIdle;

  const Coin3D({
    super.key,
    required this.angle,
    required this.verticalShift,
    required this.idleWobble,
    required this.wobbleAngle,
    required this.randomTilt,
    required this.xOffset,
    required this.randomDriftScale,
    required this.verticalVelocityRatio,
    required this.scaleValue,
    required this.controllerValue,
    required this.glowPulse,
    required this.rimLightProgress,
    required this.isTossing,
    required this.isIdle,
  });

  @override
  Widget build(BuildContext context) {
    const double thickness = 14.0;
    const int layers = 11;

    final normalizedAngle = angle % (2 * pi);
    final isFront = normalizedAngle < pi / 2 || normalizedAngle > 3 * pi / 2;

    final double velocityValue = isTossing ? (1.0 - controllerValue) : 0.0;
    final double blurSigma = velocityValue * 6.5;

    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaY: blurSigma),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..translate(
            xOffset * randomDriftScale,
            verticalShift * verticalVelocityRatio,
          )
          ..rotateX(
            angle + (isIdle ? idleWobble : 0) + wobbleAngle,
          )
          ..rotateZ(isIdle ? 0 : randomTilt)
          ..scale(1.0, scaleValue),
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < layers; i++)
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(
                    0.0,
                    0.0,
                    -thickness / 2 + (i * thickness / layers),
                  ),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      center: Alignment.center,
                      startAngle: 0,
                      endAngle: 2 * pi,
                      colors: [
                        const Color(0xFF5C4613),
                        const Color(0xFF8C6A1A),
                        const Color(0xFFF7E7A1).withValues(alpha: 0.9),
                        const Color(0xFF8C6A1A),
                        const Color(0xFF5C4613),
                      ],
                      stops: [
                        0.0,
                        (rimLightProgress % 1.0) * 0.9,
                        rimLightProgress % 1.0,
                        (rimLightProgress + 0.1) % 1.0,
                        1.0,
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFFF7E7A1).withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF7E7A1), width: 2),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFC9A227),
                    Color(0xFFB58E22),
                    Color(0xFF8C6A1A),
                    Color(0xFF5C4613),
                  ],
                ),
              ),
            ),
            if (isFront)
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0, thickness / 2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFF7E7A1,
                        ).withValues(alpha: glowPulse * 0.6),
                        blurRadius: 30 * glowPulse,
                        spreadRadius: 10 * glowPulse,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    "assets/Emblem_of_India.svg",
                    width: 140,
                    height: 140,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            else
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(0.0, 0.0, -thickness / 2)
                  ..rotateX(pi),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFF7E7A1,
                        ).withValues(alpha: glowPulse * 0.6),
                        blurRadius: 30 * glowPulse,
                        spreadRadius: 10 * glowPulse,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    "assets/Indian_Rupee_symbol.svg",
                    width: 120,
                    height: 120,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(
                      alpha: (0.2 + (0.15 * (1.0 - controllerValue))) +
                          0.1 * sin(angle * 2),
                    ),
                    Colors.transparent,
                    Colors.black.withValues(
                      alpha: (0.2 + (0.15 * (1.0 - controllerValue))) +
                          0.1 * cos(angle * 2),
                    ),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
