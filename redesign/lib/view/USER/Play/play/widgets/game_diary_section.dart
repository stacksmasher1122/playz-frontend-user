import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/view/USER/Play/play/widgets/game_list.dart';
import '../host_match/host_match_screen.dart';

class GameDiaryWidget extends StatelessWidget {
  const GameDiaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final matchCtrl = Get.isRegistered<MatchController>()
        ? Get.find<MatchController>()
        : Get.put(MatchController());

    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<String?>(
      future: UserPreferences.getDocId(),
      builder: (context, snapshot) {
        final docId = snapshot.data ?? user?.uid ?? '';

        return StreamBuilder<DocumentSnapshot>(
          stream: docId.isNotEmpty
              ? FirebaseFirestore.instance
                    .collection('User')
                    .doc(docId)
                    .snapshots()
              : null,
          builder: (context, userSnap) {
            final userData = userSnap.data?.data() as Map<String, dynamic>?;
            final statsMap = userData?['gameStats'] as Map<String, dynamic>?;

            return Obx(() {
              if (matchCtrl.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                );
              }

              final diaryMatches = matchCtrl.allMatches.where((m) {
                if (docId.isEmpty) return false;
                return m.hostId == docId || m.playerIds.contains(docId);
              }).toList();

              final computedHosted = diaryMatches
                  .where((m) => m.hostId == docId)
                  .length;
              final computedTotal = diaryMatches.length;

              final fbTotal =
                  (statsMap?['totalGamesPlayed'] as num?)?.toInt() ?? 0;
              final fbHosted = (statsMap?['totalHosted'] as num?)?.toInt() ?? 0;
              final fbXp = (statsMap?['xpPoints'] as num?)?.toInt() ?? 0;

              final displayTotal = computedTotal > fbTotal
                  ? computedTotal
                  : fbTotal;
              final displayHosted = computedHosted > fbHosted
                  ? computedHosted
                  : fbHosted;
              final displayXp = (computedTotal * 100) > fbXp
                  ? (computedTotal * 100)
                  : fbXp;

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(4),
                  vertical: context.heightPct(1.5),
                ),
                children: [
                  /// STATS SUMMARY HEADER CARD
                  Container(
                    padding: EdgeInsets.all(context.widthPct(4)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(4),
                      ),
                      gradient: AppColors.darkSurfaceOverlay,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          label: 'Total Games',
                          value: '$displayTotal',
                          icon: Icons.sports_score,
                        ),
                        Container(
                          height: context.heightPct(4),
                          width: 1,
                          color: AppColors.divider,
                        ),
                        _StatItem(
                          label: 'Hosted',
                          value: '$displayHosted',
                          icon: Icons.add_task,
                        ),
                        Container(
                          height: context.heightPct(4),
                          width: 1,
                          color: AppColors.divider,
                        ),
                        _StatItem(
                          label: 'XP Earned',
                          value: '$displayXp',
                          icon: Icons.stars,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: context.heightPct(2.5)),

                  Row(
                    children: [
                      Text(
                        'My Match History',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${diaryMatches.length} Matches',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.heightPct(1.5)),

                  if (diaryMatches.isEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.heightPct(4),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.history_toggle_off,
                            size: 56,
                            color: AppColors.muted,
                          ),
                          SizedBox(height: context.heightPct(1.5)),
                          Text(
                            'No Participated Games Yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: context.heightPct(0.8)),
                          Text(
                            'Join or host a match poll to add entries to your Game Diary!',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: context.responsiveFont(13),
                            ),
                          ),
                          SizedBox(height: context.heightPct(2.2)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  context.minDimensionPct(3),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const HostMatchScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Host Your First Match',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: diaryMatches.length,
                      itemBuilder: (context, index) {
                        final match = diaryMatches[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: context.heightPct(1.2),
                          ),
                          child: Dismissible(
                            key: Key('diary_${match.id}_$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.widthPct(5),
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF3B30),
                                    Color(0xFFB00020),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                  context.minDimensionPct(3.5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF3B30,
                                    ).withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      context.widthPct(2.2),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  SizedBox(width: context.widthPct(2.5)),
                                  Text(
                                    'DELETE',
                                    style: AppTypography.labelCaps10.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                      fontSize: context.responsiveFont(12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (_) {
                              matchCtrl.deleteMatchFromHistory(match.id, docId);
                            },
                            child: GameCard(data: match),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              );
            });
          },
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        SizedBox(height: context.heightPct(0.5)),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(16),
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.bodyXs.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFont(11),
          ),
        ),
      ],
    );
  }
}
