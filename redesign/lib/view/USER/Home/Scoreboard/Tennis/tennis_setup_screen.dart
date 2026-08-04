import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/tennis_controller.dart';
import 'widgets/tennis_format_card.dart';
import 'widgets/tennis_sets_card.dart';
import 'widgets/tennis_rules_switch_card.dart';
import 'widgets/tennis_team_card.dart';

class TennisSetupScreen extends StatelessWidget {
  TennisSetupScreen({super.key});

  final TennisController controller = Get.put(TennisController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'TENNIS ARENA',
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
            fontSize: context.responsiveFont(16),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setup Match',
                style: AppTypography.headlineXl.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(32),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8)),
              Text(
                'Configure match rules, formats, and draft\nyour players.',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.mutedText,
                  fontSize: context.responsiveFont(15),
                  height: 1.4,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(28)),

              // 1. Singles / Doubles Format Selection
              TennisFormatCard(
                selectedFormat: controller.format,
                onFormatChanged: controller.setFormat,
              ),
              SizedBox(height: ResponsiveHelper.h(16)),

              // 2. Best of 1 / 3 / 5 Sets Selection
              TennisSetsCard(
                selectedSetsFormat: controller.setsFormat,
                onSetsFormatChanged: controller.setSetsFormat,
              ),
              SizedBox(height: ResponsiveHelper.h(16)),

              // 3. Pro vs Friendly Rules Toggle + Steppers
              TennisRulesSwitchCard(
                isFriendlyMode: controller.isFriendlyMode,
                onFriendlyModeChanged: controller.toggleFriendlyRules,
                gamesPerSet: controller.gamesPerSet,
                onGamesPerSetChanged: controller.setGamesPerSet,
                tiebreakTarget: controller.tiebreakTarget,
                onTiebreakTargetChanged: controller.setTiebreakTarget,
                noAdScoring: controller.noAdScoring,
                onNoAdScoringChanged: controller.toggleNoAdScoring,
              ),
              SizedBox(height: ResponsiveHelper.h(24)),

              Text(
                'PLAYER ROSTERS',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.mutedText,
                  fontSize: context.responsiveFont(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(16)),

              // Side A Card
              TennisTeamCard(
                context: context,
                controller: controller,
                title: 'Side A',
                dotColor: AppColors.error,
                accentColor: AppColors.error.withValues(alpha: 0.8),
                isSideA: true,
                textController: controller.homeTeamController,
              ),
              SizedBox(height: ResponsiveHelper.h(16)),

              // Side B Card
              TennisTeamCard(
                context: context,
                controller: controller,
                title: 'Side B',
                dotColor: AppColors.primary,
                accentColor: AppColors.primary.withValues(alpha: 0.8),
                isSideA: false,
                textController: controller.awayTeamController,
              ),
              SizedBox(height: ResponsiveHelper.h(32)),

              // 5. Coin Flip & Start Match Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.goToToss(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.h(16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.w(16),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.casino_rounded, size: 22),
                              SizedBox(width: ResponsiveHelper.w(8)),
                              Flexible(
                                child: Text(
                                  'COIN TOSS & START MATCH',
                                  style: AppTypography.headlineSm.copyWith(
                                    fontSize: context.responsiveFont(16),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
