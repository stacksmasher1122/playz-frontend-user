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

class MatchStatsScreen extends StatefulWidget {
  const MatchStatsScreen({super.key});

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const MsAppbarWidget(),
            
            Expanded(
              child: Obx(() {
                if (controller.stats.value == null) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryContainer));
                }
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    children: [
                      const MsHeroHeaderWidget(),
                      const SizedBox(height: 24),
                      
                      const MsMatchStatsBarsWidget(),
                      const SizedBox(height: 24),
                      
                      const MsMomentumGraphWidget(),
                      const SizedBox(height: 24),
                      
                      const MsSetBreakdownWidget(),
                      const SizedBox(height: 24),
                      
                      const MsPlayerOfMatchWidget(),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MsBottomNavWidget(),
    );
  }
}
