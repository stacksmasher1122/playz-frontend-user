import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/switch_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/widgets/badminton_team_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/widgets/badminton_stepper_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/widgets/badminton_format_card.dart';

class BadmintonSetupScreen extends StatelessWidget {
  BadmintonSetupScreen({super.key});

  final BadmintonController controller = Get.put(BadmintonController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'BADMINTON ARENA',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20.0), vertical: ResponsiveHelper.h(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setup Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(32),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Configure your match rules and select your\nplayers.',
                style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(15), height: 1.4),
              ),
              SizedBox(height: 32),

              // Match Format
              BadmintonFormatCard(controller: controller),
              SizedBox(height: 16),

              // Friendly / Professional Rules Mode Toggle
              SwitchCard(
                valueStream: controller.isFriendlyRules,
                onChanged: controller.toggleFriendlyRules,
                title: 'Friendly Mode',
                subtitle: 'Relaxed BWF rules\n(Customizable)',
                icon: Icons.sports_tennis_rounded,
              ),
              SizedBox(height: 16),

              Obx(() => controller.isFriendlyRules.value
                ? Column(
                    children: [
                      BadmintonStepperCard(
                        title: 'POINTS TO WIN',
                        mainText: 'Points\nPer Game',
                        valueStream: controller.pointsToWin,
                        onDecrement: controller.decrementPoints,
                        onIncrement: controller.incrementPoints,
                      ),
                      SizedBox(height: 16),
                    ],
                  )
                : SizedBox.shrink()
              ),

              Text(
                'PLAYER ROSTERS',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 16),

              // Side A Card
              BadmintonTeamCard(
                context: context,
                controller: controller,
                title: 'Side A',
                dotColor: AppColors.error,
                accentColor: AppColors.error.withValues(alpha: 0.8),
                isSideA: true,
              ),
              SizedBox(height: 16),

              // Side B Card
              BadmintonTeamCard(
                context: context,
                controller: controller,
                title: 'Side B',
                dotColor: AppColors.primary,
                accentColor: AppColors.primary.withValues(alpha: 0.8),
                isSideA: false,
              ),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => controller.createAndStartMatch(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                disabledBackgroundColor: AppColors.surface,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                ),
                elevation: 0,
              ),
              child: controller.isLoading.value
                  ? CircularProgressIndicator(color: Colors.black)
                  : Text(
                      'START MATCH',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
