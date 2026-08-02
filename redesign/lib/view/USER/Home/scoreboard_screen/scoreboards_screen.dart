import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/services/scoreboard_recovery_manager.dart';

// Widgets
import 'widgets/scoreboard_app_bar.dart';
import 'widgets/create_scoreboard_hero.dart';
import 'widgets/create_tournament_card.dart';
import 'package:redesign/view/USER/Tournament/create_tournament/create_tournament_screen.dart';
import 'widgets/scorecard_detail_sheet.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;

class ScoreboardHubScreen extends StatefulWidget {
  const ScoreboardHubScreen({super.key});

  @override
  State<ScoreboardHubScreen> createState() => _ScoreboardHubScreenState();
}

class _ScoreboardHubScreenState extends State<ScoreboardHubScreen> {
  List<RecoverableMatchItem> _bookedSlotUnfinished = [];
  List<ScoreboardHubItem> _hubMatches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScoreboardData();
  }

  Future<void> _loadScoreboardData() async {
    final bookedSlotUnfinished = await ScoreboardRecoveryManager.getUnfinishedBookedSlotMatches();
    final hubMatches = await ScoreboardRecoveryManager.getHubScoreboardMatches();
    if (mounted) {
      setState(() {
        _bookedSlotUnfinished = bookedSlotUnfinished;
        _hubMatches = hubMatches;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadScoreboardData,
          color: AppColors.accent,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              ScoreboardAppBar(),

              /// UNFINISHED BOOKED SLOT MATCHES RECOVERY SECTION (Above Create Tournament)
              if (_bookedSlotUnfinished.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2B22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.restore, color: AppColors.accent, size: 20),
                                  SizedBox(width: ResponsiveHelper.w(8)),
                                  Text(
                                    'Unfinished Booked Slot Matches',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.sp(14),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_bookedSlotUnfinished.length}',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveHelper.h(10)),
                          ..._bookedSlotUnfinished.map((item) {
                            return Container(
                              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8)),
                              padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                              decoration: BoxDecoration(
                                color: const Color(0xFF141414),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.sport == 'Cricket' ? Icons.sports_cricket : Icons.sports_tennis,
                                    color: AppColors.accent,
                                    size: 22,
                                  ),
                                  SizedBox(width: ResponsiveHelper.w(12)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: ResponsiveHelper.sp(13),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '${item.subtitle} • Booked Slot',
                                          style: GoogleFonts.inter(
                                            color: AppColors.muted,
                                            fontSize: ResponsiveHelper.sp(11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await ScoreboardRecoveryManager.resumeMatch(context, item);
                                      _loadScoreboardData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: 6),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                      'Resume',
                                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.w(6)),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white38, size: 18),
                                    onPressed: () async {
                                      await ScoreboardRecoveryManager.discardMatch(item);
                                      _loadScoreboardData();
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

              /// CREATE TOURNAMENT CARD
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 18),
                  child: CreateTournamentCard(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
                      );
                    },
                  ),
                ),
              ),

              /// CREATE SCOREBOARD HERO CARD
              SliverToBoxAdapter(child: CreateScoreboardHero()),

              /// HEADER FOR SCOREBOARDS LIST BELOW HERO CARD
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scoreboards & Matches',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_hubMatches.isNotEmpty)
                        Text(
                          '${_hubMatches.length} scoreboards',
                          style: GoogleFonts.inter(
                            color: AppColors.muted,
                            fontSize: ResponsiveHelper.sp(12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              /// SCORECARDS LIST (Completed Booked, Completed Manual, Incomplete Manual)
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
                  ),
                )
              else if (_hubMatches.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.sports_score, color: AppColors.muted, size: 40),
                          SizedBox(height: 10),
                          Text(
                            'No Scoreboards Found',
                            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Create a new scoreboard above to track your scores.',
                            style: GoogleFonts.inter(color: AppColors.muted, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _hubMatches[index];
                        return _buildScoreboardHubCard(item);
                      },
                      childCount: _hubMatches.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMatchDate(DateTime? dt) {
    if (dt == null) return '02 Aug 2026';
    try {
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return '02 Aug 2026';
    }
  }

  Widget _buildScoreboardHubCard(ScoreboardHubItem item) {
    Color badgeBg;
    Color badgeBorder;
    Color badgeText;
    IconData badgeIcon;

    if (item.isCompleted) {
      if (item.isBooked) {
        badgeBg = const Color(0xFF142B20);
        badgeBorder = AppColors.accent.withValues(alpha: 0.4);
        badgeText = AppColors.accent;
        badgeIcon = Icons.check_circle_outline;
      } else {
        badgeBg = const Color(0xFF162536);
        badgeBorder = Colors.blue.withValues(alpha: 0.4);
        badgeText = Colors.blue;
        badgeIcon = Icons.check_circle_outline;
      }
    } else {
      badgeBg = const Color(0xFF2E2214);
      badgeBorder = Colors.amber.withValues(alpha: 0.4);
      badgeText = Colors.amber;
      badgeIcon = Icons.pending_actions;
    }

    final String displayDate = _formatMatchDate(item.createdAt ?? item.lastUpdatedAt);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: InkWell(
        onTap: () {
          ScorecardDetailSheet.show(context, item);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Status Badge & Sport Icon with Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: badgeBorder, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(badgeIcon, size: 13, color: badgeText),
                        const SizedBox(width: 5),
                        Text(
                          item.statusDisplay,
                          style: GoogleFonts.inter(
                            color: badgeText,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Icon(
                        item.sport == 'Cricket' ? Icons.sports_cricket : Icons.sports_tennis,
                        color: AppColors.muted,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.sport,
                        style: GoogleFonts.inter(color: AppColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.h(12)),

              // Title and Subtitle Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.sp(15),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${item.subtitle} • $displayDate',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: ResponsiveHelper.sp(12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Resume button if Incomplete Manual
                  if (!item.isCompleted && !item.isBooked)
                    ElevatedButton.icon(
                      onPressed: () async {
                        final recoverable = RecoverableMatchItem(
                          matchId: item.matchId,
                          sport: item.sport,
                          matchType: item.matchType,
                          title: item.title,
                          subtitle: item.subtitle,
                          lastUpdatedAt: item.lastUpdatedAt,
                        );
                        await ScoreboardRecoveryManager.resumeMatch(context, recoverable);
                        _loadScoreboardData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: Text(
                        'Resume',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

