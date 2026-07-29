import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrWeatherAlert extends StatelessWidget {
  const QrWeatherAlert({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        gradient: const LinearGradient(
          colors: [Color(0xFF3A2C00), Color(0xFF1E1400)],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_outlined, color: Colors.amber),
          SizedBox(width: context.widthPct(2.5)),
          Expanded(
            child: Text(
              'Light rain expected during your slot. Venue has covered roof available.',
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
