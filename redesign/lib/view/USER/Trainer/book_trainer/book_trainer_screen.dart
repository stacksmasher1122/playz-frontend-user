import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Trainer/book_trainer/package_model.dart';
import 'package:redesign/view/USER/Trainer/book_trainer/widgets/package_app_bar.dart';
import 'package:redesign/view/USER/Trainer/book_trainer/widgets/academy_summary_card.dart';
import 'package:redesign/view/USER/Trainer/book_trainer/widgets/package_option_card.dart';
import 'package:redesign/view/USER/Trainer/book_trainer/widgets/package_selection_bottom_cta.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;
const kYellow = Color(0xFFF5C542);

class ChoosePackageScreen extends StatefulWidget {
  ChoosePackageScreen({super.key});

  @override
  State<ChoosePackageScreen> createState() => _ChoosePackageScreenState();
}

class _ChoosePackageScreenState extends State<ChoosePackageScreen> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final List<PackageModel> packages = [
    PackageModel(
      badge: 'TRIAL SESSION',
      title: '1-Day Trial Access',
      desc:
          'Perfect for first-timers. Includes facility tour, skill assessment, and 1 hour net practice.',
      chips: ['1 Day', 'Kit Provided'],
      price: 150,
      billing: 'Single payment',
      coins: 15,
      highlight: true,
    ),
    PackageModel(
      badge: 'MOST POPULAR',
      title: 'Monthly Coaching',
      desc:
          'Comprehensive training focusing on technique and fitness. Includes weekend matches.',
      chips: ['1 Month', '3 Sessions / Week'],
      price: 2000,
      billing: 'Billed monthly',
      coins: 200,
    ),
    PackageModel(
      badge: 'BEST VALUE',
      title: 'Quarterly Pro Pass',
      desc:
          'For serious athletes. Intensive drills, video analysis, and personal mentoring.',
      chips: ['3 Months', '5 Sessions / Week', 'Video Analysis'],
      price: 5500,
      billing: 'Billed quarterly',
      coins: 600,
      badgeColor: kYellow,
    ),
    PackageModel(
      title: 'Half-Year Performance Plan',
      desc: 'Advanced coaching, fitness tracking, and match exposure.',
      chips: ['6 Months', '5 Sessions / Week'],
      price: 9800,
      billing: 'Billed half-yearly',
      coins: 1200,
    ),
    PackageModel(
      title: 'Annual Elite Program',
      desc:
          'Long-term mentorship, tournament preparation, and advanced analytics.',
      chips: ['12 Months', 'Priority Batches'],
      price: 18000,
      billing: 'Billed yearly',
      coins: 3000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 120),
              children: [
                PackageAppBar(),
                AcademySummaryCard(),
                SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder: (_, value, __) {
                    return Column(
                      children: List.generate(packages.length, (i) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: PackageOptionCard(
                            data: packages[i],
                            selected: value == i,
                            onTap: () => _selectedIndex.value = i,
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
          PackageSelectionBottomCta(packages: packages, selectedIndex: _selectedIndex),
        ],
      ),
    );
  }
}
