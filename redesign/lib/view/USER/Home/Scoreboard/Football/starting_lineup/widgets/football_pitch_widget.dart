import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/starting_lineup_controller.dart';
import 'pitch_lines_widget.dart';
import 'player_position_widget.dart';
import 'empty_position_widget.dart';
import 'goalkeeper_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballPitchWidget extends StatelessWidget {
  FootballPitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<StartingLineupController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(16.0)),
      child: AspectRatio(
        aspectRatio: 0.8, // Rectangular pitch shape
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade900.withValues(alpha: 0.2), // dark green tint
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: AppColors.accent, width: 1.5), // Lime border
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.1),
                blurRadius: 16,
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            children: [
              // 1. Pitch Lines Marking
              RepaintBoundary(
                child: PitchLinesWidget(),
              ),
              
              // 2. Dynamic Player Slots based on Formation
              Obx(() {
                final formation = controller.currentFormation.value;
                if (formation == null) return SizedBox();

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;

                    return Stack(
                      children: formation.positions.map((slot) {
                        final player = controller.getPlayerById(slot.assignedPlayerId);
                        final xPos = (slot.x * width) - 25; // 25 is half of the widget width to center it
                        final yPos = (slot.y * height) - 30; // 30 is approx half of the widget height

                        return AnimatedPositioned(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          left: xPos,
                          top: yPos,
                          child: DragTarget<String>(
                            onAcceptWithDetails: (details) {
                              final p = controller.squadPlayers.firstWhereOrNull((pl) => pl.id == details.data);
                              if (p != null) {
                                controller.dropPlayer(slot.label, p);
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              // If there is an active drag over this slot, we could highlight it
                              final isHovering = candidateData.isNotEmpty;

                              if (player != null) {
                                return PlayerPositionWidget(
                                  player: player,
                                  label: slot.label,
                                  onTap: () {
                                    // Remove or swap logic via bottom sheet
                                    controller.removePlayer(slot.label);
                                  },
                                  onLongPress: () {
                                    // Could implement drag-to-swap from pitch
                                  },
                                );
                              } else {
                                // "Center EMPTY slot" visually distinct based on prompt, let's say CM or M2
                                final isCenterActive = (slot.label == 'CM' || slot.label == 'M2') || isHovering;
                                return EmptyPositionWidget(
                                  label: slot.label,
                                  isCenterActive: isCenterActive,
                                  onTap: () {
                                    // Opens Player Selector BottomSheet
                                  },
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }),

              // 3. Goalkeeper (Fixed bottom center)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Obx(() {
                    return GoalkeeperWidget(
                      goalkeeper: controller.goalkeeper.value,
                      onTap: () {},
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
