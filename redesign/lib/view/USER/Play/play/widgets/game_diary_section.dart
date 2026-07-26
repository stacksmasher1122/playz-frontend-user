import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:redesign/theme/app_colors.dart';
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

          final hostedCount = diaryMatches.where((m) => m.hostId == docId).length;
          final totalPlayed = diaryMatches.length;

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: 12),
            children: [
              /// STATS SUMMARY HEADER CARD
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(label: 'Total Games', value: '$totalPlayed', icon: Icons.sports_score),
                    Container(height: 36, width: 1, color: Colors.white12),
                    _StatItem(label: 'Hosted', value: '$hostedCount', icon: Icons.add_task),
                    Container(height: 36, width: 1, color: Colors.white12),
                    _StatItem(label: 'XP Earned', value: '${totalPlayed * 100}', icon: Icons.stars),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Text(
                    'My Match History',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${diaryMatches.length} Matches',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              if (diaryMatches.isEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(36)),
                  child: Column(
                    children: [
                      Icon(Icons.history_toggle_off, size: 56, color: Colors.white24),
                      SizedBox(height: 12),
                      Text(
                        'No Participated Games Yet',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Join or host a match poll to add entries to your Game Diary!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontSize: ResponsiveHelper.sp(13),
                        ),
                      ),
                      SizedBox(height: 18),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HostMatchScreen()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Host Your First Match', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    return GameCard(data: diaryMatches[index]);
                  },
                ),
              ],
            ],
          );
        });
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
        SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.sp(16),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: ResponsiveHelper.sp(11),
          ),
        ),
      ],
    );
  }
}
