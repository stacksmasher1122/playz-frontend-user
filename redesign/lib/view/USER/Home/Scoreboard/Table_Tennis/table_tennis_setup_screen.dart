import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Table_Tennis/table_tennis_controller.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/common_match_mode_sets_card.dart';
import 'package:redesign/common/common_team_formation_card.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_start_match_button.dart';

class TableTennisSetupScreen extends StatelessWidget {
  TableTennisSetupScreen({super.key});

  final TableTennisController controller = Get.put(TableTennisController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const AppBackButton(),
        title: const ArenaTitleText(sportName: 'Table Tennis'),
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
                // 1. 3D Blue Table Tennis Table Header Banner
                const SetupMatchHeader(
                  imageAsset: 'assets/table_tennis_table_3d.png',
                  title: 'Setup Match',
                  subtitle: 'Configure your match rules and draft your squads.',
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
                  homeTeamRoster: controller.homeTeamRoster,
                  awayTeamRoster: controller.awayTeamRoster,
                  onSelectHomePlayer: () => controller.openPlayerSelection(context, true),
                  onSelectAwayPlayer: () => controller.openPlayerSelection(context, false),
                  onRemovePlayer: (isHome, friend) => controller.removeTeamPlayer(isHome, friend),
                ),
                SizedBox(height: ResponsiveHelper.h(16.0)),

                // 4. Common Pro Rules Switch Card
                ProRulesSwitchCard(
                  valueStream: controller.isProRules,
                  onChanged: controller.toggleProRules,
                  title: 'ITTF PRO RULES',
                  subtitle: 'Formal ITTF match rules & 11-point set cap',
                ),
                SizedBox(height: ResponsiveHelper.h(28.0)),

                // 5. Common Start Match Button (Unpinned inside scrollable Column)
                CommonStartMatchButton(
                  label: 'PROCEED TO COIN TOSS',
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.goToToss(context),
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
