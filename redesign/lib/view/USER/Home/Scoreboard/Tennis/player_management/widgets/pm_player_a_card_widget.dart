import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';

class PmPlayerACardWidget extends StatelessWidget {
  const PmPlayerACardWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.onSurfaceVariant,
                letterSpacing: 2.0,
              ),
            ),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Obx(() {
            final player = controller.playerA.value;
            if (player == null) return const SizedBox.shrink();

            return Column(
              children: [
                // Avatar with neon border
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.background, width: 3),
                        ),
                        child: const Icon(Icons.check, color: AppColors.onPrimaryContainer, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Name & Club
                Text(
                  player.name,
                  style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  player.club,
                  style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text('RANKING', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
                            const SizedBox(height: 4),
                            Text(player.ranking, style: AppTypography.headlineMd.copyWith(color: AppColors.primaryContainer)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text('COUNTRY', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
                            const SizedBox(height: 4),
                            Text(player.countryCode, style: AppTypography.headlineMd.copyWith(color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Change Player Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'CHANGE PLAYER',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        
        const SizedBox(height: 16),
        
        // Existing / Create New row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_search, color: AppColors.onSurfaceVariant, size: 20),
                    const SizedBox(width: 8),
                    Text('EXISTING', style: AppTypography.labelCaps.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add, color: AppColors.primaryContainer, size: 20),
                    const SizedBox(width: 8),
                    Text('CREATE NEW', style: AppTypography.labelCaps.copyWith(color: AppColors.primary)),
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
