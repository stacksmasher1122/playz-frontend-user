import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchSlotsCard extends StatelessWidget {
  final int currentPlayers;
  final int maxPlayers;
  final double collectedAmount;
  final double targetAmount;
  final bool isSlotBooked;
  final List<String> bookedSlotsForDate;
  final bool isHost;
  final VoidCallback? onChangeSlotPressed;

  const MatchSlotsCard({
    super.key,
    this.currentPlayers = 6,
    this.maxPlayers = 10,
    this.collectedAmount = 0.0,
    this.targetAmount = 0.0,
    this.isSlotBooked = false,
    this.bookedSlotsForDate = const [],
    this.isHost = false,
    this.onChangeSlotPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = (currentPlayers / (maxPlayers > 0 ? maxPlayers : 1)).clamp(0.0, 1.0);
    final isFull = currentPlayers >= maxPlayers;

    return Container(
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slots Filling Status",
                style: AppTypography.bodySm.copyWith(
                  fontSize: context.responsiveFont(12),
                  color: AppColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isSlotBooked)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(2),
                    vertical: context.heightPct(0.4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                    border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded, color: Color(0xFF34D399), size: 14),
                      SizedBox(width: context.widthPct(1)),
                      Text(
                        'SLOT BOOKED',
                        style: AppTypography.labelCaps10.copyWith(
                          color: const Color(0xFF34D399),
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: context.heightPct(0.5)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "$currentPlayers",
                style: AppTypography.displayLg.copyWith(
                  fontSize: context.responsiveFont(32),
                  fontWeight: FontWeight.bold,
                  color: isFull ? AppColors.error : AppColors.accent,
                ),
              ),
              Text(
                " / $maxPlayers Players Joined",
                style: AppTypography.headlineSm.copyWith(
                  fontSize: context.responsiveFont(14),
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.8)),

          /// PLAYER PROGRESS BAR
          Stack(
            children: [
              Container(
                height: context.heightPct(1).clamp(6.0, 10.0),
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: context.heightPct(1).clamp(6.0, 10.0),
                  decoration: BoxDecoration(
                    color: isFull ? AppColors.error : AppColors.accent,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                    boxShadow: [
                      BoxShadow(
                        color: (isFull ? AppColors.error : AppColors.accent).withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
