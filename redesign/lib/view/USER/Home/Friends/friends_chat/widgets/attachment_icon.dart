import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AttachmentIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const AttachmentIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = context.minDimensionPct(7.5).clamp(24.0, 32.0);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(height: context.heightPct(0.8)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
