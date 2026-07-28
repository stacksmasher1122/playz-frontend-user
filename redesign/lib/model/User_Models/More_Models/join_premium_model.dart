class PremiumPlanModel {
  final String id;
  final String title;
  final String priceText;
  final String periodText; // '/year', '/mo'
  final String? savingsTag; // 'Save 44%'
  final String? equivalentText; // 'Equivalent to ₹167/mo'
  final String? bottomSavingsBanner; // 'You save ₹1,589 every year'
  final String? badgeTag; // 'BEST VALUE', 'MOST POPULAR'
  final bool isBestValue;

  const PremiumPlanModel({
    required this.id,
    required this.title,
    required this.priceText,
    required this.periodText,
    this.savingsTag,
    this.equivalentText,
    this.bottomSavingsBanner,
    this.badgeTag,
    this.isBestValue = false,
  });

  static List<PremiumPlanModel> getSamplePlans() {
    return const [
      PremiumPlanModel(
        id: 'annual',
        title: 'Annual',
        priceText: '₹1,999',
        periodText: '/year',
        savingsTag: 'Save 44%',
        equivalentText: 'Equivalent to ₹167/mo',
        bottomSavingsBanner: 'You save ₹1,589 every year',
        badgeTag: '🔥 BEST VALUE ⭐',
        isBestValue: true,
      ),
      PremiumPlanModel(
        id: '6_months',
        title: '6 Months',
        priceText: '₹1,199',
        periodText: '',
        equivalentText: '₹199/mo',
        badgeTag: 'MOST POPULAR',
      ),
      PremiumPlanModel(
        id: 'monthly',
        title: 'Monthly',
        priceText: '₹299',
        periodText: '/mo',
      ),
    ];
  }
}
