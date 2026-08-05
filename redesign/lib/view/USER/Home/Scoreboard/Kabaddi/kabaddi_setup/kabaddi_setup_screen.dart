import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Kabaddi/kabaddi_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/stepper_card.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/switch_card.dart';
import 'widgets/kabaddi_team_card.dart';

Color kBg = const Color(0xFF161616);
Color kGreen = const Color(0xFF56F174);
Color kMutedText = const Color(0xFFA0A0A0);
Color kRed = const Color(0xFFFF6B6B);
Color kBlue = const Color(0xFF4D96FF);

class KabaddiSetupScreen extends StatelessWidget {
  KabaddiSetupScreen({super.key});

  final KabaddiController controller = Get.isRegistered<KabaddiController>()
      ? Get.find<KabaddiController>()
      : Get.put(KabaddiController());

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'KABADDI ARENA',
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
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setup Match',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(32),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure your Kabaddi arena rules and draft your\nsquads.',
                style: TextStyle(color: kMutedText, fontSize: ResponsiveHelper.sp(15), height: 1.4),
              ),
              const SizedBox(height: 32),

              // 1. Squad Limit Card
              StepperCard(
                title: 'SQUAD LIMIT',
                mainText: 'Players per\nTeam',
                valueStream: controller.squadLimit,
                onDecrement: controller.decrementSquadLimit,
                onIncrement: controller.incrementSquadLimit,
              ),
              const SizedBox(height: 16),

              // 2. Substitute Players Card
              SwitchCard(
                valueStream: controller.subsEnabled,
                onChanged: controller.toggleSubs,
                title: 'Substitute Players',
                subtitle: 'Enable mid-match\nrotations',
                icon: Icons.swap_horiz_rounded,
              ),
              const SizedBox(height: 16),

              // 3. Reserves Card
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

              Text(
                'BATTLE ROSTERS',
                style: TextStyle(
                  color: kMutedText,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // 4. Home Team Card (Side A)
              KabaddiTeamCard(
                context: context,
                controller: controller,
                titleStream: controller.homeTeamName,
                dotColor: kRed,
                accentColor: kRed.withValues(alpha: 0.8),
                textController: controller.homeTeamController,
                isHome: true,
              ),
              const SizedBox(height: 16),

              // 5. Away Team Card (Side B)
              KabaddiTeamCard(
                context: context,
                controller: controller,
                titleStream: controller.awayTeamName,
                dotColor: kBlue,
                accentColor: kBlue.withValues(alpha: 0.8),
                textController: controller.awayTeamController,
                isHome: false,
              ),
              const SizedBox(height: 32),

              // 6. Half Duration Stepper Card
              StepperCard(
                title: 'HALF DURATION',
                mainText: 'Minutes per\nHalf',
                valueStream: controller.halfDurationMinutes,
                onIncrement: () => controller.setHalfDuration(controller.halfDurationMinutes.value + 5),
                onDecrement: () {
                  if (controller.halfDurationMinutes.value > 5) {
                    controller.setHalfDuration(controller.halfDurationMinutes.value - 5);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 7. Pro Rules Switch Card
              SwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
                title: 'Pro Rules Mode',
                subtitle: 'Enables 30s Raid Clock,\nDo-or-Die & Super Tackle',
                icon: Icons.gavel,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: kBg,
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              ),
            ),
            onPressed: () => controller.goToToss(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_kabaddi, color: Colors.black, size: 22),
                const SizedBox(width: 8),
                Text(
                  'PROCEED TO COIN TOSS',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
