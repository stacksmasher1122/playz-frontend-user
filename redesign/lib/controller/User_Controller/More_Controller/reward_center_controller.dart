import 'package:get/get.dart';
import 'package:redesign/model/User_Models/More_Models/reward_center_model.dart';

class RewardCenterController extends GetxController {
  final userCoins = 2450.obs;
  final referralCode = 'PLAYZ-X982'.obs;
  final totalInvites = 5.obs;

  final selectedCategory = 'All'.obs;
  final categories = const ['All', 'Discounts', 'Merch', 'Themes', 'Passes'];

  final rewardsList = <RewardItemModel>[
    RewardItemModel(
      id: 'r_1',
      title: '₹200 Off Turf Booking',
      subtitle: 'Valid on any slot booking above ₹500',
      coinCost: 500,
      iconType: 'discount',
      category: 'Discounts',
      discountCode: 'TURF200OFF',
    ),
    RewardItemModel(
      id: 'r_2',
      title: 'PlayZ Pro Scoreboard Theme',
      subtitle: 'Unlock Neon Cyberpunk scoreboards for Cricket & Badminton',
      coinCost: 800,
      iconType: 'theme',
      category: 'Themes',
      discountCode: 'PROSCORE-NEON',
    ),
    RewardItemModel(
      id: 'r_3',
      title: 'Official PlayZ Dri-Fit Jersey',
      subtitle: 'Customized with your name & favorite number',
      coinCost: 2000,
      iconType: 'merch',
      category: 'Merch',
      discountCode: 'JERSEY-PLAYZ-VIP',
    ),
    RewardItemModel(
      id: 'r_4',
      title: 'Free Tournament Entry Pass',
      subtitle: '1x Free Team Registration in any weekend tournament',
      coinCost: 1500,
      iconType: 'pass',
      category: 'Passes',
      discountCode: 'TOURN-FREEPASS',
    ),
    RewardItemModel(
      id: 'r_5',
      title: '₹100 Off Open Play Match',
      subtitle: 'Instant discount on joining host split games',
      coinCost: 300,
      iconType: 'discount',
      category: 'Discounts',
      discountCode: 'OPENPLAY100',
    ),
  ].obs;

  final earnTasks = <EarnCoinTaskModel>[
    EarnCoinTaskModel(
      id: 't_1',
      title: 'Share App with 3 Friends',
      coinReward: 500,
      actionText: 'Invite Friends',
    ),
    EarnCoinTaskModel(
      id: 't_2',
      title: 'Daily App Check-In',
      coinReward: 50,
      actionText: 'Claim 50 Coins',
    ),
    EarnCoinTaskModel(
      id: 't_3',
      title: 'Complete 3 Live Scoreboard Matches',
      coinReward: 300,
      actionText: 'Score Match',
    ),
    EarnCoinTaskModel(
      id: 't_4',
      title: 'Host an Open Play Turf Game',
      coinReward: 250,
      actionText: 'Host Game',
    ),
  ].obs;

  List<RewardItemModel> get filteredRewards {
    if (selectedCategory.value == 'All') return rewardsList;
    return rewardsList.where((r) => r.category == selectedCategory.value).toList();
  }

  bool redeemReward(String id) {
    final idx = rewardsList.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final reward = rewardsList[idx];
      if (userCoins.value >= reward.coinCost && !reward.isRedeemed) {
        userCoins.value -= reward.coinCost;
        reward.isRedeemed = true;
        rewardsList.refresh();
        return true;
      }
    }
    return false;
  }
}
