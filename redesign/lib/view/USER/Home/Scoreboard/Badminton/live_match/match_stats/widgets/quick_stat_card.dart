import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QuickStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final IconData? backgroundIcon;
  final Color valueColor;

  QuickStatCard({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.backgroundIcon,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (backgroundIcon != null)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                backgroundIcon,
                size: 60,
                color: Colors.grey.shade800.withValues(alpha: 0.3),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontSize: ResponsiveHelper.sp(32),
                      fontWeight: FontWeight.w900,
                      height: ResponsiveHelper.h(1.0),
                    ),
                  ),
                  if (suffix != null) ...[
                    SizedBox(width: 4),
                    Text(
                      suffix!,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ResponsiveHelper.sp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
