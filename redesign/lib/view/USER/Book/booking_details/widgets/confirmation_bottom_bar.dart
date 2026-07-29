import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmationBottomBar extends StatelessWidget {
  final bool enabled;
  final int totalAmount;
  final VoidCallback? onPayPressed;

  const ConfirmationBottomBar({
    super.key,
    required this.enabled,
    required this.totalAmount,
    this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(4),
            context.heightPct(1.2),
            context.widthPct(4),
            context.heightPct(2.5),
          ),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.8),
            border: const Border(top: BorderSide(color: AppColors.borderDark)),
          ),
          child: ElevatedButton(
            onPressed: enabled ? onPayPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: enabled ? AppColors.accent : AppColors.card,
              foregroundColor: AppColors.background,
              elevation: enabled ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
              ),
              padding: EdgeInsets.symmetric(vertical: context.heightPct(1.8)),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                enabled ? 'Pay ₹$totalAmount' : 'Complete details to pay',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                  color: enabled ? AppColors.background : AppColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
