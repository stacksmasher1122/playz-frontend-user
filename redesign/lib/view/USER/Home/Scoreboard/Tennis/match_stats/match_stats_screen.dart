import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';
import 'widgets/ms_appbar_widget.dart';
import 'widgets/ms_hero_header_widget.dart';
import 'widgets/ms_match_stats_bars_widget.dart';
import 'widgets/ms_momentum_graph_widget.dart';
import 'widgets/ms_set_breakdown_widget.dart';
import 'widgets/ms_player_of_match_widget.dart';
import 'widgets/ms_bottom_nav_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchStatsScreen extends StatefulWidget {
  MatchStatsScreen({super.key});

  @override
  State<MatchStatsScreen> createState() => _MatchStatsScreenState();
}

class _MatchStatsScreenState extends State<MatchStatsScreen> {
  late final MatchStatsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MatchStatsController());
  }

  @override
  void dispose() {
    Get.delete<MatchStatsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            MsAppbarWidget(),
            
            Expanded(
              child: Obx(() {
                if (controller.stats.value == null) {
                  return Center(child: CircularProgressIndicator(color: AppColors.accent));
                }
                
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(16.0)),
                  child: Column(
                    children: [
                      MsHeroHeaderWidget(),
                      SizedBox(height: 24),
                      
                      MsMatchStatsBarsWidget(),
                      SizedBox(height: 24),
                      
                      MsMomentumGraphWidget(),
                      SizedBox(height: 24),
                      
                      MsSetBreakdownWidget(),
                      SizedBox(height: 24),
                      
                      MsPlayerOfMatchWidget(),
                      
                      SizedBox(height: 120),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MsBottomNavWidget(),
    );
  }
}
