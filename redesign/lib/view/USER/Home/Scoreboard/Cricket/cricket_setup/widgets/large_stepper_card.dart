import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'circle_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LargeStepperCard extends StatelessWidget {
  final CricketController controller;

  const LargeStepperCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      ),
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24), horizontal: ResponsiveHelper.w(20)),
      child: Column(
        children: [
          Text(
            'MATCH LENGTH',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Number of Overs',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleButton(
                  icon: Icons.remove,
                  color: Color(0xFF131313),
                  iconColor: AppColors.accent.withValues(alpha: 0.7),
                  onTap: controller.decrementOvers,
                  size: 56,
                  iconSize: 28,
                ),
                SizedBox(width: 32),
                Column(
                  children: [
                    Obx(
                      () => Text(
                        controller.overs.value.toString(),
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(64),
                          fontWeight: FontWeight.w800,
                          height: ResponsiveHelper.h(1),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
                SizedBox(width: 32),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                       BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleButton(
                    icon: Icons.add,
                    color: AppColors.accent,
                    iconColor: Colors.black,
                    onTap: controller.incrementOvers,
                    size: 56,
                    iconSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
