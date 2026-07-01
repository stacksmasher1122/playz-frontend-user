import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  QrStatusBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.sp(12),
        ),
      ),
    );
  }
}
