import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrTopBar extends StatelessWidget {
  const QrTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: context.widthPct(1)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Show this QR Code at the Venue',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.heightPct(0.3)),
              Text(
                'Your booking is confirmed. This is your entry pass.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }
}
