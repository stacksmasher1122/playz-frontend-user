import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/join_premium_model.dart';

import 'widgets/premium_hero_header.dart';
import 'widgets/premium_feature_list.dart';
import 'widgets/premium_plan_cards.dart';
import 'widgets/free_vs_pro_comparison_card.dart';
import 'widgets/premium_guarantee_rating.dart';
import 'widgets/premium_action_bottom_bar.dart';

class JoinPremiumScreen extends StatefulWidget {
  const JoinPremiumScreen({super.key});

  @override
  State<JoinPremiumScreen> createState() => _JoinPremiumScreenState();
}

class _JoinPremiumScreenState extends State<JoinPremiumScreen> {
  late List<PremiumPlanModel> _plans;
  String _selectedPlanId = 'annual';

  @override
  void initState() {
    super.initState();
    _plans = PremiumPlanModel.getSamplePlans();
  }

  String get _selectedPlanTitle {
    final selected = _plans.firstWhere(
      (p) => p.id == _selectedPlanId,
      orElse: () => _plans[0],
    );
    return '${selected.title} Plan';
  }

  void _onStartPlan() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF16251C),
        content: Text(
          'Initiating subscription for $_selectedPlanTitle...',
          style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: ResponsiveHelper.h(10)),
                  const PremiumHeroHeader(),
                  SizedBox(height: ResponsiveHelper.h(20)),
                  const PremiumFeatureList(),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  PremiumPlanCards(
                    plans: _plans,
                    selectedPlanId: _selectedPlanId,
                    onPlanSelected: (id) => setState(() => _selectedPlanId = id),
                  ),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  const FreeVsProComparisonCard(),
                  SizedBox(height: ResponsiveHelper.h(24)),
                  const PremiumGuaranteeRating(),
                  SizedBox(height: ResponsiveHelper.h(24)),
                ],
              ),
            ),

            // Sticky Bottom Action Bar
            PremiumActionBottomBar(
              buttonText: 'Start $_selectedPlanTitle',
              onPressed: _onStartPlan,
            ),
          ],
        ),
      ),
    );
  }
}
