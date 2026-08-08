import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';
import 'package:redesign/common/arena_title_text.dart';
import 'package:redesign/common/setup_match_header.dart';
import 'package:redesign/common/squad_config_section.dart';
import 'package:redesign/common/team_builder_section.dart';
import 'package:redesign/common/pro_rules_switch_card.dart';
import 'package:redesign/common/common_start_match_button.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';

class VolleyballSetupScreen extends StatelessWidget {
  VolleyballSetupScreen({super.key});

  final VolleyballController controller = Get.isRegistered<VolleyballController>()
      ? Get.find<VolleyballController>()
      : Get.put(VolleyballController());

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
        title: const ArenaTitleText(sportName: 'Volleyball'),
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
              // Setup Match Header Card with 3D Volleyball Court Asset
              const SetupMatchHeader(
                title: 'Setup Match',
                subtitle: 'Configure court squad, set targets,\nbattle rosters and FIVB rules.',
                imageAsset: 'assets/volleyball_court_3d.png',
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

              // Match Max Sets Stepper Card
              _buildMaxSetsCard(context, controller),
              SizedBox(height: ResponsiveHelper.h(24.0)),

              // FIVB Pro Rules Switch Card
              ProRulesSwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'FIVB Pro Rules',
                subtitle: 'Enforces 5-Set Match, 25-Point Sets\n& Standard 6v6 Court Squad',
              ),
              SizedBox(height: ResponsiveHelper.h(32.0)),

              // Scrollable Start Match Button (Not sticky at bottom)
              CommonStartMatchButton(
                label: 'PROCEED TO COIN TOSS',
                onPressed: () => controller.proceedToCoinToss(context),
              ),
              SizedBox(height: ResponsiveHelper.h(24.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaxSetsCard(BuildContext context, VolleyballController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MATCH FORMAT',
                    style: AppTypography.labelCaps.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(11.0),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ).responsive(context),
                  ),
                  SizedBox(height: ResponsiveHelper.h(4.0)),
                  Text(
                    'Best of Sets',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(18.0),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCircleBtn(
                    context,
                    icon: Icons.remove,
                    color: const Color(0xFF131313),
                    iconColor: AppColors.accent,
                    onTap: () {
                      if (controller.maxSets.value > 1) {
                        controller.setMaxSets(controller.maxSets.value - 2);
                      }
                    },
                  ),
                  SizedBox(width: ResponsiveHelper.w(16.0)),
                  Obx(
                    () => SizedBox(
                      width: ResponsiveHelper.w(28.0),
                      child: Text(
                        controller.maxSets.value.toString(),
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(22.0),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(16.0)),
                  _buildCircleBtn(
                    context,
                    icon: Icons.add,
                    color: AppColors.accent,
                    iconColor: Colors.black,
                    onTap: () {
                      if (controller.maxSets.value < 5) {
                        controller.setMaxSets(controller.maxSets.value + 2);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // Preset Chips Row for Max Sets (1, 3, 5 Sets)
          Obx(() {
            const presets = [1, 3, 5];
            return Row(
              children: presets.map((sets) {
                final isSelected = controller.maxSets.value == sets;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: sets != 5 ? ResponsiveHelper.w(8.0) : 0,
                    ),
                    child: InkWell(
                      onTap: () => controller.setMaxSets(sets),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10.0)),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : const Color(0xFF141822),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.white.withValues(alpha: 0.08),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Text(
                          '$sets ${sets == 1 ? "Set" : "Sets"}',
                          textAlign: TextAlign.center,
                          style: AppTypography.labelCaps.copyWith(
                            color: isSelected ? AppColors.accent : AppColors.textSecondary,
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ).responsive(context),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
      child: Container(
        width: ResponsiveHelper.w(40.0),
        height: ResponsiveHelper.w(40.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: ResponsiveHelper.w(20.0)),
      ),
    );
  }
}
