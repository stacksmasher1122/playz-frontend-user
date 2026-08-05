import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Boxing/boxing_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Boxing/widgets/boxing_fighter_card.dart';

class BoxingSetupScreen extends StatelessWidget {
  const BoxingSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.put(BoxingController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.resetSetupScreen(),
            child: Text(
              'RESET ALL',
              style: AppTypography.labelCaps.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ).responsive(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BOXING RING',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                ).responsive(context),
              ),
              const SizedBox(height: 4),
              Text(
                'Setup Boxing Match',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(30),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              const SizedBox(height: 4),
              Text(
                'Configure Pro 10-Point Must scoring, scheduled rounds count, round duration, and corner fighters.',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(15),
                  height: 1.4,
                ).responsive(context),
              ),
              const SizedBox(height: 32),

              // 1. Format Selector (Professional vs Amateur)
              _buildFormatSelector(context, controller),
              const SizedBox(height: 24),

              // 2. FIGHTER CORNERS Section Header
              Text(
                'FIGHTER CORNERS',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ).responsive(context),
              ),
              const SizedBox(height: 16),

              // Fighter A (Red Corner - Red Accent)
              BoxingFighterCard(
                cornerTitle: 'Red Corner (Fighter A)',
                nameController: controller.fighterAController,
                accentColor: const Color(0xFFFF4D4D),
                dotColor: const Color(0xFFFF4D4D),
                selectedFriend: controller.fighterAFriend,
                onSelectFriend: () => _openFriendsBottomSheet(context, controller, isFighterA: true),
              ),
              const SizedBox(height: 16),

              // Fighter B (Blue Corner - Blue Accent)
              BoxingFighterCard(
                cornerTitle: 'Blue Corner (Fighter B)',
                nameController: controller.fighterBController,
                accentColor: const Color(0xFF4D96FF),
                dotColor: const Color(0xFF4D96FF),
                selectedFriend: controller.fighterBFriend,
                onSelectFriend: () => _openFriendsBottomSheet(context, controller, isFighterA: false),
              ),
              const SizedBox(height: 32),

              // 3. Total Scheduled Rounds Stepper Card
              _buildLargeStepperCard(
                context,
                title: 'SCHEDULED ROUNDS',
                mainText: 'Rounds in Match',
                valueStream: controller.totalRounds,
                onDecrement: controller.decrementTotalRounds,
                onIncrement: controller.incrementTotalRounds,
              ),
              const SizedBox(height: 16),

              // 4. Round Duration Stepper Card
              _buildLargeStepperCard(
                context,
                title: 'ROUND DURATION',
                mainText: 'Duration of Each Round',
                valueStream: controller.roundDurationMinutes,
                onDecrement: controller.decrementRoundDuration,
                onIncrement: controller.incrementRoundDuration,
                suffix: ' MIN',
              ),
              const SizedBox(height: 16),

              // 5. Pro Rules Switch Card
              _buildRulesSwitchCard(
                context,
                valueStream: controller.isProRules,
                onChanged: controller.toggleProRules,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildStartMatchButton(context, controller),
    );
  }

  Widget _buildFormatSelector(BuildContext context, BoxingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MATCH FORMAT',
            style: AppTypography.labelCaps.copyWith(
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ).responsive(context),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildFormatChip(
                    context,
                    label: 'PRO (12 RNDS)',
                    isSelected: controller.format.value == 'PROFESSIONAL',
                    onTap: () => controller.setFormat('PROFESSIONAL'),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Expanded(
                  child: _buildFormatChip(
                    context,
                    label: 'AMATEUR (3 RNDS)',
                    isSelected: controller.format.value == 'AMATEUR',
                    onTap: () => controller.setFormat('AMATEUR'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : const Color(0xFF131313),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.headlineSm.copyWith(
              color: isSelected ? AppColors.background : AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.w900,
            ).responsive(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeStepperCard(
    BuildContext context, {
    required String title,
    required String mainText,
    required RxInt valueStream,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    String suffix = '',
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
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
              color: AppColors.mutedText,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ).responsive(context),
          ),
          const SizedBox(height: 8),
          Text(
            mainText,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(20),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleBtn(
                  context,
                  icon: Icons.remove,
                  color: const Color(0xFF131313),
                  iconColor: AppColors.accent.withValues(alpha: 0.7),
                  onTap: onDecrement,
                  size: 56,
                  iconSize: 28,
                ),
                SizedBox(width: ResponsiveHelper.w(32)),
                Obx(
                  () => Text(
                    '${valueStream.value}$suffix',
                    style: AppTypography.displayScoreSora.copyWith(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(64),
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ).responsive(context),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(32)),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: _buildCircleBtn(
                    context,
                    icon: Icons.add,
                    color: AppColors.accent,
                    iconColor: AppColors.background,
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

  Widget _buildRulesSwitchCard(
    BuildContext context, {
    required RxBool valueStream,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.w(48),
            height: ResponsiveHelper.w(48),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            child: const Icon(Icons.sports_mma, color: AppColors.accent, size: 24),
          ),
          SizedBox(width: ResponsiveHelper.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10-POINT MUST SYSTEM',
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(10),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ).responsive(context),
                ),
                const SizedBox(height: 2),
                Text(
                  'Professional Boxing Rules',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ).responsive(context),
                ),
                const SizedBox(height: 2),
                Text(
                  'Enforces 10-9 rounds, 10-8 Knockdowns & KO/TKO/DQ stoppages.',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(12),
                  ).responsive(context),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch.adaptive(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: AppColors.background,
              activeTrackColor: AppColors.accent,
              inactiveThumbColor: AppColors.mutedText,
              inactiveTrackColor: const Color(0xFF2C2C2C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    double size = 40,
    double iconSize = 20,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Ink(
          width: ResponsiveHelper.w(size),
          height: ResponsiveHelper.w(size),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: ResponsiveHelper.w(iconSize)),
        ),
      ),
    );
  }

  Widget _buildStartMatchButton(BuildContext context, BoxingController controller) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      color: AppColors.background,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          minimumSize: Size(double.infinity, ResponsiveHelper.h(56)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          ),
          elevation: 8,
          shadowColor: AppColors.accent.withValues(alpha: 0.4),
        ),
        onPressed: () => controller.startMatchFromSetup(),
        child: Text(
          'TOUCH GLOVES & START FIGHT',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.background,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ).responsive(context),
        ),
      ),
    );
  }

  void _openFriendsBottomSheet(BuildContext context, BoxingController controller, {required bool isFighterA}) {
    final FriendsController friendsCtrl = Get.put(FriendsController());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardSurface,
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
                    'Select Fighter (${isFighterA ? "Red Corner" : "Blue Corner"})',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
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
                    return const Center(child: CircularProgressIndicator(color: AppColors.accent));
                  }

                  return ListView.builder(
                    itemCount: allSelectable.length,
                    itemBuilder: (c, idx) {
                      final friend = allSelectable[idx];

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
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                        subtitle: Text(
                          friend.email,
                          style: AppTypography.bodySm.copyWith(color: AppColors.mutedText, fontSize: 11).responsive(context),
                        ),
                        onTap: () {
                          if (isFighterA) {
                            controller.fighterAFriend.value = friend;
                            controller.fighterAController.text = friend.fullName.isNotEmpty ? friend.fullName : friend.email;
                          } else {
                            controller.fighterBFriend.value = friend;
                            controller.fighterBController.text = friend.fullName.isNotEmpty ? friend.fullName : friend.email;
                          }
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
