import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;

class SuccessRipple extends StatefulWidget {
  const SuccessRipple({super.key});

  @override
  State<SuccessRipple> createState() => _SuccessRippleState();
}

class _SuccessRippleState extends State<SuccessRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      child: SizedBox(
        height: 140,
        width: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Ripple 1
            RippleWave(controller: _controller, delay: 0.0),

            /// Core success circle
            Container(
              height: 72,
              width: 72,
              decoration: const BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RippleWave extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const RippleWave({required this.controller, required this.delay, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress = ((controller.value + delay) % 1.0).clamp(0.0, 1.0);

        final scale = 1.0 + progress * 1.8;
        final opacity = (1.0 - progress).clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity * 0.35,
          child: Transform.scale(
            scale: scale,
            child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kGreen, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
