import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmPlayerACardWidget extends StatelessWidget {
  PmPlayerACardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PLAYER A (SERVER)',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.muted,
                letterSpacing: 2.0,
              ),
            ),
            Container(
              width: ResponsiveHelper.w(48),
              height: ResponsiveHelper.h(4),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.lg),
        
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveHelper.w(24)),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Obx(() {
            final player = controller.playerA.value;
            if (player == null) return SizedBox.shrink();

            return Column(
              children: [
                // Avatar with neon border
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: ResponsiveHelper.w(120),
                      height: ResponsiveHelper.h(120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                        border: Border.all(color: AppColors.accent, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(player.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -8,
                      right: -8,
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 3),
                        ),
                        child: Icon(Icons.check, color: AppColors.background, size: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Name & Club
                Text(
                  player.name,
                  style: AppTypography.headlineMd.copyWith(color: AppColors.accent),
                ),
                SizedBox(height: 4),
                Text(
                  player.club,
                  style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
                ),
                SizedBox(height: 24),
                
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                        ),
                        child: Column(
                          children: [
                            Text('RANKING', style: AppTypography.labelCaps.copyWith(color: AppColors.muted, fontSize: 10)),
                            SizedBox(height: 4),
                            Text(player.ranking, style: AppTypography.headlineMd.copyWith(color: AppColors.accent)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                        ),
                        child: Column(
                          children: [
                            Text('COUNTRY', style: AppTypography.labelCaps.copyWith(color: AppColors.muted, fontSize: 10)),
                            SizedBox(height: 4),
                            Text(player.countryCode, style: AppTypography.headlineMd.copyWith(color: AppColors.accent)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Change Player Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'CHANGE PLAYER',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.onPrimary,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        
        SizedBox(height: 16),
        
        // Existing / Create New row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_search, color: AppColors.muted, size: 20),
                    SizedBox(width: 8),
                    Text('EXISTING', style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: AppColors.accent, size: 20),
                    SizedBox(width: 8),
                    Text('CREATE NEW', style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
