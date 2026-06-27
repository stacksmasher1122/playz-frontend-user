import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'recommended_card.dart';

const kGreen = AppColors.accent;

class RecommendedForYouSection extends StatelessWidget {
  const RecommendedForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C0C0C),
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RECOMMENDED FOR YOU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'SEE ALL',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const RecommendedCard(
            name: 'Pune Runners Club',
            members: '1.2K MEMBERS',
            status: 'ACTIVE NOW',
            imageUrl:
                'https://images.unsplash.com/photo-1552674605-db6ffd4facb5',
          ),
          const SizedBox(height: 12),
          const RecommendedCard(
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
