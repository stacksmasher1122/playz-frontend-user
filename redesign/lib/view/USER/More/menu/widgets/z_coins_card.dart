import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ZCoinsScreen()),
            );
          },
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surface, AppColors.surface.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amberAccent, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Z Coins Balance',
                        style: GoogleFonts.inter(
                          color: AppColors.muted,
                          fontSize: ResponsiveHelper.sp(12),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() => Text(
                            '${controller.zCoins} Coins',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveHelper.sp(15),
                            ),
                          )),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
