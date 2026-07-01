import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PerformanceBarWidget extends StatelessWidget {
  final String label;
  final String valueText;
  final double fillRatio;
  final bool isInverseMetric; // if true, uses red tint instead of green

  PerformanceBarWidget({
    super.key,
    required this.label,
    required this.valueText,
    required this.fillRatio,
    this.isInverseMetric = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                valueText,
                style: TextStyle(
                  color: isInverseMetric ? Colors.red.shade400 : Color(0xFFC6FF00), // Neon Yellow-Green
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth,
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: fillRatio),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Container(
                        width: constraints.maxWidth * value,
                        height: ResponsiveHelper.h(6),
                        decoration: BoxDecoration(
                          color: isInverseMetric ? Colors.red.shade400 : Color(0xFFC6FF00),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
