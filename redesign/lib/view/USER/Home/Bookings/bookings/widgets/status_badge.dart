import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const StatusBadge(this.label, this.color, {super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final resolvedTextColor = textColor ?? color;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2.5),
        vertical: context.heightPct(0.6),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(
          color: color.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label.toUpperCase(),
          style: AppTypography.labelCaps10.copyWith(
            color: resolvedTextColor,
            fontSize: context.responsiveFont(11),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
