import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PricingSection extends StatelessWidget {
  final bool isFree;
  final bool isPlayZTurf;
  final double turfSlotCost;
  final int maxPlayers;
  final bool isSplitAndPay;
  final TextEditingController priceController;
  final ValueChanged<bool> onFreeToggled;
  final ValueChanged<bool> onSplitAndPayToggled;
  final ValueChanged<String> onPriceChanged;
  final double hostDepositAmount;

  const PricingSection({
    super.key,
    required this.isFree,
    required this.isPlayZTurf,
    required this.turfSlotCost,
    required this.maxPlayers,
    required this.isSplitAndPay,
    required this.priceController,
    required this.onFreeToggled,
    required this.onSplitAndPayToggled,
    required this.onPriceChanged,
    required this.hostDepositAmount,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final double equalSplitPrice = (isPlayZTurf && turfSlotCost > 0)
        ? (turfSlotCost / (maxPlayers > 0 ? maxPlayers : 1)).ceilToDouble()
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.monetization_on_outlined, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Pricing & Match Fee',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1.2)),

        // FREE MATCH TOGGLE
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4),
            vertical: context.heightPct(0.5),
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free to Join',
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
                      isPlayZTurf
                          ? 'Host pays full turf slot price upfront'
                          : 'No entry fee for participating players',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(11.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Switch(
                value: isFree,
                activeThumbColor: AppColors.accent,
                onChanged: onFreeToggled,
              ),
            ],
          ),
        ),

        // SPLIT EQUALLY TOGGLE (PLAYZ TURF ONLY)
        if (isPlayZTurf && !isFree && turfSlotCost > 0) ...[
          SizedBox(height: context.heightPct(1.2)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(0.5),
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              border: Border.all(
                color: isSplitAndPay ? AppColors.accent : AppColors.borderDark,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Split Turf Cost Equally (₹${equalSplitPrice.toInt()}/player)',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(13.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        'Divides total turf slot cost (₹${turfSlotCost.toInt()}) equally among $maxPlayers players',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(11.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isSplitAndPay,
                  activeThumbColor: AppColors.accent,
                  onChanged: onSplitAndPayToggled,
                ),
              ],
            ),
          ),
        ],

        // CUSTOM PRICE INPUT FIELD (Only when NOT free and NOT split & pay)
        if (!isFree && !isSplitAndPay) ...[
          SizedBox(height: context.heightPct(1.2)),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: context.responsiveFont(16),
            ),
            decoration: InputDecoration(
              labelText: 'Price Per Player (₹)',
              labelStyle: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(13),
              ),
              prefixIcon: const Icon(Icons.currency_rupee_rounded, color: AppColors.accent),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                borderSide: const BorderSide(color: AppColors.borderDark),
              ),
            ),
            onChanged: onPriceChanged,
          ),
        ],

        // HOST UPFRONT DEPOSIT BANNER (Shown for PlayZ Turfs)
        if (isPlayZTurf && hostDepositAmount > 0) ...[
          SizedBox(height: context.heightPct(1.5)),
          Container(
            padding: EdgeInsets.all(context.widthPct(3.5)),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.accent, size: 22),
                SizedBox(width: context.widthPct(3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Host Deposit Required: ₹${hostDepositAmount.toInt()}',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(13.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        'You pay your share upfront to initialize the poll and reserve the slot.',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFont(11.5),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
