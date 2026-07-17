import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';
import '../../player_management/player_management_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmCreateButtonWidget extends StatefulWidget {
  SmCreateButtonWidget({super.key});

  @override
  State<SmCreateButtonWidget> createState() => _SmCreateButtonWidgetState();
}

class _SmCreateButtonWidgetState extends State<SmCreateButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<SetupMatchController>();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: AppDimensions.xl),
      padding: EdgeInsets.symmetric(vertical: AppDimensions.lg),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          controller.createMatchSession(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PlayerManagementScreen()),
          );
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: Duration(milliseconds: 100),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: Offset(-2, -2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'CREATE MATCH SESSION',
              style: AppTypography.headlineMd.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.background,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
