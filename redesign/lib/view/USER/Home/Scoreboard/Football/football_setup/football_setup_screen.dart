import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

// Common Setup Widgets
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/squad_config_section.dart';
import 'package:redesign/common/team_builder_section.dart';
import 'package:redesign/common/common_match_duration_card.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_select_players_sheet.dart';
import 'package:redesign/common/common_start_match_button.dart';

// Controller & Toss
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/coin_toss/coin_toss_screen.dart';

/// Standardized Football Match Setup Screen utilizing PlayZ common setup components.
class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  late final FootballCreateMatchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<FootballCreateMatchController>()
        ? Get.find<FootballCreateMatchController>()
        : Get.put(FootballCreateMatchController());
  }

  void _goToCoinToss(BuildContext context) {
    if (!controller.validateForm()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinFlipScreen(
          teamAName: controller.homeTeamName.value,
          teamBName: controller.awayTeamName.value,
          sport: 'football',
          onTossComplete: (winner, decision) async {
            await controller.createMatchAndStart(
              context,
              tossWinner: winner,
              tossDecision: decision,
            );
          },
        ),
      ),
    );
  }

  void _openSelectPlayersSheet(BuildContext context, {required bool isHome}) {
    CommonSelectPlayersBottomSheet.show(
      context,
      title: isHome
          ? 'Select ${controller.homeTeamName.value} Players'
          : 'Select ${controller.awayTeamName.value} Players',
      maxCount: controller.maxAllowedPlayers.value,
      selectedPlayerEmails:
          isHome ? controller.homeTeamPlayers : controller.awayTeamPlayers,
      opponentPlayerEmails:
          isHome ? controller.awayTeamPlayers : controller.homeTeamPlayers,
      currentUserModel: controller.currentUserFriendModel.value,
      onPlayerSelected: (friend) {
        controller.addTeamPlayer(isHome, friend);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Center(
          child: AppBackButton(
            size: ResponsiveHelper.w(38.0),
          ),
        ),
        leadingWidth: ResponsiveHelper.w(56.0),
        title: const ArenaTitleText(sportName: 'Football'),
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
                // 1. Setup Match Upper Header Banner (3D Football Pitch Asset)
                const SetupMatchHeader(
                  title: 'Match Setup',
                  subtitle: 'Configure your match rules\nand draft your squads.',
                  imageAsset: 'assets/football_pitch_3d.png',
                  imageHeight: 115.0,
                ),

                // 2. Squad Limit, Subs Toggle & Max Subs Cards
                SquadConfigSection(
                  squadLimit: controller.maxAllowedPlayers,
                  onSquadLimitDecrement: controller.decrementSquadLimit,
                  onSquadLimitIncrement: controller.incrementSquadLimit,
                  subsEnabled: controller.subsEnabled,
                  onSubsToggle: controller.toggleSubs,
                  maxSubstitutes: controller.maxSubs,
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
                  homeAccentColor: const Color(0xFF1DB954),
                  awayAccentColor: const Color(0xFFE53935),
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // 4. Match Duration Stepper Card
                Obx(
                  () => CommonMatchDurationCard(
                    title: 'HALF DURATION',
                    subtitle: 'Half Duration in\nMinutes',
                    durationMinutes: controller.duration.value.toInt().obs,
                    onDecrement: controller.decrementDuration,
                    onIncrement: controller.incrementDuration,
                    presetMinutes: const [10, 15, 20, 30, 45, 90],
                    onPresetSelected: (mins) => controller.setDuration(mins),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 5. Pro Rules Switch Card
                ProRulesSwitchCard(
                  valueStream: controller.allowProRules,
                  onChanged: controller.toggleProRules,
                  title: 'PRO RULES',
                  subtitle: 'Formal Match Guidelines, Offsides & VAR Simulation',
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // 6. Non-sticky Start Match Button (Placed inside scrollable Column)
                Obx(
                  () => CommonStartMatchButton(
                    label: 'START MATCH',
                    isLoading: controller.isLoading.value,
                    onPressed: () => _goToCoinToss(context),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
