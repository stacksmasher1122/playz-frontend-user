import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';

// Internal Imports
import 'widgets/stepper_card.dart';
import 'widgets/switch_card.dart';
import 'widgets/rules_switch_card.dart';
import 'widgets/team_card.dart';
import 'widgets/large_stepper_card.dart';
import 'widgets/start_match_button.dart';

// Theme Constants matching the UI
const Color kBg = Color(0xFF161616);
const Color kSurface = Color(0xFF1E1E1E);
const Color kGreen = Color(0xFF56F174);
const Color kMutedText = Color(0xFFA0A0A0);
const Color kRed = Color(0xFFFF6B6B);
const Color kBlue = Color(0xFF4D96FF);

class FriendlySetupScreen extends StatelessWidget {
  FriendlySetupScreen({super.key});

  final CricketController controller = Get.put(CricketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MATCH ARENA',
          style: TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Setup Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Configure your arena rules and draft your\nsquads.',
                style: TextStyle(color: kMutedText, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 32),

              // Squad Limit Card
              StepperCard(
                title: 'SQUAD LIMIT',
                mainText: 'Players per\nTeam',
                valueStream: controller.squadLimit,
                onDecrement: controller.decrementSquadLimit,
                onIncrement: controller.incrementSquadLimit,
              ),
              const SizedBox(height: 16),

              // Substitute Players Card
              SwitchCard(
                valueStream: controller.subsEnabled,
                onChanged: controller.toggleSubs,
                title: 'Substitute Players',
                subtitle: 'Enable mid-match\nrotations',
                icon: Icons.swap_horiz_rounded,
              ),
              const SizedBox(height: 16),

              // Reserves Card
              Obx(
                () => controller.subsEnabled.value
                    ? Column(
                        children: [
                          StepperCard(
                            title: 'RESERVES',
                            titleColor: kGreen,
                            mainText: 'Max\nSubstitutes',
                            valueStream: controller.maxSubstitutes,
                            onDecrement: controller.decrementSubs,
                            onIncrement: controller.incrementSubs,
                          ),
                          const SizedBox(height: 32),
                        ],
                      )
                    : const SizedBox(height: 16),
              ),

              const Text(
                'BATTLE ROSTERS',
                style: TextStyle(
                  color: kMutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Home Team Card
              TeamCard(
                context: context,
                controller: controller,
                titleStream: controller.homeTeamName,
                dotColor: kRed,
                accentColor: kRed.withValues(alpha: 0.8),
                textController: controller.homeTeamController,
                isHome: true,
              ),
              const SizedBox(height: 16),

              // Away Team Card
              TeamCard(
                context: context,
                controller: controller,
                titleStream: controller.awayTeamName,
                dotColor: kBlue,
                accentColor: kBlue.withValues(alpha: 0.8),
                textController: controller.awayTeamController,
                isHome: false,
              ),
              const SizedBox(height: 32),

              // Match Length Card
              LargeStepperCard(controller: controller),
              const SizedBox(height: 16),

              // Match Rules Card
              RulesSwitchCard(
                valueStream: controller.isFormalRules,
                onChanged: controller.toggleFormalRules,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StartMatchButton(controller: controller),
    );
  }
}
