import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrActionButtons extends StatelessWidget {
  final VoidCallback onDownload;
  final VoidCallback onSave;

  const QrActionButtons({
    super.key,
    required this.onDownload,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onDownload,
            icon: const Icon(Icons.download, color: AppColors.background),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Download QR',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.background,
                  fontSize: context.responsiveFont(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              padding: EdgeInsets.symmetric(vertical: context.heightPct(1.8)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
              ),
            ),
          ),
        ),
        SizedBox(height: context.heightPct(1.5)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onSave,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.borderDark),
              padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Save to Gallery',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
