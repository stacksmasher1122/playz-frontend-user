import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/live_football_dashboard_controller.dart';
import 'widgets/live_dashboard_appbar.dart';
import 'widgets/live_score_card.dart';
import 'widgets/possession_card_widget.dart';
import 'widgets/statistics_progress_card.dart';
import 'widgets/quick_event_grid_widget.dart';
import 'widgets/stats_summary_grid.dart';
import 'widgets/bottom_navigation_widget.dart';

class LiveFootballDashboardScreen extends StatefulWidget {
  const LiveFootballDashboardScreen({super.key});

  @override
  State<LiveFootballDashboardScreen> createState() => _LiveFootballDashboardScreenState();
}

class _LiveFootballDashboardScreenState extends State<LiveFootballDashboardScreen> with TickerProviderStateMixin {
  late final LiveFootballDashboardController controller;
  
  late final AnimationController _entranceAnimController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LiveFootballDashboardController());
    controller.initialize();

    _entranceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceAnimController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceAnimController, curve: Curves.easeOutCubic),
    );

    _entranceAnimController.forward();
  }

  @override
  void dispose() {
    _entranceAnimController.dispose();
    Get.delete<LiveFootballDashboardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const LiveDashboardAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFC6FF00), // Lime Green
            ),
          );
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LiveScoreCard(),
                  const PossessionCardWidget(),
                  Obx(() {
                    return StatisticsProgressCard(
                      title: 'Shots on Target',
                      valueA: controller.shotsOnTargetA.value,
                      valueB: controller.shotsOnTargetB.value,
                    );
                  }),
                  const QuickEventGridWidget(),
                  const StatsSummaryGrid(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }
}
