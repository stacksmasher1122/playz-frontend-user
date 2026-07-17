import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmCategorySelectorWidget extends StatelessWidget {
  SmCategorySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<SetupMatchController>();
    final categories = ["Men's Singles", "Women's Singles", "Men's Doubles", "Mixed Doubles"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ResponsiveHelper.w(4.0), bottom: AppDimensions.md),
          child: Text(
            'CATEGORY',
            style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.sm),
            child: Row(
              children: categories.map((category) {
                return Obx(() {
                  final isSelected = controller.matchSetup.value.category == category;
                  
                  return GestureDetector(
                    onTap: () => controller.selectCategory(category),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(right: AppDimensions.sm),
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.card,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.accent 
                              : Colors.white.withValues(alpha: 0.05),
                          width: ResponsiveHelper.w(1),
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: Offset(-2, -2),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        category,
                        style: AppTypography.labelCaps.copyWith(
                          color: isSelected ? AppColors.background : AppColors.muted,
                        ),
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
