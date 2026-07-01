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

class FootballCreateMatchScreen extends StatefulWidget {
  const FootballCreateMatchScreen({super.key});

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
      duration: const Duration(milliseconds: 600),
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
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: const FootballCreateMatchAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
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
                const GeneralInformationCard(),
                const TeamSelectionCard(),
                const LogisticsCard(),
                const MatchFormatCard(),
                const RulesConfigurationCard(),
                BottomActionWidget(
                  onCreate: () {
                    if (controller.validateForm()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StartingLineupScreen()),
                      );
                    }
                  },
                  onSaveTemplate: controller.saveAsTemplate,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Match',
            style: TextStyle(
              color: Color(0xFFC6FF00), // Lime Green
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Configure a new professional match session for real-time scouting and analytics.',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
