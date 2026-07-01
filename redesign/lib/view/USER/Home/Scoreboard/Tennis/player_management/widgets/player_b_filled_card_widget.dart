import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'player_quick_actions_widget.dart';

class PlayerBFilledCardWidget extends StatefulWidget {
  const PlayerBFilledCardWidget({super.key});

  @override
  State<PlayerBFilledCardWidget> createState() => _PlayerBFilledCardWidgetState();
}

class _PlayerBFilledCardWidgetState extends State<PlayerBFilledCardWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerManagementController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PLAYER B (RECEIVER)', style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant)),
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
        const SizedBox(height: 16),
        
        // Card
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(AppDimensions.paddingXl),
            decoration: BoxDecoration(
              color: const Color(0x991A1A1A), // glass panel base
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _isHovered ? AppColors.primaryContainer.withValues(alpha: 0.05) : Colors.transparent,
                  Colors.transparent,
                ],
              ),
            ),
            child: Obx(() {
              final player = controller.playerB.value;
              if (player == null) return const SizedBox(); 
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  Container(
                    width: 128,
                    height: 128,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryContainer, width: 2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainerLowest,
                        image: DecorationImage(
                          image: NetworkImage(player.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Name and Club
                  Text(player.name, style: AppTypography.headlineMdSora.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(player.club, style: AppTypography.labelCaps.copyWith(color: AppColors.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  
                  // Stat Grid
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('RANKING', '#${player.ranking}')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildStatCard('COUNTRY', player.country, isPrimaryValue: true)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Change Player Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: controller.removePlayerB,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: AppColors.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl)),
                      ),
                      child: Text('CHANGE PLAYER', style: AppTypography.labelCaps.copyWith(color: AppColors.primary)),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        
        const SizedBox(height: 24),
        const PlayerQuickActionsWidget(),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, {bool isPrimaryValue = false}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(
            value,
            style: isPrimaryValue 
                ? AppTypography.headlineMdSora.copyWith(color: AppColors.primary)
                : AppTypography.headlineMdSora.copyWith(color: AppColors.primaryContainer),
          ),
        ],
      ),
    );
  }
}
