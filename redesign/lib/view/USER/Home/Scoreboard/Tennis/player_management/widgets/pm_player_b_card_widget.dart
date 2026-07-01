import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmPlayerBCardWidget extends StatelessWidget {
  PmPlayerBCardWidget({super.key});

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
              'PLAYER B (RECEIVER)',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 2.0,
              ),
            ),
            Container(
              width: ResponsiveHelper.w(48),
              height: ResponsiveHelper.h(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.lg),
        
        Obx(() {
          final player = controller.playerB.value;
          
          if (player != null) {
            // If player is selected, show a filled card similar to Player A
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveHelper.w(24)),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: ResponsiveHelper.w(120),
                        height: ResponsiveHelper.h(120),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                          border: Border.all(color: AppColors.primaryContainer, width: 2),
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
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.background, width: 3),
                          ),
                          child: Icon(Icons.check, color: AppColors.onPrimaryContainer, size: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(player.name, style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
                  SizedBox(height: 4),
                  Text(player.club, style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant)),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                          child: Column(
                            children: [
                              Text('RANKING', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
                              SizedBox(height: 4),
                              Text(player.ranking, style: AppTypography.headlineMd.copyWith(color: AppColors.primaryContainer)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                          child: Column(
                            children: [
                              Text('COUNTRY', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
                              SizedBox(height: 4),
                              Text(player.countryCode, style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: controller.removePlayerB,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'REMOVE PLAYER',
                        style: AppTypography.labelCaps.copyWith(color: AppColors.error, letterSpacing: 2.0),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Empty state for Player B (Screenshot state)
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.w(32)),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: ResponsiveHelper.w(1),
                style: BorderStyle.solid, // In a real app we might use a dashed border package, but solid is fine for MVP
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: ResponsiveHelper.w(80),
                  height: ResponsiveHelper.h(80),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                  ),
                  child: Icon(
                    Icons.person_search,
                    color: AppColors.onSurfaceVariant,
                    size: 32,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Select Opponent',
                  style: AppTypography.headlineMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                SizedBox(height: 8),
                Text(
                  'Search the tournament\ndatabase or register a new\nparticipant.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                SizedBox(height: 32),
                
                // ADD PLAYER B Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryContainer.withValues(alpha: 0.3),
                        blurRadius: 10,
                      )
                    ]
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors.onPrimaryContainer, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'ADD PLAYER B',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.onPrimaryContainer,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                
                // SCAN ACCREDITATION Button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'SCAN ACCREDITATION',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
