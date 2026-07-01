import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);
Color kMuted = Color(0xFFA7A7A7);
Color kGreen = AppColors.accent;

class AcademyPackagesList extends StatefulWidget {
  AcademyPackagesList({super.key});

  @override
  State<AcademyPackagesList> createState() => _AcademyPackagesListState();
}

class _AcademyPackagesListState extends State<AcademyPackagesList> {
  int selectedIndex = 1; // Default: Monthly (Most Popular)

  final List<PackageModel> packages = [
    PackageModel(
      title: 'Trial Session',
      price: 'FREE',
      subtitle: '1 Day Trial • Coach Interaction',
      features: ['Ground walkthrough', 'Coach interaction', 'Skill assessment'],
    ),
    PackageModel(
      title: 'Monthly Transformation',
      price: '₹2,000',
      badge: 'MOST POPULAR',
      subtitle: '12 Sessions / Month • 1 Hour',
      features: [
        'Customized Diet Plan',
        'Weekly Progress Track',
        'Net Practice',
      ],
    ),
    PackageModel(
      title: '3 Month Plan',
      price: '₹5,500',
      subtitle: 'Quarterly Training Program',
      features: ['Structured coaching', 'Fitness drills', 'Match practice'],
    ),
    PackageModel(
      title: '6 Month Plan',
      price: '₹10,000',
      subtitle: 'Half Year Commitment',
      features: [
        'Advanced technique training',
        'Video analysis',
        'Performance reports',
      ],
    ),
    PackageModel(
      title: 'Annual Pro Plan',
      price: '₹18,000',
      subtitle: 'Best Value • Full Year',
      features: [
        'Elite coaching',
        'Tournament preparation',
        'Priority batches',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text('View all', style: TextStyle(color: kGreen)),
          ],
        ),
        SizedBox(height: 12),

        ...List.generate(packages.length, (index) {
          final pkg = packages[index];
          final bool active = index == selectedIndex;

          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              child: PackageCard(model: pkg, active: active),
            ),
          );
        }),
      ],
    );
  }
}

class PackageCard extends StatelessWidget {
  final PackageModel model;
  final bool active;

  PackageCard({super.key, required this.model, required this.active});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(
          color: active ? kGreen : Colors.transparent,
          width: ResponsiveHelper.w(1.4),
        ),
        boxShadow: active
            ? [BoxShadow(color: kGreen.withValues(alpha: 0.25), blurRadius: 14)]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.badge != null)
            Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              ),
              child: Text(
                model.badge!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Row(
            children: [
              Expanded(
                child: Text(
                  model.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                model.price,
                style: TextStyle(
                  color: kGreen,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          if (model.subtitle != null) ...[
            SizedBox(height: 4),
            Text(model.subtitle!, style: TextStyle(color: kMuted)),
          ],

          /// FEATURES (ONLY WHEN ACTIVE)
          AnimatedCrossFade(
            firstChild: SizedBox.shrink(),
            secondChild: Column(
              children: model.features
                  .map(
                    (f) => Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: kGreen, size: 16),
                          SizedBox(width: 8),
                          Text(f, style: TextStyle(color: kMuted)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            crossFadeState: active
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class PackageModel {
  final String title;
  final String price;
  final String? subtitle;
  final String? badge;
  final List<String> features;

  PackageModel({
    required this.title,
    required this.price,
    this.subtitle,
    this.badge,
    required this.features,
  });
}
