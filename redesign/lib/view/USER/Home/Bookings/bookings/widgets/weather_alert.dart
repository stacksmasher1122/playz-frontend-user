import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingsWeatherAlert extends StatelessWidget {
  const BookingsWeatherAlert({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.2),
        context.widthPct(4),
        context.heightPct(0.6),
      ),
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A1C1C), Color(0xFF2A0F0F)],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.umbrella, color: Colors.amber),
          SizedBox(width: context.widthPct(2.5)),
          Expanded(
            child: Text(
              'Heavy rain forecast. Venue will confirm status by 6:00 AM tomorrow.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
