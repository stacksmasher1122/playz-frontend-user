import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/view/USER/More/z_coins/z_coins_screen.dart';

class ZCoinsCard extends StatelessWidget {
  const ZCoinsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        child: InkWell(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ZCoinsScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(context.widthPct(4)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: AppColors.coinsGold, size: 28),
                SizedBox(width: context.widthPct(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Z Coins Balance',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Obx(() => Text(
                            '${controller.zCoins} Coins',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: context.responsiveFont(15),
                            ),
                          )),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
