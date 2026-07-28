import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/More_Controller/reward_center_controller.dart';
import 'package:redesign/model/User_Models/More_Models/reward_center_model.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'widgets/reward_center_header.dart';
import 'widgets/referral_share_card.dart';
import 'widgets/reward_item_card.dart';
import 'widgets/earn_coins_section.dart';

class RewardCenterScreen extends StatefulWidget {
  const RewardCenterScreen({super.key});

  @override
  State<RewardCenterScreen> createState() => _RewardCenterScreenState();
}

class _RewardCenterScreenState extends State<RewardCenterScreen> {
  late final RewardCenterController controller;
  late final UserProfileController userProfileController;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<RewardCenterController>()
        ? Get.find<RewardCenterController>()
        : Get.put(RewardCenterController());
    userProfileController = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());
  }

  void _showRedeemDialog(BuildContext context, RewardItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.card_giftcard_rounded, color: Color(0xFF00E676), size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Redeem Reward',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text('Cost:', style: GoogleFonts.inter(color: Colors.white54, fontSize: 13)),
                  const Spacer(),
                  const Icon(Icons.monetization_on_rounded, color: Colors.amberAccent, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${item.coinCost} Z-Coins',
                    style: GoogleFonts.inter(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final success = controller.redeemReward(item.id);
              if (success) {
                _showSuccessModal(context, item);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Insufficient Z-Coins balance! Invite friends to earn more.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Confirm & Redeem',
              style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessModal(BuildContext context, RewardItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF00E676),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.black, size: 36),
            ),
            const SizedBox(height: 12),
            Text(
              'Reward Unlocked!',
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Use this promo code at checkout:',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00E676)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.discountCode,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF00E676),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: Colors.white, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: item.discountCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Promo code copied!'),
                          backgroundColor: Color(0xFF00E676),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Done', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rewards Center',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A2D24),
              Color(0xFF121E18),
              Color(0xFF121212),
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              Obx(() => RewardCenterHeader(coinsBalance: controller.userCoins.value)),
              Obx(() => ReferralShareCard(code: userProfileController.referralCode)),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  'REDEEM EXCLUSIVE REWARDS',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF00E676),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              /// CATEGORY CHIPS
              SizedBox(
                height: 40,
                child: Obx(() {
                  final selCat = controller.selectedCategory.value;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final cat = controller.categories[index];
                      final isSelected = cat == selCat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF00E676),
                          backgroundColor: const Color(0xFF1E1E1E),
                          labelStyle: GoogleFonts.inter(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF00E676) : Colors.white10,
                            ),
                          ),
                          onSelected: (_) => controller.selectedCategory.value = cat,
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 10),

              Obx(() {
                final rewards = controller.filteredRewards;
                return Column(
                  children: rewards.map((r) {
                    return RewardItemCard(
                      item: r,
                      onRedeem: () => _showRedeemDialog(context, r),
                    );
                  }).toList(),
                );
              }),

              EarnCoinsSection(
                tasks: controller.earnTasks,
                onInviteTap: () {
                  Clipboard.setData(ClipboardData(text: 'Join me on PlayZ using code ${controller.referralCode.value} for 500 Z-Coins!'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Referral invite link copied to clipboard!'),
                      backgroundColor: Color(0xFF00E676),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
