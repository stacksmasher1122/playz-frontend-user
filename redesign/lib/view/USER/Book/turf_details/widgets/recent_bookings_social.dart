import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecentBookingsSocial extends StatelessWidget {
  const RecentBookingsSocial({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = context.minDimensionPct(4.5).clamp(16.0, 20.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Row(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/100'),
          ),
          SizedBox(width: context.widthPct(2)),
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/101'),
          ),
          SizedBox(width: context.widthPct(2)),
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/102'),
          ),
          SizedBox(width: context.widthPct(3)),
          Expanded(
            child: Text(
              'Arjun and 2 others have booked here recently.',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
