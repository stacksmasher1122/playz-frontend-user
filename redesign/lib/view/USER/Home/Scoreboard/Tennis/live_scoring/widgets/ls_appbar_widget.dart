import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/live_scoring_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LsAppbarWidget extends StatefulWidget {
  LsAppbarWidget({super.key});

  @override
  State<LsAppbarWidget> createState() => _LsAppbarWidgetState();
}

class _LsAppbarWidgetState extends State<LsAppbarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
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
    final controller = Get.find<LiveScoringController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(40),
                    height: ResponsiveHelper.h(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 1),
                      image: DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=40'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'PlayZ Match',
                        style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.w700, color: AppColors.accent, height: 1.1),
                      ),
                      Text(
                        'Center',
                        style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.w700, color: AppColors.accent, height: 1.1),
                      ),
                    ],
                  ),
                ],
              ),
              
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        FadeTransition(
                          opacity: _pulseAnimation,
                          child: Container(
                            width: ResponsiveHelper.w(8),
                            height: ResponsiveHelper.h(8),
                            decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                          ),
                        ),
                        SizedBox(width: 8),
                        Obx(() => Text(
                          'LIVE: ${controller.matchStats.value.courtName}',
                          style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.settings, color: AppColors.muted, size: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
