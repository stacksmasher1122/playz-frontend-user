import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmSetFormatCardWidget extends StatelessWidget {
  SmSetFormatCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<SetupMatchController>();
    final formats = ['Best of 1', 'Best of 3', 'Best of 5'];

    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(24)),
          decoration: BoxDecoration(
            color: Color(0x001a1a1a).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            backgroundBlendMode: BlendMode.dstATop,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SET FORMAT',
                style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
              ),
              SizedBox(height: AppDimensions.md),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                child: Row(
                  children: formats.map((format) {
                    return Expanded(
                      child: Obx(() {
                        final isSelected = controller.matchSetup.value.setFormat == format;
                        return GestureDetector(
                          onTap: () => controller.selectSetFormat(format),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryContainer : Colors.transparent,
                              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              format,
                              style: AppTypography.labelCaps.copyWith(
                                color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
