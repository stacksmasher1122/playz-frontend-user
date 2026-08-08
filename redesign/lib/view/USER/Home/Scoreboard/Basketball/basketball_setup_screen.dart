import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/common_match_duration_card.dart';
import 'package:redesign/common/common_start_match_button.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/squad_config_section.dart';
import 'package:redesign/common/team_builder_section.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BasketballSetupScreen extends StatelessWidget {
  BasketballSetupScreen({super.key});

  final BasketballController controller = Get.isRegistered<BasketballController>()
      ? Get.find<BasketballController>()
      : Get.put(BasketballController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Center(
          child: AppBackButton(size: ResponsiveHelper.w(38.0)),
        ),
        title: const ArenaTitleText(sportName: 'Basketball'),
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
              // Setup Match Header Card with 3D Basketball Court Asset
              const SetupMatchHeader(
                title: 'Setup Match',
                subtitle: 'Configure your court rules\nand draft your squads.',
                imageAsset: 'assets/basketball_court_3d.png',
                imageHeight: 115.0,
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // Squad Limit, Subs Toggle & Max Substitutes Cards
              SquadConfigSection(
                squadLimit: controller.squadLimit,
                onSquadLimitIncrement: controller.incrementSquadLimit,
                onSquadLimitDecrement: controller.decrementSquadLimit,
                subsEnabled: controller.subsEnabled,
                onSubsToggle: controller.toggleSubs,
                maxSubstitutes: controller.maxSubstitutes,
                onMaxSubsIncrement: controller.incrementSubs,
                onMaxSubsDecrement: controller.decrementSubs,
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // Team Builder Section (Side A & Side B Roster Cards)
              TeamBuilderSection(
                sectionTitle: 'BATTLE ROSTERS',
                homeTeamController: controller.homeTeamController,
                awayTeamController: controller.awayTeamController,
                homeTeamName: controller.homeTeamName,
                awayTeamName: controller.awayTeamName,
                homeTeamRoster: controller.teamARoster,
                awayTeamRoster: controller.teamBRoster,
                onSelectHomePlayers: () => controller.openPlayerSelection(context, true),
                onSelectAwayPlayers: () => controller.openPlayerSelection(context, false),
                onRemovePlayer: (isHome, friend) =>
                    controller.removeTeamPlayer(isHome, friend),
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // Match Duration Stepper & Quick-Select Card
              CommonMatchDurationCard(
                title: 'QUARTER DURATION',
                subtitle: 'Minutes per\nQuarter',
                durationMinutes: controller.quarterDurationMinutes,
                presetMinutes: const [8, 10, 12, 15],
                onIncrement: () => controller.setQuarterDuration(
                    controller.quarterDurationMinutes.value + 1),
                onDecrement: () {
                  if (controller.quarterDurationMinutes.value > 1) {
                    controller.setQuarterDuration(
                        controller.quarterDurationMinutes.value - 1);
                  }
                },
                onPresetSelected: (val) => controller.setQuarterDuration(val),
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // Pro Rules Switch Card
              ProRulesSwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'Pro Rules Mode',
                subtitle: 'Enforces 24s Shot Clock &\nOfficial Quarter Duration',
              ),
              SizedBox(height: ResponsiveHelper.h(32.0)),

              // Scrollable Start Match Button (Not sticky at bottom)
              CommonStartMatchButton(
                label: 'PROCEED TO JUMP BALL',
                onPressed: () => controller.proceedToJumpBall(context),
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),
            ],
          ),
        ),
      ),
    );
  }
}
