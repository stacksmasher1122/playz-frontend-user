import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'player_quick_actions_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerACardWidget extends StatefulWidget {
  PlayerACardWidget({super.key});

  @override
  State<PlayerACardWidget> createState() => _PlayerACardWidgetState();
}

class _PlayerACardWidgetState extends State<PlayerACardWidget> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PLAYER A (SERVER)', style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
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
        SizedBox(height: 16),
        
        // Card
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(AppDimensions.paddingXl),
            decoration: BoxDecoration(
              color: Color(0x991A1A1A), // glass panel base (rgba 26,26,26,0.6)
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _isHovered ? AppColors.accent.withValues(alpha: 0.05) : Colors.transparent,
                  Colors.transparent,
                ],
              ),
            ),
            child: Obx(() {
              final player = controller.playerA.value;
              if (player == null) return SizedBox(); // Fallback if null
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image with Pulse
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: ResponsiveHelper.w(128),
                        height: ResponsiveHelper.h(128),
                        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 15,
                              spreadRadius: _pulseAnimation.value,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.background,
                                image: DecorationImage(
                                  image: NetworkImage(player.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: ResponsiveHelper.h(0),
                              right: ResponsiveHelper.w(0),
                              child: Container(
                                width: ResponsiveHelper.w(32),
                                height: ResponsiveHelper.h(32),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accent,
                                ),
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppColors.onPrimary,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  
                  // Name and Club
                  Text(player.name, style: AppTypography.headlineMdSora.copyWith(color: AppColors.accent)),
                  SizedBox(height: 4),
                  Text(player.club, style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                  SizedBox(height: 24),
                  
                  // Stat Grid
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('RANKING', '#${player.ranking}')),
                      SizedBox(width: 8),
                      Expanded(child: _buildStatCard('COUNTRY', player.country, isPrimaryValue: true)),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Change Player Button
                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveHelper.h(48),
                    child: OutlinedButton(
                      onPressed: controller.changePlayerA,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: AppColors.outlineVariant),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl)),
                      ),
                      child: Text('CHANGE PLAYER', style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        
        SizedBox(height: 24),
        PlayerQuickActionsWidget(),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, {bool isPrimaryValue = false}) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
          SizedBox(height: 4),
          Text(
            value,
            style: isPrimaryValue 
                ? AppTypography.headlineMdSora.copyWith(color: AppColors.accent)
                : AppTypography.headlineMdSora.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
