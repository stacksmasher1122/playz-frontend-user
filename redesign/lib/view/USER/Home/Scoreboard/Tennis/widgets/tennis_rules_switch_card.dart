import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/switch_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/stepper_card.dart';

class TennisRulesSwitchCard extends StatelessWidget {
  final RxBool isFriendlyMode;
  final Function(bool) onFriendlyModeChanged;
  final RxInt gamesPerSet;
  final Function(int) onGamesPerSetChanged;
  final RxInt tiebreakTarget;
  final Function(int) onTiebreakTargetChanged;
  final RxBool noAdScoring;
  final Function(bool) onNoAdScoringChanged;

  const TennisRulesSwitchCard({
    super.key,
    required this.isFriendlyMode,
    required this.onFriendlyModeChanged,
    required this.gamesPerSet,
    required this.onGamesPerSetChanged,
    required this.tiebreakTarget,
    required this.onTiebreakTargetChanged,
    required this.noAdScoring,
    required this.onNoAdScoringChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SwitchCard(
          valueStream: isFriendlyMode,
          onChanged: onFriendlyModeChanged,
          title: 'Friendly Mode',
          subtitle: 'Shorter sets, No-Ad scoring,\nand casual parameters',
          icon: Icons.sports_tennis_rounded,
        ),
        Obx(
          () => isFriendlyMode.value
              ? Padding(
                  padding: EdgeInsets.only(top: ResponsiveHelper.h(16)),
                  child: Column(
                    children: [
                      // Games Per Set Stepper
                      StepperCard(
                        title: 'GAMES PER SET',
                        titleColor: AppColors.primaryGreen,
                        mainText: 'Games to Win\nSet',
                        valueStream: gamesPerSet,
                        onDecrement: () {
                          if (gamesPerSet.value > 2) {
                            onGamesPerSetChanged(gamesPerSet.value - 1);
                          }
                        },
                        onIncrement: () {
                          if (gamesPerSet.value < 8) {
                            onGamesPerSetChanged(gamesPerSet.value + 1);
                          }
                        },
                      ),
                      SizedBox(height: ResponsiveHelper.h(16)),

                      // Tiebreak Target Stepper
                      StepperCard(
                        title: 'TIEBREAK POINTS',
                        titleColor: AppColors.primaryGreen,
                        mainText: 'Tiebreak Target\nPoints',
                        valueStream: tiebreakTarget,
                        onDecrement: () {
                          if (tiebreakTarget.value > 5) {
                            onTiebreakTargetChanged(tiebreakTarget.value - 1);
                          }
                        },
                        onIncrement: () {
                          if (tiebreakTarget.value < 12) {
                            onTiebreakTargetChanged(tiebreakTarget.value + 1);
                          }
                        },
                      ),
                      SizedBox(height: ResponsiveHelper.h(16)),

                      // No-Ad Scoring Toggle
                      SwitchCard(
                        valueStream: noAdScoring,
                        onChanged: onNoAdScoringChanged,
                        title: 'No-Ad Scoring',
                        subtitle: 'At 40-40, next point\nwins the game',
                        icon: Icons.bolt_rounded,
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
