import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ErrorOverlay extends StatelessWidget {
  const ErrorOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapsCtrl = Get.find<MapsController>();

    return Obx(() {
      if (!mapsCtrl.hasError.value) return const SizedBox.shrink();
      return Positioned(
        left: context.widthPct(4),
        right: context.widthPct(4),
        bottom: context.heightPct(25),
        child: Container(
          padding: EdgeInsets.all(context.widthPct(4)),
          decoration: BoxDecoration(
            color: const Color(0xFF2C1010),
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                size: 28,
              ),
              SizedBox(width: context.widthPct(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapsCtrl.errorMessage.value,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(13),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: context.heightPct(1)),
                    GestureDetector(
                      onTap: () {
                        if (mapsCtrl.errorMessage.value.contains('Settings')) {
                          mapsCtrl.openAppSettings();
                        } else {
                          mapsCtrl.hasError.value = false;
                          mapsCtrl.detectCurrentLocation();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(4),
                          vertical: context.heightPct(0.8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                        ),
                        child: Text(
                          mapsCtrl.errorMessage.value.contains('Settings')
                              ? 'Open Settings'
                              : 'Retry',
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.background,
                            fontSize: context.responsiveFont(12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => mapsCtrl.hasError.value = false,
                child: const Icon(Icons.close, color: Colors.white38, size: 20),
              ),
            ],
          ),
        ),
      );
    });
  }
}
