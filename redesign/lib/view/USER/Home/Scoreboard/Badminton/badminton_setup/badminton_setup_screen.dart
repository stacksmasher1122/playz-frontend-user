import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/common_match_mode_sets_card.dart';
import 'package:redesign/common/common_team_formation_card.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_start_match_button.dart';

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
        leading: const AppBackButton(),
        title: const ArenaTitleText(sportName: 'Badminton'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 3D Badminton Court Header
                const SetupMatchHeader(
                  imageAsset: 'assets/badminton_court_3d.png',
                  title: 'Setup Match',
                  subtitle: 'Configure your match rules and select your players.',
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),

                // 2. Common Match Mode & Sets Card (Singles/Doubles & Best of Sets)
                CommonMatchModeSetsCard(
                  format: controller.format.value,
                  setsFormat: controller.setsFormat.value,
                  onFormatChanged: controller.setFormat,
                  onSetsFormatChanged: controller.setSetsFormat,
                ),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 3. Common Team Formation Card (Singles/Doubles Rosters & Team Names)
                CommonTeamFormationCard(
                  format: controller.format.value,
                  homeTeamController: controller.homeTeamController,
                  awayTeamController: controller.awayTeamController,
                  homeTeamRoster: controller.teamARoster,
                  awayTeamRoster: controller.teamBRoster,
                  onSelectHomePlayer: () => controller.openPlayerSelection(context, true),
                  onSelectAwayPlayer: () => controller.openPlayerSelection(context, false),
                  onRemovePlayer: (isHome, friend) => controller.removeTeamPlayer(isHome, friend),
                ),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 4. Common Pro Rules Switch Card
                ProRulesSwitchCard(
                  valueStream: controller.isProRules,
                  onChanged: controller.toggleProRules,
                  title: 'BWF PRO RULES',
                  subtitle: 'Formal BWF match rules & 21-point set cap',
                ),
                SizedBox(height: ResponsiveHelper.h(28.0)),

                // 5. Common Start Match Button (Unpinned inside scrollable Column)
                CommonStartMatchButton(
                  label: 'PROCEED TO COIN TOSS',
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.openTossDecision(context),
                ),
                SizedBox(height: ResponsiveHelper.h(24.0)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
