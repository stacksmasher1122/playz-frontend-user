import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/tennis_controller.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/common_match_mode_sets_card.dart';
import 'package:redesign/common/common_team_formation_card.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_start_match_button.dart';

class TennisSetupScreen extends StatelessWidget {
  const TennisSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.put(TennisController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: const ArenaTitleText(sportName: 'Tennis'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          child: Obx(() {
            final format = controller.format.value;
            final setsFormat = controller.setsFormat.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── 1. SETUP MATCH HEADER WITH 3D TENNIS COURT ASSET ───
                const SetupMatchHeader(
                  title: 'Setup Match',
                  subtitle: 'Configure court format, sets,\nteam rosters and ITF rules.',
                  imageAsset: 'assets/tennis_court_3d.png',
                  imageHeight: 115.0,
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // ─── 2. MATCH MODE (SINGLES/DOUBLES) & BEST OF SETS CARD ───
                CommonMatchModeSetsCard(
                  title: 'MATCH MODE & SETS',
                  format: format,
                  setsFormat: setsFormat,
                  onFormatChanged: (newFormat) => controller.setFormat(newFormat),
                  onSetsFormatChanged: (newSets) => controller.setSetsFormat(newSets),
                  availableSets: const ['BEST_OF_1', 'BEST_OF_3', 'BEST_OF_5'],
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // ─── 3. TEAM FORMATION CARD (MATCHING REFERENCE UI) ───
                CommonTeamFormationCard(
                  format: format,
                  homeTeamController: controller.homeTeamController,
                  awayTeamController: controller.awayTeamController,
                  homeTeamRoster: controller.homeTeamRoster,
                  awayTeamRoster: controller.awayTeamRoster,
                  onSelectHomePlayer: () => controller.openPlayerSelection(context, true),
                  onSelectAwayPlayer: () => controller.openPlayerSelection(context, false),
                  onRemovePlayer: (isHome, friend) =>
                      controller.removeTeamPlayer(isHome, friend),
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // ─── 4. ITF PRO RULES SWITCH CARD ───
                ProRulesSwitchCard(
                  valueStream: controller.isProRules,
                  onChanged: controller.toggleProRules,
                  title: 'ITF Pro Rules',
                  subtitle: 'Standard 6 Games per Set, Advantage scoring, Tiebreak at 6-6',
                ),
                SizedBox(height: ResponsiveHelper.h(32.0)),

                // ─── 5. SCROLLABLE START MATCH BUTTON ───
                CommonStartMatchButton(
                  label: 'PROCEED TO COIN TOSS',
                  onPressed: () => controller.goToToss(context),
                ),
                SizedBox(height: ResponsiveHelper.h(32.0)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
