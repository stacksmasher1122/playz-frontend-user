import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/match_result_controller.dart';
import 'widgets/result_header_widget.dart';
import 'widgets/winner_card.dart';
import 'widgets/game_breakdown_widget.dart';
import 'widgets/summary_card_widget.dart';
import 'widgets/mvp_card_widget.dart';
import 'widgets/analytics_card_widget.dart';
import 'widgets/top_players_widget.dart';
import 'widgets/achievement_card_widget.dart';
import 'widgets/match_info_card_widget.dart';
import 'widgets/action_buttons_widget.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/live_match/widgets/live_bottom_navigation.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchResultScreen extends StatefulWidget {
  MatchResultScreen({super.key});

  @override
  State<MatchResultScreen> createState() => _MatchResultScreenState();
}

class _MatchResultScreenState extends State<MatchResultScreen> with SingleTickerProviderStateMixin {
  late final MatchResultController controller;
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MatchResultController());
    
    _entranceController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    Get.delete<MatchResultController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ResultHeaderWidget(),
      body: SafeArea(
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeIn,
          )),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
            child: Obx(() {
              if (controller.matchResult.value.matchId.isEmpty) return SizedBox.shrink();
              final result = controller.matchResult.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WinnerCard(controller: controller),
                  SizedBox(height: 24),
                  GameBreakdownWidget(games: result.games),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCardWidget(
                          icon: Icons.timer_outlined,
                          label: 'DURATION',
                          value: result.duration,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SummaryCardWidget(
                          icon: Icons.show_chart,
                          label: 'LONGEST RALLY',
                          value: '${result.analytics['longestRally'] ?? 0}',
                          unit: 'Shots',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCardWidget(
                          icon: Icons.sports_tennis,
                          label: 'AVG RALLY',
                          value: '${result.analytics['avgRally'] ?? 0}',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SummaryCardWidget(
                          icon: Icons.bolt,
                          label: 'FASTEST SERVE',
                          value: '${controller.fastestServe.value}',
                          unit: 'km/h',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  MvpCardWidget(
                    teamName: result.mvpTeamName,
                    winRate: result.mvpWinRate,
                  ),
                  SizedBox(height: 24),
                  AnalyticsCardWidget(analytics: result.analytics),
                  SizedBox(height: 24),
                  TopPlayersWidget(players: result.players),
                  SizedBox(height: 24),
                  AchievementCardWidget(achievements: result.achievements),
                  SizedBox(height: 24),
                  MatchInfoCardWidget(result: result),
                  SizedBox(height: 32),
                  ActionButtonsWidget(
                    onReturn: () => controller.returnDashboard(context),
                    onShare: controller.shareResult,
                  ),
                  SizedBox(height: 40),
                  _CertifiedBadge(),
                  SizedBox(height: 24),
                ],
              );
            }),
          ),
        ),
      ),
      bottomNavigationBar: LiveBottomNavigation(
        selectedIndex: 0,
        onTabSelected: (index) {
          Get.snackbar("Match Ended", "This match is over.", backgroundColor: AppColors.surfaceContainerHigh, colorText: AppColors.muted);
        },
      ),
    );
  }
}

class _CertifiedBadge extends StatelessWidget {
  _CertifiedBadge();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Icon(
          Icons.sports_tennis,
          size: 80,
          color: AppColors.primaryContainer.withOpacity(0.2),
        ),
        SizedBox(height: 8),
        Text(
          'CERTIFIED MATCH RESULT • ID: PB-99021',
          style: AppTypography.labelCaps10.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
