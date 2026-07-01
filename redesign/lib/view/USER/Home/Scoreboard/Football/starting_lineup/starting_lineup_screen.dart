import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/starting_lineup_controller.dart';
import 'widgets/starting_lineup_appbar.dart';
import 'widgets/tactic_header_widget.dart';
import 'widgets/formation_selector_widget.dart';
import 'widgets/football_pitch_widget.dart';
import 'widgets/squad_header_widget.dart';
import 'widgets/squad_list_widget.dart';
import 'widgets/confirm_squad_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StartingLineupScreen extends StatefulWidget {
  StartingLineupScreen({super.key});

  @override
  State<StartingLineupScreen> createState() => _StartingLineupScreenState();
}

class _StartingLineupScreenState extends State<StartingLineupScreen> with SingleTickerProviderStateMixin {
  late final StartingLineupController controller;
  late final AnimationController _animController;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StartingLineupController());
    controller.initialize();

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
    Get.delete<StartingLineupController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: StartingLineupAppbar(),
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
                TacticHeaderWidget(),
                FormationSelectorWidget(),
                FootballPitchWidget(),
                SquadHeaderWidget(
                  onFilter: () => controller.filterPlayers(''),
                  onSearch: () => controller.searchPlayers(''),
                ),
                SquadListWidget(),
                SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: ConfirmSquadButtonWidget(
        onTap: () => controller.confirmSquad(context),
      ),
    );
  }
}
