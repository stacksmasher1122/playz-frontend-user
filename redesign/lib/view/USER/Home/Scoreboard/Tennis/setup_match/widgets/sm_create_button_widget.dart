import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';
import '../../player_management/player_management_screen.dart';

class SmCreateButtonWidget extends StatefulWidget {
  const SmCreateButtonWidget({super.key});

  @override
  State<SmCreateButtonWidget> createState() => _SmCreateButtonWidgetState();
}

class _SmCreateButtonWidgetState extends State<SmCreateButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetupMatchController>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppDimensions.xl),
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          controller.createMatchSession(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PlayerManagementScreen()),
          );
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(-2, -2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'CREATE MATCH SESSION',
              style: AppTypography.headlineMd.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimaryContainer,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
