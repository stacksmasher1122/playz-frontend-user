import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrInstructionsNote extends StatelessWidget {
  const QrInstructionsNote({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Text(
      'This QR code is valid only for the selected slot.\n'
      'Keep your screen brightness high and show it at the gate or reception for a quick check-in.',
      style: AppTypography.bodySm.copyWith(
        color: AppColors.muted,
        fontSize: context.responsiveFont(13),
        height: 1.4,
      ),
    );
  }
}
