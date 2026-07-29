import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PrizePoolSection extends StatelessWidget {
  final Map<String, dynamic> data;

  const PrizePoolSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final entryFee = data['entryFee'] ?? {};
    final bool isFree = entryFee['isFree'] ?? true;
    final num? amount = entryFee['amount'];

    final prizePool = data['prizePool'] ?? {};
    final bool hasPrizePool = prizePool['hasPrizePool'] ?? false;
    final List<dynamic> tiers = prizePool['tiers'] ?? [];

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Entry Fee & Prizes",
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(3),
                  vertical: context.heightPct(0.8),
                ),
                decoration: BoxDecoration(
                  color: isFree ? AppColors.accent.withValues(alpha: 0.2) : AppColors.surface,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                  border: Border.all(color: isFree ? AppColors.accent : AppColors.borderDark),
                ),
                child: Text(
                  isFree ? "Free Entry" : "₹$amount",
                  style: AppTypography.labelCaps10.copyWith(
                    color: isFree ? AppColors.accent : AppColors.textPrimary,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.5)),
          const Divider(color: AppColors.borderDark, height: 1),
          SizedBox(height: context.heightPct(1.5)),
          if (!hasPrizePool || tiers.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                child: Text(
                  "No prizes configured for this tournament.",
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
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
                  padding: EdgeInsets.only(bottom: context.heightPct(1.2)),
                  child: Row(
                    children: [
                      Icon(
                        isRank ? Icons.emoji_events_rounded : Icons.star_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      SizedBox(width: context.widthPct(3)),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTypography.bodyLg.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "₹$tierAmount",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(14),
                        ),
                      ),
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
