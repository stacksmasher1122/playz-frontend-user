import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/squad_config_section.dart';
import 'package:redesign/common/team_builder_section.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_start_match_button.dart';

class HockeySetupScreen extends StatelessWidget {
  const HockeySetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.put(HockeyController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: const ArenaTitleText(sportName: 'Hockey'),
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
              // Setup Match Header Card with 3D Blue Hockey Turf Asset
              const SetupMatchHeader(
                title: 'Setup Match',
                subtitle: 'Configure pitch squad, periods,\nbattle rosters and FIH rules.',
                imageAsset: 'assets/hockey_pitch_3d.png',
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

              // FIH Pro Rules Switch Card
              ProRulesSwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'FIH Pro Rules',
                subtitle: 'Standard 4x15m Quarters, 11v11 field layout',
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
