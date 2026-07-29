import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SoloQueueOptions extends StatelessWidget {
  final bool soloQueue;
  final int players;
  final double radius;
  final bool splitAndPay;
  final bool bringOwnEquipment;
  final int baseSlotPrice;
  final ValueChanged<bool> onSoloQueueChanged;
  final ValueChanged<int> onPlayersChanged;
  final ValueChanged<double> onRadiusChanged;
  final ValueChanged<bool> onSplitAndPayChanged;
  final ValueChanged<bool> onBringOwnEquipmentChanged;

  const SoloQueueOptions({
    super.key,
    required this.soloQueue,
    required this.players,
    required this.radius,
    required this.splitAndPay,
    required this.bringOwnEquipment,
    required this.baseSlotPrice,
    required this.onSoloQueueChanged,
    required this.onPlayersChanged,
    required this.onRadiusChanged,
    required this.onSplitAndPayChanged,
    required this.onBringOwnEquipmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(4)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.accent),
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SOLO QUEUE TOGGLE
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: soloQueue,
              activeTrackColor: AppColors.accent,
              title: Text(
                'Solo Queue Mode',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: context.responsiveFont(15),
                ),
              ),
              subtitle: Text(
                'Allow others to join and split cost',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                ),
              ),
              onChanged: onSoloQueueChanged,
            ),

            /// EXTRA OPTIONS (ONLY WHEN ENABLED)
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _soloQueueExtras(context),
              crossFadeState: soloQueue
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _soloQueueExtras(BuildContext context) {
    final int perPersonAmount = splitAndPay
        ? (baseSlotPrice / players).ceil()
        : baseSlotPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.heightPct(2)),

        /// TOTAL PLAYERS
        Text(
          'Total Players Needed',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(14),
          ),
        ),
        SizedBox(height: context.heightPct(1)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: players > 1 ? () => onPlayersChanged(players - 1) : null,
              icon: const Icon(Icons.remove),
              color: AppColors.textPrimary,
            ),
            Text(
              '$players Players',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => onPlayersChanged(players + 1),
              icon: const Icon(Icons.add),
              color: AppColors.textPrimary,
            ),
          ],
        ),

        SizedBox(height: context.heightPct(2)),

        /// SPLIT & PAY TOGGLE
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: splitAndPay,
          activeTrackColor: AppColors.accent,
          title: Text(
            'Split & Pay',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: context.responsiveFont(14),
            ),
          ),
          subtitle: Text(
            splitAndPay
                ? 'Each player pays ₹$perPersonAmount'
                : 'Host pays full amount',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(12),
            ),
          ),
          onChanged: onSplitAndPayChanged,
        ),

        SizedBox(height: context.heightPct(2)),

        /// MATCHMAKING RADIUS (UP TO 20 KM)
        Text(
          'Matchmaking Radius',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(14),
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: AppColors.accent,
            valueIndicatorTextStyle: AppTypography.bodySm.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.w500,
            ),
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.borderDark,
            thumbColor: AppColors.accent,
          ),
          child: Slider(
            value: radius,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${radius.toInt()} km',
            onChanged: onRadiusChanged,
          ),
        ),

        SizedBox(height: context.heightPct(1.5)),

        /// BRING YOUR OWN EQUIPMENT
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: bringOwnEquipment,
          activeTrackColor: AppColors.accent,
          title: Text(
            'Bring Your Own Equipment',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(14),
            ),
          ),
          subtitle: Text(
            'Players will bring their own gear',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(12),
            ),
          ),
          onChanged: onBringOwnEquipmentChanged,
        ),

        SizedBox(height: context.heightPct(1.5)),

        /// SUMMARY CARD
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.widthPct(3)),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent),
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            color: AppColors.card,
          ),
          child: Text(
            splitAndPay
                ? 'Posting for $players Players • ₹$perPersonAmount / person • ${radius.toInt()} km'
                : 'Posting for $players Players • Host pays ₹$baseSlotPrice • ${radius.toInt()} km'
                      '${bringOwnEquipment ? ' • BYO Equipment' : ''}',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: context.responsiveFont(13),
            ),
          ),
        ),
      ],
    );
  }
}
