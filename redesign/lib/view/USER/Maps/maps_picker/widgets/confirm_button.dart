import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmButton({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      final canConfirm =
          mapsCtrl.isLocationResolved.value &&
          !mapsCtrl.isLoading.value &&
          !mapsCtrl.isDragging.value;

      return GestureDetector(
        onTap: canConfirm ? onConfirm : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: context.heightPct(6.5).clamp(48.0, 58.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: canConfirm ? AppColors.accent : AppColors.accent.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
            boxShadow: canConfirm
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: mapsCtrl.isLoading.value
                ? SizedBox(
                    width: context.widthPct(6),
                    height: context.widthPct(6),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.background,
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Confirm Location",
                      style: AppTypography.headlineSm.copyWith(
                        color: canConfirm ? AppColors.background : AppColors.background.withValues(alpha: 0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(16),
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
