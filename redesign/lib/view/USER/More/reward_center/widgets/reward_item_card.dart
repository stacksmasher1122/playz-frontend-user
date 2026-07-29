import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/reward_center_model.dart';

class RewardItemCard extends StatelessWidget {
  final RewardItemModel item;
  final VoidCallback onRedeem;

  const RewardItemCard({
    super.key,
    required this.item,
    required this.onRedeem,
  });

  IconData _getIcon() {
    switch (item.iconType) {
      case 'discount':
        return Icons.local_offer_rounded;
      case 'theme':
        return Icons.palette_rounded;
      case 'merch':
        return Icons.checkroom_rounded;
      case 'pass':
        return Icons.confirmation_number_rounded;
      default:
        return Icons.card_giftcard_rounded;
    }
  }

  Color _getIconColor() {
    switch (item.iconType) {
      case 'discount':
        return AppColors.accent;
      case 'theme':
        return Colors.purpleAccent;
      case 'merch':
        return Colors.orangeAccent;
      case 'pass':
        return Colors.lightBlueAccent;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(0.8),
      ),
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
        border: Border.all(
          color: item.isRedeemed ? AppColors.borderDark : AppColors.accent.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.widthPct(3)),
            decoration: BoxDecoration(
              color: _getIconColor().withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: _getIconColor(), size: 24),
          ),
          SizedBox(width: context.widthPct(3.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(14),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  item.subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(1)),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: AppColors.coinsGold, size: 16),
                    SizedBox(width: context.widthPct(1)),
                    Text(
                      '${item.coinCost} Coins',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.coinsGold,
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFont(13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: context.widthPct(3)),
          ElevatedButton(
            onPressed: item.isRedeemed ? null : onRedeem,
            style: ElevatedButton.styleFrom(
              backgroundColor: item.isRedeemed ? AppColors.borderDark : AppColors.accent,
              disabledBackgroundColor: AppColors.borderDark.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4),
                vertical: context.heightPct(1.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.isRedeemed ? 'Redeemed' : 'Redeem',
                style: AppTypography.headlineSm.copyWith(
                  color: item.isRedeemed ? AppColors.muted : AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
