import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AnimatedCenterPin extends StatelessWidget {
  const AnimatedCenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<MapsController>();
    return Obx(() {
      final dragging = ctrl.isDragging.value;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: dragging ? 0.0 : 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(3.5),
                vertical: context.heightPct(0.8),
              ),
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "MOVE MAP TO ADJUST LOCATION",
                style: AppTypography.labelCaps10.copyWith(
                  fontSize: context.responsiveFont(11),
                  fontWeight: FontWeight.w600,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
          SizedBox(height: context.heightPct(1)),
          // Animated pin
          AnimatedScale(
            scale: dragging ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: dragging ? 0.8 : 0.5),
                    blurRadius: dragging ? 40 : 25,
                    spreadRadius: dragging ? 8 : 3,
                  ),
                ],
              ),
              child: Icon(
                Icons.location_on,
                color: AppColors.accent,
                size: context.minDimensionPct(12).clamp(40.0, 56.0),
              ),
            ),
          ),
          // Shadow dot (below pin)
          AnimatedScale(
            scale: dragging ? 0.5 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: context.widthPct(3),
              height: context.heightPct(0.5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
              ),
            ),
          ),
        ],
      );
    });
  }
}
