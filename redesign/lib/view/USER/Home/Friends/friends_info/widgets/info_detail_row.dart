import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class InfoDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  const InfoDetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(5),
        vertical: context.heightPct(1.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted, size: 22),
          SizedBox(width: context.widthPct(4)),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(15),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: valueColor,
              fontSize: context.responsiveFont(15),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
