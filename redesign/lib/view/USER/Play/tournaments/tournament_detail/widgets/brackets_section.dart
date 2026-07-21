import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../../controller/User_Controller/Tournament_Controller/bracket_controller.dart';
import '../../../../../../model/User_Models/Tournament_Model/bracket_model.dart';

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
              _buildMatchesList(),
          ],
        );
      }),
    );
  }

  Widget _buildMatchesList() {
    // Group matches by round or group Name
    Map<String, List<BracketMatchModel>> grouped = {};
    for (var m in controller.matches) {
      String key = m.groupName ?? "Round ${m.round}";
      grouped.putIfAbsent(key, () => []).add(m);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) {
      if (a.startsWith('Round') && b.startsWith('Round')) {
        int rA = int.parse(a.split(' ')[1]);
        int rB = int.parse(b.split(' ')[1]);
        return rA.compareTo(rB);
      }
      return a.compareTo(b);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedKeys.map((key) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
              child: Text(
                key,
                style: AppTypography.bodyLg.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
            ),
            ...grouped[key]!.map((match) => _buildMatchCard(match)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMatchCard(BracketMatchModel match) {
    String teamA = _getTeamName(match.teamAId);
    String teamB = _getTeamName(match.teamBId);

    String timeStr = "Unscheduled";
    if (match.scheduledDate != null) {
      final formatter = DateFormat('MMM d, h:mm a');
      timeStr = formatter.format(match.scheduledDate!);
    }

    bool isBye = match.teamAId == null || match.teamBId == null;

    return GestureDetector(
      onTap: () {
        if (widget.isOrganizer && !isBye) {
          controller.scheduleMatch(match, context);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(color: match.status == 'completed' ? AppColors.accent : Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(teamA, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  Text("vs", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  Text(teamB, style: AppTypography.bodyMd.copyWith(color: AppColors.onPrimary)),
                ],
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: isBye ? AppColors.card : AppColors.background,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              ),
              child: Column(
                children: [
                  Icon(isBye ? Icons.fast_forward : Icons.access_time, color: AppColors.muted, size: 14),
                  SizedBox(height: 4),
                  Text(
                    isBye ? "Auto-Advance" : timeStr,
                    style: AppTypography.bodySm.copyWith(color: AppColors.muted, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
