import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'widgets/football_create_match_appbar.dart';
import 'widgets/general_information_card.dart';
import 'widgets/team_selection_card.dart';
import 'widgets/logistics_card.dart';
import 'widgets/match_format_card.dart';
import 'widgets/rules_configuration_card.dart';
import 'widgets/bottom_action_widget.dart';
import '../starting_lineup/starting_lineup_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballCreateMatchScreen extends StatefulWidget {
  FootballCreateMatchScreen({super.key});

  @override
  State<FootballCreateMatchScreen> createState() => _FootballCreateMatchScreenState();
}

class _FootballCreateMatchScreenState extends State<FootballCreateMatchScreen> with SingleTickerProviderStateMixin {
  late final FootballCreateMatchController controller;
  late final AnimationController _animController;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FootballCreateMatchController());
    controller.loadInitialData();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    Get.delete<FootballCreateMatchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: FootballCreateMatchAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFFC6FF00), // Lime Green
            ),
          );
        }

        return FadeTransition(
          opacity: _opacity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                GeneralInformationCard(),
                TeamSelectionCard(),
                LogisticsCard(),
                MatchFormatCard(),
                RulesConfigurationCard(),
                BottomActionWidget(
                  onCreate: () {
                    if (controller.validateForm()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StartingLineupScreen()),
                      );
                    }
                  },
                  onSaveTemplate: controller.saveAsTemplate,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Match',
            style: TextStyle(
              color: Color(0xFFC6FF00), // Lime Green
              fontSize: ResponsiveHelper.sp(28),
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Configure a new professional match session for real-time scouting and analytics.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: ResponsiveHelper.sp(14),
              height: ResponsiveHelper.h(1.4),
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
