import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_controller.dart';
import '../../../../../../score_engine/footballMatchEngine/football_match_engine.dart';
import '../../../../../../theme/app_colors.dart';
import '../../../../../../theme/responsive_helper.dart';

// Internal Imports
import 'widgets/scoreboard_header.dart';
import 'widgets/event_feed.dart';
import 'widgets/scoreboard_controls.dart';
import 'widgets/goal_workflow.dart';
import 'widgets/card_workflow.dart';
import 'widgets/sub_workflow.dart';
import 'widgets/professional_rules_workflow.dart';

class FootballScoreboardScreen extends StatefulWidget {
  final MatchTeam? homeTeam;
  final MatchTeam? awayTeam;
  final int? durationMinutes;

  FootballScoreboardScreen({
    super.key,
    this.homeTeam,
    this.awayTeam,
    this.durationMinutes,
  });

  @override
  State<FootballScoreboardScreen> createState() =>
      _FootballScoreboardScreenState();
}

class _FootballScoreboardScreenState extends State<FootballScoreboardScreen> {
  final ScrollController _scrollController = ScrollController();

  FootballController get controller => Get.find<FootballController>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller.engine,
          builder: (context, _) {
            return Column(
              children: [
                ScoreboardHeader(engine: controller.engine),
                Container(
                  height: ResponsiveHelper.h(1),
                  color: AppColors.outlineVariant,
                ),
                Expanded(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [EventFeed(engine: controller.engine)],
                  ),
                ),
                ScoreboardControls(
                  engine: controller.engine,
                  showGoalModal: _showGoalModal,
                  showCardModal: _showCardModal,
                  showSubModal: _showSubModal,
                  showRulesModal: _showRulesModal,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showGoalModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GoalWorkflow(engine: controller.engine),
    );
  }

  void _showCardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CardWorkflow(engine: controller.engine),
    );
  }

  void _showSubModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SubWorkflow(engine: controller.engine),
    );
  }

  void _showRulesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ProfessionalRulesWorkflow(engine: controller.engine),
    );
  }
}
