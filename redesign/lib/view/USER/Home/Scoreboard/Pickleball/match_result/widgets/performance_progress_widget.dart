import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PerformanceProgressWidget extends StatefulWidget {
  final String label;
  final double ratioA;
  final String labelA;
  final String labelB;

  PerformanceProgressWidget({
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
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
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
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: ResponsiveHelper.w(40),
                  child: Text(widget.labelA, style: AppTypography.bodySm.copyWith(color: AppColors.accent)),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                    ),
                    child: AnimatedBuilder(
                      animation: _fillAnimation,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _fillAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: ResponsiveHelper.w(40),
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
