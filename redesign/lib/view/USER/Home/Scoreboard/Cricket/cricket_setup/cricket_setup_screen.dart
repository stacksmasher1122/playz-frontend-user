import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/squad_config_section.dart';
import 'package:redesign/common/team_builder_section.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_select_players_sheet.dart';
import 'package:redesign/common/common_start_match_button.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'widgets/large_stepper_card.dart';

class FriendlySetupScreen extends StatelessWidget {
  FriendlySetupScreen({super.key});

  final CricketController controller = Get.put(CricketController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Center(
          child: AppBackButton(
            size: 40.0,
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        leadingWidth: ResponsiveHelper.w(56.0),
        title: const ArenaTitleText(sportName: 'Cricket'),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(20.0),
              vertical: ResponsiveHelper.h(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Setup Match Upper Header Banner (with 3D Cricket Pitch Asset)
                const SetupMatchHeader(
                  title: 'Setup Match',
                  subtitle: 'Configure your match rules\nand draft your squads.',
                  imageAsset: 'assets/cricket_pitch_3d.png',
                  imageHeight: 115.0,
                ),

                // 2. Squad Limit, Subs Toggle & Max Subs Cards
                SquadConfigSection(
                  squadLimit: controller.squadLimit,
                  onSquadLimitDecrement: controller.decrementSquadLimit,
                  onSquadLimitIncrement: controller.incrementSquadLimit,
                  subsEnabled: controller.subsEnabled,
                  onSubsToggle: controller.toggleSubs,
                  maxSubstitutes: controller.maxSubstitutes,
                  onMaxSubsDecrement: controller.decrementSubs,
                  onMaxSubsIncrement: controller.incrementSubs,
                ),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 3. Team Formation / Team Builder Cards
                TeamBuilderSection(
                  sectionTitle: 'TEAM FORMATION',
                  homeTeamController: controller.homeTeamController,
                  awayTeamController: controller.awayTeamController,
                  homeTeamName: controller.homeTeamName,
                  awayTeamName: controller.awayTeamName,
                  homeTeamRoster: controller.homeTeamRoster,
                  awayTeamRoster: controller.awayTeamRoster,
                  onSelectHomePlayers: () => _openSelectPlayersSheet(context, isHome: true),
                  onSelectAwayPlayers: () => _openSelectPlayersSheet(context, isHome: false),
                  onRemovePlayer: (isHome, friend) => controller.removeTeamPlayer(isHome, friend),
                  homeAccentColor: const Color(0xFFFF6B6B),
                  awayAccentColor: const Color(0xFF4D96FF),
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // 4. Overs / Match Length Card
                LargeStepperCard(controller: controller),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 5. Pro Rules Switch Card
                ProRulesSwitchCard(
                  valueStream: controller.isFormalRules,
                  onChanged: controller.toggleFormalRules,
                  title: 'PRO RULES',
                  subtitle: 'Formal Match Guidelines & Offside/LBW/Over Rules',
                ),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 6. Non-sticky Start Match Button (Placed inside scrollable Column)
                Obx(
                  () => CommonStartMatchButton(
                    label: 'START MATCH',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.goToToss(),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(32.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSelectPlayersSheet(BuildContext context, {required bool isHome}) {
    CommonSelectPlayersBottomSheet.show(
      context,
      title: 'Select Players',
      maxCount: controller.maxAllowedPlayers,
      selectedPlayerEmails: isHome ? controller.homeTeamPlayers : controller.awayTeamPlayers,
      opponentPlayerEmails: isHome ? controller.awayTeamPlayers : controller.homeTeamPlayers,
      currentUserModel: controller.currentUserFriendModel.value,
      onPlayerSelected: (friend) {
        controller.addTeamPlayer(isHome, friend);
      },
    );
  }
}
