import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class PerformanceProgressWidget extends StatefulWidget {
  final String label;
  final double ratioA;
  final String labelA;
  final String labelB;

  const PerformanceProgressWidget({
    super.key,
    required this.label,
    required this.ratioA,
    required this.labelA,
    required this.labelB,
  });

  @override
  State<PerformanceProgressWidget> createState() => _PerformanceProgressWidgetState();
}

class _PerformanceProgressWidgetState extends State<PerformanceProgressWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fillAnimation = Tween<double>(begin: 0.0, end: widget.ratioA).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(widget.labelA, style: AppTypography.bodySm.copyWith(color: AppColors.primaryContainer)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: AnimatedBuilder(
                      animation: _fillAnimation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _fillAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  child: Text(widget.labelB, style: AppTypography.bodySm.copyWith(color: AppColors.muted), textAlign: TextAlign.right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
