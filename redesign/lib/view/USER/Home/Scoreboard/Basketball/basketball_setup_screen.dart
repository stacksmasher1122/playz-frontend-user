import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Basketball/widgets/basketball_team_card.dart';

Color kBg = const Color(0xFF161616);
Color kSurface = const Color(0xFF1E1E1E);
Color kGreen = const Color(0xFF56F174);
Color kMutedText = const Color(0xFFA0A0A0);
Color kRed = const Color(0xFFFF6B6B);
Color kBlue = const Color(0xFF4D96FF);

class BasketballSetupScreen extends StatelessWidget {
  const BasketballSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<BasketballController>()
        ? Get.find<BasketballController>()
        : Get.put(BasketballController());

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
          'MATCH ARENA',
          style: AppTypography.headlineMd.copyWith(
            color: kGreen,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: kGreen),
            onPressed: () => controller.resetSetupScreen(),
          ),
        ],
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
                'Setup Basketball Match',
                style: AppTypography.headlineXl.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(30),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure your court rules and draft your\nsquads.',
                style: AppTypography.bodyMd.copyWith(
                  color: kMutedText,
                  fontSize: ResponsiveHelper.sp(15),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // 1. Squad Limit Card (Cricket StepperCard Style)
              _buildStepperCard(
                title: 'SQUAD LIMIT',
                mainText: 'Players per\nTeam',
                valueStream: controller.squadLimit,
                onDecrement: controller.decrementSquadLimit,
                onIncrement: controller.incrementSquadLimit,
              ),
              const SizedBox(height: 16),

              // 2. Substitute Players Switch Card (Cricket Style)
              _buildSwitchCard(
                valueStream: controller.subsEnabled,
                onChanged: controller.toggleSubs,
                title: 'Substitute Players',
                subtitle: 'Enable mid-match\nrotations',
                icon: Icons.swap_horiz_rounded,
              ),
              const SizedBox(height: 16),

              // 3. Reserves Stepper Card (Cricket Style)
              Obx(
                () => controller.subsEnabled.value
                    ? Column(
                        children: [
                          _buildStepperCard(
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

              // 4. BATTLE ROSTERS Section Header
              Text(
                'BATTLE ROSTERS',
                style: AppTypography.labelCaps.copyWith(
                  color: kMutedText,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Home Team Card (Side A - Red Accent)
              BasketballTeamCard(
                teamTitle: 'Side A (Home)',
                nameController: controller.homeTeamController,
                accentColor: kRed.withValues(alpha: 0.8),
                dotColor: kRed,
                roster: controller.teamARoster,
                maxPlayers: controller.maxAllowedPlayers,
                onAddPlayer: () => _openFriendsBottomSheet(context, controller, isTeamA: true),
                onRemovePlayer: (player) => controller.removeTeamPlayer(true, player),
              ),
              const SizedBox(height: 16),

              // Away Team Card (Side B - Blue Accent)
              BasketballTeamCard(
                teamTitle: 'Side B (Away)',
                nameController: controller.awayTeamController,
                accentColor: kBlue.withValues(alpha: 0.8),
                dotColor: kBlue,
                roster: controller.teamBRoster,
                maxPlayers: controller.maxAllowedPlayers,
                onAddPlayer: () => _openFriendsBottomSheet(context, controller, isTeamA: false),
                onRemovePlayer: (player) => controller.removeTeamPlayer(false, player),
              ),
              const SizedBox(height: 32),

              // 5. Match Length Large Stepper Card (Cricket LargeStepperCard Style)
              _buildLargeStepperCard(
                title: 'MATCH LENGTH',
                mainText: 'Minutes per Quarter',
                valueStream: controller.quarterDurationMinutes,
                onDecrement: () {
                  if (controller.quarterDurationMinutes.value > 1) {
                    controller.setQuarterDuration(controller.quarterDurationMinutes.value - 1);
                  }
                },
                onIncrement: () {
                  if (controller.quarterDurationMinutes.value < 20) {
                    controller.setQuarterDuration(controller.quarterDurationMinutes.value + 1);
                  }
                },
              ),
              const SizedBox(height: 16),

              // 6. Pro Rules Switch Card (Cricket RulesSwitchCard Style)
              _buildRulesSwitchCard(
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
              ),
              const SizedBox(height: 16),

              // Optional 24s Shot Clock Toggle for Friendly Mode
              Obx(() => !controller.isProRules.value
                  ? Column(
                      children: [
                        _buildSwitchCard(
                          valueStream: controller.enableShotClock,
                          onChanged: controller.toggleShotClock,
                          title: '24-Second Shot Clock',
                          subtitle: 'Enable or disable official 24s timer',
                          icon: Icons.timer,
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildStartMatchButton(context, controller),
    );
  }

  // StepperCard widget matching Cricket setup
  Widget _buildStepperCard({
    required String title,
    required String mainText,
    required RxInt valueStream,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    Color? titleColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelCaps.copyWith(
                    color: titleColor ?? kMutedText,
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mainText,
                  style: AppTypography.headlineSm.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(6),
              vertical: ResponsiveHelper.h(6),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            ),
            child: Row(
              children: [
                _buildCircleBtn(
                  icon: Icons.remove,
                  color: const Color(0xFF2C2C2C),
                  iconColor: kGreen,
                  onTap: onDecrement,
                ),
                SizedBox(width: ResponsiveHelper.w(16)),
                Obx(
                  () => Text(
                    valueStream.value.toString(),
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(16)),
                _buildCircleBtn(
                  icon: Icons.add,
                  color: kGreen,
                  iconColor: Colors.black,
                  onTap: onIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SwitchCard widget matching Cricket setup
  Widget _buildSwitchCard({
    required RxBool valueStream,
    required Function(bool) onChanged,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: const Color(0xFF26332A),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            child: Icon(icon, color: kGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineSm.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: kMutedText,
                    fontSize: ResponsiveHelper.sp(13),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: Colors.black,
              activeTrackColor: kGreen,
              inactiveThumbColor: kMutedText,
              inactiveTrackColor: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }

  // LargeStepperCard widget matching Cricket setup
  Widget _buildLargeStepperCard({
    required String title,
    required String mainText,
    required RxInt valueStream,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.h(24),
        horizontal: ResponsiveHelper.w(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTypography.labelCaps.copyWith(
              color: kMutedText,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mainText,
            style: AppTypography.headlineSm.copyWith(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleBtn(
                  icon: Icons.remove,
                  color: const Color(0xFF131313),
                  iconColor: kGreen.withValues(alpha: 0.7),
                  onTap: onDecrement,
                  size: 56,
                  iconSize: 28,
                ),
                SizedBox(width: ResponsiveHelper.w(32)),
                Obx(
                  () => Text(
                    valueStream.value.toString(),
                    style: AppTypography.displayScoreSora.copyWith(
                      color: kGreen,
                      fontSize: ResponsiveHelper.sp(64),
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(32)),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kGreen.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: _buildCircleBtn(
                    icon: Icons.add,
                    color: kGreen,
                    iconColor: Colors.black,
                    onTap: onIncrement,
                    size: 56,
                    iconSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // RulesSwitchCard widget matching Cricket setup
  Widget _buildRulesSwitchCard({
    required RxBool valueStream,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: const Color(0xFF3B2828),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            child: Icon(Icons.gavel_rounded, color: kRed, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Formal FIBA Pro Rules',
                  style: AppTypography.headlineSm.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enforces 24s Shot Clock & 10-Min Quarters',
                  style: AppTypography.bodySm.copyWith(
                    color: kMutedText,
                    fontSize: ResponsiveHelper.sp(13),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: Colors.black,
              activeTrackColor: kRed,
              inactiveThumbColor: kMutedText,
              inactiveTrackColor: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    double size = 44,
    double iconSize = 20,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: ResponsiveHelper.w(size),
        height: ResponsiveHelper.h(size),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }

  Widget _buildStartMatchButton(BuildContext context, BasketballController controller) {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveHelper.w(20),
        right: ResponsiveHelper.w(20),
        bottom: ResponsiveHelper.h(30),
        top: 10,
      ),
      color: kBg,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.proceedToJumpBall(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            foregroundColor: Colors.black,
            disabledBackgroundColor: kGreen.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(20)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: ResponsiveHelper.w(24),
                  height: ResponsiveHelper.h(24),
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PROCEED TO JUMP BALL',
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.sports_basketball_rounded, size: 20),
                  ],
                ),
        ),
      ),
    );
  }

  void _openFriendsBottomSheet(BuildContext context, BasketballController controller, {required bool isTeamA}) {
    final FriendsController friendsCtrl = Get.put(FriendsController());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(20)),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Players (${isTeamA ? "Side A" : "Side B"})',
                    style: AppTypography.headlineSm.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  final user = FirebaseAuth.instance.currentUser;
                  final userName = user?.displayName ?? 'You';
                  final userEmail = user?.email ?? 'you@local';

                  final currentUserFriend = FriendModel(
                    email: userEmail,
                    fullName: '$userName (You)',
                  );

                  List<FriendModel> allSelectable = [currentUserFriend];
                  allSelectable.addAll(friendsCtrl.friends.where((f) => f.email != userEmail));

                  if (friendsCtrl.isLoading.value && friendsCtrl.friends.isEmpty) {
                    return Center(child: CircularProgressIndicator(color: kGreen));
                  }

                  return ListView.builder(
                    itemCount: allSelectable.length,
                    itemBuilder: (c, idx) {
                      final friend = allSelectable[idx];
                      final isSelected = controller.teamAPlayers.contains(friend.email) ||
                          controller.teamBPlayers.contains(friend.email);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[800],
                          backgroundImage: friend.profileImageUrl.isNotEmpty
                              ? NetworkImage(friend.profileImageUrl)
                              : null,
                          child: friend.profileImageUrl.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        title: Text(
                          friend.fullName.isNotEmpty ? friend.fullName : friend.email,
                          style: AppTypography.bodyMd.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          friend.email,
                          style: AppTypography.bodySm.copyWith(color: kMutedText, fontSize: 11),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: kGreen)
                            : const Icon(Icons.add_circle_outline, color: Colors.white38),
                        onTap: isSelected
                            ? null
                            : () {
                                controller.addTeamPlayer(isTeamA, friend);
                                Navigator.pop(ctx);
                              },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
