import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'football_pitch_widget.dart';
import 'swap_side_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SideSelectionCard extends StatelessWidget {
  SideSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KickoffSetupController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF1E1E1E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Side Selection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Drag teams to set attacking direction',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                  ),
                ],
              ),
              SwapSideButton(
                onTap: controller.swapSides,
              ),
            ],
          ),
          SizedBox(height: 24),
          FootballKickoffPitchWidget(),
        ],
      ),
    );
  }
}
