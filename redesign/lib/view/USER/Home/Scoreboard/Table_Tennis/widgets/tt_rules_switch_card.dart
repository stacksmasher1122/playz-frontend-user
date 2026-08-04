import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/switch_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/stepper_card.dart';

class TtRulesSwitchCard extends StatelessWidget {
  final RxBool isFriendlyMode;
  final Function(bool) onFriendlyModeChanged;
  final RxInt pointsPerGame;
  final Function(int) onPointsPerGameChanged;

  const TtRulesSwitchCard({
    super.key,
    required this.isFriendlyMode,
    required this.onFriendlyModeChanged,
    required this.pointsPerGame,
    required this.onPointsPerGameChanged,
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
          subtitle: 'Custom game points (7, 11, 21)\nand casual parameters',
          icon: Icons.sports_rounded,
        ),
        Obx(
          () => isFriendlyMode.value
              ? Padding(
                  padding: EdgeInsets.only(top: ResponsiveHelper.h(16)),
                  child: Column(
                    children: [
                      // Points Per Game Stepper
                      StepperCard(
                        title: 'POINTS PER GAME',
                        titleColor: AppColors.primaryGreen,
                        mainText: 'Points to Win\nGame',
                        valueStream: pointsPerGame,
                        onDecrement: () {
                          if (pointsPerGame.value == 21) {
                            onPointsPerGameChanged(11);
                          } else if (pointsPerGame.value == 11) {
                            onPointsPerGameChanged(7);
                          }
                        },
                        onIncrement: () {
                          if (pointsPerGame.value == 7) {
                            onPointsPerGameChanged(11);
                          } else if (pointsPerGame.value == 11) {
                            onPointsPerGameChanged(21);
                          }
                        },
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
