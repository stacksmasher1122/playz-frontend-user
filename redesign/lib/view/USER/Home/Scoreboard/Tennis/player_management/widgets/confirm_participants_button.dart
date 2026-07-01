import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmParticipantsButton extends StatefulWidget {
  ConfirmParticipantsButton({super.key});

  @override
  State<ConfirmParticipantsButton> createState() => _ConfirmParticipantsButtonState();
}

class _ConfirmParticipantsButtonState extends State<ConfirmParticipantsButton> {
  bool _isHovered = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<PlayerManagementController>();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isActive = true),
        onTapUp: (_) {
          setState(() => _isActive = false);
          controller.confirmParticipants();
        },
        onTapCancel: () => setState(() => _isActive = false),
        child: AnimatedScale(
          scale: _isActive ? 0.98 : 1.0,
          duration: Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24), horizontal: ResponsiveHelper.w(24)),
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.primaryContainer : AppColors.surfaceContainerHighest,
              border: Border(
                top: BorderSide(
                  color: AppColors.primaryContainer,
                  width: ResponsiveHelper.w(2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CONFIRM MATCH PARTICIPANTS',
                  style: AppTypography.headlineMdSora.copyWith(
                    color: _isHovered ? AppColors.onPrimary : AppColors.primaryContainer,
                  ),
                ),
                AnimatedSlide(
                  offset: _isHovered ? Offset(0.3, 0) : Offset.zero,
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    Icons.arrow_forward,
                    color: _isHovered ? AppColors.onPrimary : AppColors.primaryContainer,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
