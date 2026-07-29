import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
        ),
        title: Row(
          children: [
            const Icon(Icons.card_giftcard_rounded, color: AppColors.accent, size: 28),
            SizedBox(width: context.widthPct(2.5)),
            Expanded(
              child: Text(
                'Redeem Reward',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(18),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(15),
              ),
            ),
            SizedBox(height: context.heightPct(0.5)),
            Text(
              item.subtitle,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
            SizedBox(height: context.heightPct(2)),
            Container(
              padding: EdgeInsets.all(context.widthPct(3)),
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              ),
              child: Row(
                children: [
                  Text(
                    'Cost:',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.monetization_on_rounded, color: AppColors.coinsGold, size: 16),
                  SizedBox(width: context.widthPct(1)),
                  Text(
                    '${item.coinCost} Z-Coins',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.coinsGold,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
            ),
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
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              ),
            ),
            child: Text(
              'Confirm & Redeem',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
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
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.all(context.widthPct(4)),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: AppColors.background, size: 36),
            ),
            SizedBox(height: context.heightPct(1.5)),
            Text(
              'Reward Unlocked!',
              style: AppTypography.displayLg.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(20),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Use this promo code at checkout:',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
            ),
            SizedBox(height: context.heightPct(1.5)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4),
                vertical: context.heightPct(1.5),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                border: Border.all(color: AppColors.accent),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.discountCode,
                    style: AppTypography.displayLg.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(18),
                      letterSpacing: 2.0,
                    ),
                  ),
                  SizedBox(width: context.widthPct(2.5)),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, color: AppColors.textPrimary, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: item.discountCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Promo code copied!'),
                          backgroundColor: AppColors.accent,
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
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(8),
                  vertical: context.heightPct(1.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
              ),
              child: Text(
                'Done',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
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
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rewards Center',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(18),
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
              AppColors.background,
            ],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(bottom: context.heightPct(5)),
            children: [
              Obx(() => RewardCenterHeader(coinsBalance: controller.userCoins.value)),
              Obx(() => ReferralShareCard(code: userProfileController.referralCode)),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.widthPct(4),
                  context.heightPct(2.5),
                  context.widthPct(4),
                  context.heightPct(1),
                ),
                child: Text(
                  'REDEEM EXCLUSIVE REWARDS',
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              /// CATEGORY CHIPS
              SizedBox(
                height: context.heightPct(5).clamp(36.0, 44.0),
                child: Obx(() {
                  final selCat = controller.selectedCategory.value;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final cat = controller.categories[index];
                      final isSelected = cat == selCat;
                      return Padding(
                        padding: EdgeInsets.only(right: context.widthPct(2)),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.accent,
                          backgroundColor: AppColors.card,
                          labelStyle: AppTypography.bodySm.copyWith(
                            color: isSelected ? AppColors.background : AppColors.muted,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: context.responsiveFont(12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                            side: BorderSide(
                              color: isSelected ? AppColors.accent : AppColors.borderDark,
                            ),
                          ),
                          onSelected: (_) => controller.selectedCategory.value = cat,
                        ),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: context.heightPct(1.2)),

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
                      backgroundColor: AppColors.accent,
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
