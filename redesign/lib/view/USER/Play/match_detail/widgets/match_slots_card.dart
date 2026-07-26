import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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

    final double moneyProgress = targetAmount > 0
        ? (collectedAmount / targetAmount).clamp(0.0, 1.0)
        : progress;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slots Filling Status",
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(12),
                  color: AppColors.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isSlotBooked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded, color: Color(0xFF34D399), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'SLOT BOOKED',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF34D399),
                          fontSize: ResponsiveHelper.sp(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "$currentPlayers",
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(32),
                  fontWeight: FontWeight.bold,
                  color: isFull ? Colors.redAccent : AppColors.accent,
                ),
              ),
              Text(
                " / $maxPlayers Players Joined",
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(14),
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// PLAYER PROGRESS BAR
          Stack(
            children: [
              Container(
                height: ResponsiveHelper.h(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: ResponsiveHelper.h(8),
                  decoration: BoxDecoration(
                    color: isFull ? Colors.redAccent : AppColors.accent,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                    boxShadow: [
                      BoxShadow(
                        color: (isFull ? Colors.redAccent : AppColors.accent).withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// GATHERED POLL MONEY SECTION (Shown if target amount exists)
          if (targetAmount > 0) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined, color: AppColors.accent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "Gathered Poll Funds",
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(12),
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  "₹${collectedAmount.toInt()} / ₹${targetAmount.toInt()}",
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  height: ResponsiveHelper.h(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: moneyProgress,
                  child: Container(
                    height: ResponsiveHelper.h(6),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
                    ),
                  ),
                ),
              ],
            ),
          ],

          /// BOOKED SLOTS ON TURF FOR THIS DATE (Displayed if any existing bookings exist)
          if (bookedSlotsForDate.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "Booked Slots on Turf",
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(12),
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (isHost && onChangeSlotPressed != null)
                  InkWell(
                    onTap: onChangeSlotPressed,
                    child: Text(
                      "Change Slot / Date >",
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(11),
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: bookedSlotsForDate.map((slotTime) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.block_rounded, color: Colors.redAccent, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        slotTime,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
