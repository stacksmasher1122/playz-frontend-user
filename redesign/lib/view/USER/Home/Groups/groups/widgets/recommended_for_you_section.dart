import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'recommended_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;

class RecommendedForYouSection extends StatelessWidget {
  RecommendedForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: Color(0xFF0C0C0C),
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24)),
      margin: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RECOMMENDED FOR YOU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'SEE ALL',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          RecommendedCard(
            name: 'Pune Runners Club',
            members: '1.2K MEMBERS',
            status: 'ACTIVE NOW',
            imageUrl:
                'https://images.unsplash.com/photo-1552674605-db6ffd4facb5',
          ),
          SizedBox(height: 12),
          RecommendedCard(
            name: 'Badminton Smashers',
            members: '840 MEMBERS',
            status: '12 ACTIVE',
            imageUrl:
                'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea',
          ),
        ],
      ),
    );
  }
}
