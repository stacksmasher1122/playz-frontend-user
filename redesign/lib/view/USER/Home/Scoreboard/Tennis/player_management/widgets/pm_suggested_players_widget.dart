import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmSuggestedPlayersWidget extends StatelessWidget {
  PmSuggestedPlayersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SUGGESTED FROM RECENT MATCHES',
          style: AppTypography.labelCaps.copyWith(
            color: AppColors.muted,
            fontSize: ResponsiveHelper.sp(10),
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: AppDimensions.md),
        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...controller.suggestedPlayers.map((player) {
                return GestureDetector(
                  onTap: () => controller.selectPlayerB(player),
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    width: ResponsiveHelper.w(56),
                    height: ResponsiveHelper.h(56),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      image: DecorationImage(
                        image: NetworkImage(player.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
              
              // More button
              Container(
                width: ResponsiveHelper.w(56),
                height: ResponsiveHelper.h(56),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Icon(Icons.more_horiz, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
