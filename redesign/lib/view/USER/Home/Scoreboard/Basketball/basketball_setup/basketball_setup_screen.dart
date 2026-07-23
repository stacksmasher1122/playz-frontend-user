import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'widgets/basketball_team_card.dart';
import 'widgets/basketball_friends_sheet.dart';
import '../tip_off/tip_off_screen.dart';

class BasketballSetupScreen extends StatelessWidget {
  BasketballSetupScreen({super.key});

  final BasketballController controller = Get.put(BasketballController());
  final FriendsController friendsController = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Basketball Setup', style: AppTypography.headlineLg.copyWith(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Match Mode Toggle
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMd),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Professional Mode', style: AppTypography.headlineSm),
                          const SizedBox(height: AppDimensions.paddingXs),
                          Text('Enables technical/flagrant fouls and ejections. Sets NBA defaults (12 min, 6 fouls).',
                              style: AppTypography.bodySm.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isProfessionalMode.value,
                      onChanged: controller.toggleMode,
                      activeColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLg),

              // Configuration
              Text('Match Settings', style: AppTypography.headlineLgMobile),
              const SizedBox(height: AppDimensions.paddingMd),

              _buildConfigRow('Quarter Length (min)', controller.quarterLengthMinutes.value, (val) => controller.updateQuarterLength(val), min: 5, max: 20),
              _buildConfigRow('Shot Clock (sec)', controller.shotClockSeconds.value, (val) => controller.updateShotClock(val), min: 14, max: 45),
              _buildConfigRow('Foul Out Limit', controller.foulOutLimit.value, (val) => controller.updateFoulOutLimit(val), min: 4, max: 8),
              _buildConfigRow('Timeouts per Team', controller.timeoutsPerTeam.value, (val) => controller.updateTimeouts(val), min: 2, max: 10),

              const SizedBox(height: AppDimensions.paddingLg),

              // Team A
              BasketballTeamCard(
                textController: controller.homeTeamController,
                isHome: true,
                selectedPlayers: controller.homeTeamRoster,
                onAddPlayer: () => _showFriendsSheet(context, true),
                onRemovePlayer: (friend) => controller.removePlayerFromHomeTeam(friend),
              ),
              const SizedBox(height: AppDimensions.paddingLg),

              // Team B
              BasketballTeamCard(
                textController: controller.awayTeamController,
                isHome: false,
                selectedPlayers: controller.awayTeamRoster,
                onAddPlayer: () => _showFriendsSheet(context, false),
                onRemovePlayer: (friend) => controller.removePlayerFromAwayTeam(friend),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: ElevatedButton(
            onPressed: () async {
              if (controller.homeTeamRoster.isEmpty || controller.awayTeamRoster.isEmpty) {
                Get.snackbar('Teams Required', 'Please add at least one player to both teams.');
                return;
              }
              await controller.createMatch();
              Get.to(() => const TipOffScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMd),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
            ),
            child: Text('Proceed to Tip-Off', style: AppTypography.labelCaps),
          ),
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, int value, Function(int) onChanged, {int min = 1, int max = 100}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyLg),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              SizedBox(
                width: 40,
                child: Text('$value', textAlign: TextAlign.center, style: AppTypography.headlineMd.copyWith(fontFamily: 'JetBrains Mono')),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFriendsSheet(BuildContext context, bool isHomeTeam) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: BasketballFriendsSelectionSheet(
          friends: friendsController.friends,
          onPlayerSelected: (friend) {
            if (isHomeTeam) {
              controller.addPlayerToHomeTeam(friend);
            } else {
              controller.addPlayerToAwayTeam(friend);
            }
          },
        ),
      ),
    );
  }
}
