import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const QrStatusBadge(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3),
        vertical: context.heightPct(0.7),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: AppTypography.labelCaps10.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: context.responsiveFont(12),
          ),
        ),
      ),
    );
  }
}
