import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Brackets & Matches",
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(16),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (controller.canShuffle.value)
                  IconButton(
                    icon: const Icon(Icons.shuffle_rounded, color: AppColors.accent),
                    onPressed: controller.shuffleBracket,
                  ),
              ],
            ),
            SizedBox(height: context.heightPct(1.5)),

            if (controller.matches.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.heightPct(3)),
                  child: Column(
                    children: [
                      const Icon(Icons.account_tree_rounded, color: AppColors.muted, size: 48),
                      SizedBox(height: context.heightPct(1.5)),
                      Text(
                        "Waiting for teams to register.",
                        style: AppTypography.bodyMd.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(13),
                        ),
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(5),
                      vertical: context.heightPct(1.2),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => BracketMatchmakingScreen(
                      tournamentId: widget.tournamentId,
                      isOrganizer: widget.isOrganizer,
                    ));
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "View Full Bracket",
                      style: AppTypography.labelCaps10.copyWith(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(13),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
