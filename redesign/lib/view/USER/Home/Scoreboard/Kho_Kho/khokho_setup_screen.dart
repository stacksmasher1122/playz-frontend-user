import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kho_Kho/khokho_controller.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/squad_config_section.dart';
import 'package:redesign/common/common_match_duration_card.dart';
import 'package:redesign/common/team_builder_section.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_start_match_button.dart';

class KhoKhoSetupScreen extends StatelessWidget {
  const KhoKhoSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.put(KhoKhoController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: const ArenaTitleText(sportName: 'Kho Kho'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Setup Match Header Card with 3D Kho Kho Court Asset
              const SetupMatchHeader(
                title: 'Setup Match',
                subtitle: 'Configure court squad, turns,\nbattle rosters and KKFI rules.',
                imageAsset: 'assets/khokho_court_3d.png',
                imageHeight: 115.0,
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // Squad Limit, Subs Toggle & Max Substitutes Section
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

              // Turn Duration Stepper Card
              CommonMatchDurationCard(
                title: 'TURN DURATION',
                subtitle: 'Duration in\nMinutes',
                durationMinutes: controller.turnDurationMinutes,
                onDecrement: controller.decrementTurnDuration,
                onIncrement: controller.incrementTurnDuration,
                presetMinutes: const [5, 7, 9, 12],
                onPresetSelected: (mins) => controller.setTurnDuration(mins),
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

              // KKFI Pro Rules Switch Card
              ProRulesSwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'KKFI Pro Rules',
                subtitle: 'Standard 4 Turns (2 Innings), 9v9 active field, 9m turn duration',
              ),
              SizedBox(height: ResponsiveHelper.h(32.0)),

              // Scrollable Start Match Button (NOT sticky at bottom)
              CommonStartMatchButton(
                label: 'PROCEED TO COIN TOSS',
                onPressed: () => controller.proceedToCoinToss(context),
              ),
              SizedBox(height: ResponsiveHelper.h(32.0)),
            ],
          ),
        ),
      ),
    );
  }
}
