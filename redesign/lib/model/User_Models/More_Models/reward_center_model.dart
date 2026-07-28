class RewardItemModel {
  final String id;
  final String title;
  final String subtitle;
  final int coinCost;
  final String iconType; // 'discount', 'merch', 'theme', 'pass'
  final String category;
  final String discountCode;
  bool isRedeemed;

  RewardItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coinCost,
    required this.iconType,
    required this.category,
    required this.discountCode,
    this.isRedeemed = false,
  });
}

class EarnCoinTaskModel {
  final String id;
  final String title;
  final int coinReward;
  final String actionText;
  final bool isCompleted;

  EarnCoinTaskModel({
    required this.id,
    required this.title,
    required this.coinReward,
    required this.actionText,
    this.isCompleted = false,
  });
}
