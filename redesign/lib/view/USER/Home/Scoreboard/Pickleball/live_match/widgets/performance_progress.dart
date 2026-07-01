import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class PerformanceProgress extends StatefulWidget {
  final String label;
  final String valueA;
  final String valueB;
  final double fillRatio;
  final bool isPercentageBar;

  const PerformanceProgress({
    super.key,
    required this.label,
    required this.valueA,
    required this.valueB,
    this.fillRatio = 0.5,
    this.isPercentageBar = false,
  });

  @override
  State<PerformanceProgress> createState() => _PerformanceProgressState();
}

class _PerformanceProgressState extends State<PerformanceProgress> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fillAnimation = Tween<double>(begin: 0.0, end: widget.fillRatio).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    if (widget.isPercentageBar) {
      _animController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PerformanceProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPercentageBar && oldWidget.fillRatio != widget.fillRatio) {
      _fillAnimation = Tween<double>(begin: _fillAnimation.value, end: widget.fillRatio).animate(CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ));
      _animController
        ..reset()
        ..forward();
    }
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
                Text('${widget.valueA} - ${widget.valueB}', style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
              ],
            ),
            if (widget.isPercentageBar) ...[
              const SizedBox(height: 8),
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
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
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
