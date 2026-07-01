import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'widgets/offer_timer_banner.dart';
import 'widgets/pro_blurred_header.dart';
import 'widgets/pro_video_card.dart';
import 'widgets/pro_value_card.dart';
import 'widgets/pro_trust_tags.dart';
import 'widgets/pro_membership_header.dart';
import 'widgets/pro_plan_card.dart';
import 'widgets/pro_comparison_table.dart';
import 'widgets/why_go_pro_section.dart';
import 'widgets/trainer_success_stories.dart';
import 'widgets/money_back_guarantee_banner.dart';
import 'widgets/pro_faq_section.dart';
import 'widgets/pro_bottom_cta.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;

class TrainerProAccessScreen extends StatefulWidget {
  TrainerProAccessScreen({super.key});

  @override
  State<TrainerProAccessScreen> createState() => _TrainerProAccessScreenState();
}

class _TrainerProAccessScreenState extends State<TrainerProAccessScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier(1);

  Duration offerTime = Duration(hours: 4, minutes: 23, seconds: 12);
  Timer? timer;

  final plans = [
    ProPlan(
      title: '6 Months',
      price: '₹2,999',
      monthly: '₹500 / month',
      subtitle: 'Cost of a coffee per week',
    ),
    ProPlan(
      title: '1 Year',
      price: '₹4,999',
      monthly: '₹416 / month',
      badge: 'MOST POPULAR',
      savings: 'Save 20%',
      subtitle: 'Best balance of price & value',
    ),
    ProPlan(
      title: '3 Years',
      price: '₹11,999',
      monthly: '₹333 / month',
      badge: 'BEST VALUE',
      savings: 'Save 35%',
      subtitle: 'Maximum long-term savings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (offerTime.inSeconds > 0) {
        setState(() => offerTime -= Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    selectedIndex.dispose();
    super.dispose();
  }

  String _format(Duration d) =>
      '${d.inHours.toString().padLeft(2, '0')}:'
      '${(d.inMinutes % 60).toString().padLeft(2, '0')}:'
      '${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 700;
            final bottomInset = MediaQuery.of(context).padding.bottom;

            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                OfferTimerBanner(text: _format(offerTime)),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 120 + bottomInset),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ProBlurredHeader(),
                      SizedBox(height: 16),
                      ProVideoCard(),
                      SizedBox(height: 16),
                      ProValueCard(),
                      SizedBox(height: 14),
                      ProTrustTags(),
                      SizedBox(height: 24),
                      ProMembershipHeader(),
                      SizedBox(height: 12),
                      ValueListenableBuilder<int>(
                        valueListenable: selectedIndex,
                        builder: (_, value, __) {
                          if (isTablet) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.9,
                              ),
                              itemCount: plans.length,
                              itemBuilder: (_, i) => ProPlanCard(
                                plan: plans[i],
                                selected: value == i,
                                onTap: () => selectedIndex.value = i,
                              ),
                            );
                          }

                          return Column(
                            children: List.generate(
                              plans.length,
                              (i) => Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: ProPlanCard(
                                  plan: plans[i],
                                  selected: value == i,
                                  onTap: () => selectedIndex.value = i,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      ProComparisonTable(),
                      SizedBox(height: 20),
                      WhyGoProSection(),
                      SizedBox(height: 20),
                      TrainerSuccessStories(),
                      SizedBox(height: 24),
                      MoneyBackGuaranteeBanner(),
                      SizedBox(height: 32),
                      ProFaqSection(),
                      SizedBox(height: 36),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ProBottomCTA(
        plans: plans,
        selectedIndex: selectedIndex,
      ),
    );
  }
}
