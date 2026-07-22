import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';
import '../../../../../../model/User_Models/Tournament_Model/bracket_model.dart';
import '../../bracket_matchmaking/bracket_matchmaking_screen.dart';

class BracketsSection extends StatefulWidget {
  final String tournamentId;
  final bool isOrganizer;

  const BracketsSection({
    super.key,
    required this.tournamentId,
    required this.isOrganizer,
  });

  @override
  State<BracketsSection> createState() => _BracketsSectionState();
}

class _BracketsSectionState extends State<BracketsSection> {
  late BracketController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      BracketController(tournamentId: widget.tournamentId, isOrganizer: widget.isOrganizer),
      tag: widget.tournamentId,
    );
  }

  @override
  void dispose() {
    Get.delete<BracketController>(tag: widget.tournamentId);
    super.dispose();
  }

  String _getTeamName(String? id) {
    if (id == null) return "BYE";
    final team = controller.teams.firstWhereOrNull((t) => t.id == id);
    return team?.name ?? "TBD";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Brackets & Matches", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
                if (controller.canShuffle.value)
                  IconButton(
                    icon: Icon(Icons.shuffle, color: AppColors.accent),
                    onPressed: controller.shuffleBracket,
                  ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16)),

            if (controller.matches.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(32)),
                  child: Column(
                    children: [
                      Icon(Icons.account_tree, color: AppColors.muted, size: ResponsiveHelper.w(48)),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      Text(
                        "Waiting for teams to register.",
                        style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(8))),
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(12)),
                  ),
                  onPressed: () {
                    Get.to(() => BracketMatchmakingScreen(
                      tournamentId: widget.tournamentId,
                      isOrganizer: widget.isOrganizer,
                    ));
                  },
                  child: Text(
                    "View Full Bracket",
                    style: AppTypography.labelCaps.copyWith(color: AppColors.background, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
