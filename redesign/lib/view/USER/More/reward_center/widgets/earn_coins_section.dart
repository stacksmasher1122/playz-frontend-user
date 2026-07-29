import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/reward_center_model.dart';

class EarnCoinsSection extends StatelessWidget {
  final List<EarnCoinTaskModel> tasks;
  final VoidCallback onInviteTap;

  const EarnCoinsSection({
    super.key,
    required this.tasks,
    required this.onInviteTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(4),
            context.heightPct(2.5),
            context.widthPct(4),
            context.heightPct(1),
          ),
          child: Text(
            'WAYS TO EARN Z-COINS',
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...tasks.map((t) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(0.5),
            ),
            padding: EdgeInsets.all(context.widthPct(3.5)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.widthPct(2.5)),
                  decoration: BoxDecoration(
                    color: AppColors.coinsGold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_task_rounded, color: AppColors.coinsGold, size: 20),
                ),
                SizedBox(width: context.widthPct(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: context.responsiveFont(13),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: AppColors.coinsGold, size: 14),
                          SizedBox(width: context.widthPct(1)),
                          Text(
                            '+${t.coinReward} Coins',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.coinsGold,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.widthPct(2)),
                OutlinedButton(
                  onPressed: () {
                    if (t.actionText == 'Invite Friends') {
                      onInviteTap();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task "${t.title}" activated! Earn +${t.coinReward} coins on completion.'),
                          backgroundColor: AppColors.card,
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.accent),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3),
                      vertical: context.heightPct(1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                    ),
                  ),
                  child: Text(
                    t.actionText,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
