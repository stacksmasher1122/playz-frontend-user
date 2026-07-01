import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';

class SmCategorySelectorWidget extends StatelessWidget {
  const SmCategorySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetupMatchController>();
    final categories = ["Men's Singles", "Women's Singles", "Men's Doubles", "Mixed Doubles"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: AppDimensions.md),
          child: Text(
            'CATEGORY',
            style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: Row(
              children: categories.map((category) {
                return Obx(() {
                  final isSelected = controller.matchSetup.value.category == category;
                  
                  return GestureDetector(
                    onTap: () => controller.selectCategory(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.only(right: AppDimensions.sm),
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.primaryContainer 
                              : Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(-2, -2),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        category,
                        style: AppTypography.labelCaps.copyWith(
                          color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
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
