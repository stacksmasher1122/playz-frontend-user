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
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class KabaddiSetupScreen extends StatelessWidget {
  KabaddiSetupScreen({super.key});

  final KabaddiController controller = Get.isRegistered<KabaddiController>()
      ? Get.find<KabaddiController>()
      : Get.put(KabaddiController());

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
        title: const ArenaTitleText(sportName: 'Kabaddi'),
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
              // Setup Match Header Card with 3D Kabaddi Court Asset
              const SetupMatchHeader(
                title: 'Match Setup',
                subtitle: 'Configure your Kabaddi arena rules\nand draft your squads.',
                imageAsset: 'assets/kabaddi_court_3d.png',
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
                title: 'HALF DURATION',
                subtitle: 'Minutes per\nHalf',
                durationMinutes: controller.halfDurationMinutes,
                presetMinutes: const [10, 15, 20, 30],
                onIncrement: () => controller
                    .setHalfDuration(controller.halfDurationMinutes.value + 5),
                onDecrement: () {
                  if (controller.halfDurationMinutes.value > 5) {
                    controller.setHalfDuration(
                        controller.halfDurationMinutes.value - 5);
                  }
                },
                onPresetSelected: (val) => controller.setHalfDuration(val),
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // Pro Rules Switch Card
              ProRulesSwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'Pro Rules Mode',
                subtitle: 'Enables 30s Raid Clock,\nDo-or-Die & Super Tackle',
              ),
              SizedBox(height: ResponsiveHelper.h(32.0)),

              // Scrollable Proceed to Toss Button (Not sticky at bottom)
              CommonStartMatchButton(
                label: 'PROCEED TO COIN TOSS',
                onPressed: () => controller.goToToss(context),
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),
            ],
          ),
        ),
      ),
    );
  }
}
