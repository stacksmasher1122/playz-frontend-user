import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  StatusBadge(this.label, this.color, {super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final resolvedTextColor = textColor ?? color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(5)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12), // soft fill
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
        border: Border.all(
          color: color.withValues(alpha: 0.6), // 🔥 outline
          width: ResponsiveHelper.w(1),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: resolvedTextColor,
          fontSize: ResponsiveHelper.sp(11),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
