import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';

import 'widgets/live_match_header_widget.dart';
import 'widgets/team_comparison_card.dart';
import 'widgets/match_momentum_card.dart';

import 'widgets/bottom_summary_widget.dart';
import 'widgets/loading_widget.dart';
import '../live_dashboard/widgets/bottom_navigation_widget.dart';

class FootballMatchStatisticsScreen extends StatefulWidget {
  FootballMatchStatisticsScreen({super.key});

  @override
  State<FootballMatchStatisticsScreen> createState() =>
      _FootballMatchStatisticsScreenState();
}

class _FootballMatchStatisticsScreenState
    extends State<FootballMatchStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late final FootballMatchStatisticsController controller;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FootballMatchStatisticsController());
    controller.initialize();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
    _slideAnim = Tween<Offset>(
      begin: Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    Get.delete<FootballMatchStatisticsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: StatisticsAppbar(),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: RefreshIndicator(
                color: Color(0xFFC6FF00),
                backgroundColor: Colors.black,
                onRefresh: () async {
                  controller.refreshStatistics();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: ResponsiveHelper.h(24)),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      LiveMatchHeaderWidget(),
                      TeamComparisonCard(),
                      MatchMomentumCard(),
                      PlayerAnalyticsCard(),
                      BottomSummaryWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return LoadingWidget();
            }
            return SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(currentScreen: 'stats'),
    );
  }
}

class StatisticsAppbar extends StatelessWidget implements PreferredSizeWidget {
  StatisticsAppbar({super.key});
  @override
  Widget build(BuildContext context) => AppBar();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class PlayerAnalyticsCard extends StatelessWidget {
  PlayerAnalyticsCard({super.key});
  @override
  Widget build(BuildContext context) => SizedBox();
}
