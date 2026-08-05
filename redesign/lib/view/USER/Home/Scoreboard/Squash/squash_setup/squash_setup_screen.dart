import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Squash/squash_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/switch_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/widgets/badminton_stepper_card.dart';
import 'widgets/squash_format_card.dart';
import 'widgets/squash_games_card.dart';
import 'widgets/squash_team_card.dart';

class SquashSetupScreen extends StatelessWidget {
  SquashSetupScreen({super.key});

  final SquashController controller = Get.put(SquashController());

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
        title: const Text(
          'SQUASH ARENA',
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
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
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
              const SizedBox(height: 8),
              Text(
                'Configure your match rules and select your\nplayers.',
                style: TextStyle(color: AppColors.muted, fontSize: ResponsiveHelper.sp(15), height: 1.4),
              ),
              const SizedBox(height: 32),

              // 1. Match Format Card (Singles / Doubles)
              SquashFormatCard(
                selectedFormat: controller.format,
                onFormatChanged: controller.setFormat,
              ),
              const SizedBox(height: 16),

              // 2. Games to Win Selection (Best of 3 / 5 / Single Game)
              SquashGamesCard(
                gamesToWin: controller.gamesToWin,
                onGamesToWinChanged: controller.setGamesToWin,
              ),
              const SizedBox(height: 16),

              // 3. Pro Rules Toggle (SwitchCard)
              SwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'Pro Rules Mode',
                subtitle: 'Standard WSF 11 points\n(Win by 2)',
                icon: Icons.sports_handball_rounded,
              ),
              const SizedBox(height: 16),

              // 4. Standalone Target Points Stepper Card (Visible when Pro Rules is OFF)
              Obx(
                () => controller.isProRules.value
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          BadmintonStepperCard(
                            title: 'POINTS TO WIN',
                            mainText: 'Points\nPer Game',
                            valueStream: controller.pointsToWin,
                            onDecrement: controller.decrementPoints,
                            onIncrement: controller.incrementPoints,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
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
              const SizedBox(height: 16),

              // Side A Player Card (Friendlist Selection + Team Name Editing)
              SquashTeamCard(
                context: context,
                controller: controller,
                title: 'Side A',
                dotColor: AppColors.error,
                accentColor: AppColors.error.withValues(alpha: 0.8),
                isSideA: true,
                textController: controller.homeTeamController,
              ),
              const SizedBox(height: 16),

              // Side B Player Card (Friendlist Selection + Team Name Editing)
              SquashTeamCard(
                context: context,
                controller: controller,
                title: 'Side B',
                dotColor: AppColors.primary,
                accentColor: AppColors.primary.withValues(alpha: 0.8),
                isSideA: false,
                textController: controller.awayTeamController,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.goToToss(context),
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
                  ? const CircularProgressIndicator(color: Colors.black)
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
