import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import 'widgets/pm_header_widget.dart';
import 'widgets/pm_player_a_card_widget.dart';
import 'widgets/pm_player_b_card_widget.dart';
import 'widgets/pm_suggested_players_widget.dart';
import 'widgets/pm_confirm_button_widget.dart';
import '../setup_match/widgets/sm_appbar_widget.dart';
import '../setup_match/widgets/sm_bottom_nav_widget.dart';

class PlayerManagementScreen extends StatefulWidget {
  const PlayerManagementScreen({super.key});

  @override
  State<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends State<PlayerManagementScreen> {
  late final PlayerManagementController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PlayerManagementController());
  }

  @override
  void dispose() {
    Get.delete<PlayerManagementController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SmAppbarWidget(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PmHeaderWidget(),
                    const SizedBox(height: 32),
                    
                    const PmPlayerACardWidget(),
                    const SizedBox(height: 32),
                    
                    const PmPlayerBCardWidget(),
                    const SizedBox(height: 24),
                    
                    const PmSuggestedPlayersWidget(),
                    const SizedBox(height: 32),
                    
                    const PmConfirmButtonWidget(),
                    const SizedBox(height: 48), // Padding for scroll
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SmBottomNavWidget(),
    );
  }
}
