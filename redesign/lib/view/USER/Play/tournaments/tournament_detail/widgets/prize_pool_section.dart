import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PrizePoolSection extends StatelessWidget {
  final Map<String, dynamic> data;

  const PrizePoolSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entryFee = data['entryFee'] ?? {};
    final bool isFree = entryFee['isFree'] ?? true;
    final num? amount = entryFee['amount'];

    final prizePool = data['prizePool'] ?? {};
    final bool hasPrizePool = prizePool['hasPrizePool'] ?? false;
    final List<dynamic> tiers = prizePool['tiers'] ?? [];

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Entry Fee & Prizes", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
                decoration: BoxDecoration(
                  color: isFree ? AppColors.accent.withOpacity(0.2) : AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  border: Border.all(color: isFree ? AppColors.accent : AppColors.outlineVariant),
                ),
                child: Text(
                  isFree ? "Free Entry" : "₹$amount",
                  style: AppTypography.labelCaps.copyWith(
                    color: isFree ? AppColors.accent : AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(16)),
          Divider(color: AppColors.surface, height: 1),
          SizedBox(height: ResponsiveHelper.h(16)),
          if (!hasPrizePool || tiers.isEmpty)
            Center(
              child: Text(
                "No prizes configured for this tournament.",
                style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
              ),
            )
          else
            Column(
              children: tiers.map((t) {
                final tier = t as Map<String, dynamic>;
                final bool isRank = tier['type'] == 'rank';
                final String title = isRank ? "${tier['rankPosition']} Place" : (tier['title'] ?? 'Prize');
                final num tierAmount = tier['amount'] ?? 0;
                return Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
                  child: Row(
                    children: [
                      Icon(isRank ? Icons.emoji_events : Icons.star, color: AppColors.accent, size: ResponsiveHelper.w(20)),
                      SizedBox(width: ResponsiveHelper.w(12)),
                      Expanded(
                        child: Text(title, style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
                      ),
                      Text("₹$tierAmount", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
