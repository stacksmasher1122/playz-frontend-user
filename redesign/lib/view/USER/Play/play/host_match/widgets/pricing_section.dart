import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
    this.isPlayZTurf = false,
    this.turfSlotCost = 0.0,
    this.maxPlayers = 10,
    this.isSplitAndPay = false,
    required this.priceController,
    required this.onFreeToggled,
    required this.onSplitAndPayToggled,
    required this.onPriceChanged,
    required this.hostDepositAmount,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final double pricePerPlayerNum = double.tryParse(priceController.text.trim()) ?? 0.0;
    final double maxContributionFromOthers = (maxPlayers > 1 ? maxPlayers - 1 : 1) * pricePerPlayerNum;
    final bool isOverchargingOthers = isPlayZTurf && !isFree && !isSplitAndPay && (maxContributionFromOthers > turfSlotCost) && turfSlotCost > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.payments_rounded, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Pricing & Fee',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Free to Join Toggle Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.volunteer_activism_rounded,
                          color: isFree ? AppColors.accent : Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Set it free to join',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.sp(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isFree,
                    activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
                    activeThumbColor: AppColors.accent,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.white10,
                    onChanged: onFreeToggled,
                  ),
                ],
              ),

              // SPLIT & PAY TOGGLE (Only if PlayZ Turf is selected and NOT free)
              if (isPlayZTurf && !isFree) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.call_split_rounded,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Split Equal Payments',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: ResponsiveHelper.sp(14),
                                  ),
                                ),
                                Text(
                                  'Divide turf slot cost equally among all players',
                                  style: GoogleFonts.inter(
                                    color: AppColors.muted,
                                    fontSize: ResponsiveHelper.sp(11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isSplitAndPay,
                      activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
                      activeThumbColor: AppColors.accent,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.white10,
                      onChanged: onSplitAndPayToggled,
                    ),
                  ],
                ),
              ],

              // Price Per Player TextField (Disappears if Free OR if Split & Pay is active on Turf)
              if (!isFree && (!isPlayZTurf || !isSplitAndPay)) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Per Player',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: ResponsiveHelper.sp(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isPlayZTurf && turfSlotCost > 0)
                      Text(
                        'Max total from others: ₹${turfSlotCost.toInt()}',
                        style: GoogleFonts.inter(
                          color: isOverchargingOthers ? AppColors.accent : AppColors.muted,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isOverchargingOthers ? AppColors.accent : Colors.white12,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter price per player...',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                          onChanged: onPriceChanged,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOverchargingOthers) ...[
                  const SizedBox(height: 6),
                  Text(
                    '⚠️ Total collected from players would exceed slot price (₹${turfSlotCost.toInt()}). Host deposit adjusted.',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(11),
                    ),
                  ),
                ],
              ],

              // PAYMENT BREAKDOWN CARD FOR PLAYZ TURF
              if (isPlayZTurf && turfSlotCost > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Turf Slot Price:',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.sp(12.5),
                            ),
                          ),
                          Text(
                            '₹${turfSlotCost.toInt()}',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.sp(13.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price Per Player:',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.sp(12.5),
                            ),
                          ),
                          Text(
                            isFree ? 'Free (₹0)' : '₹${(isSplitAndPay ? (turfSlotCost / maxPlayers).ceil() : pricePerPlayerNum.toInt())}',
                            style: GoogleFonts.inter(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.sp(13.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.white12, height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Host Upfront Deposit:',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.sp(13),
                            ),
                          ),
                          Text(
                            '₹${hostDepositAmount.toInt()}',
                            style: GoogleFonts.inter(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w900,
                              fontSize: ResponsiveHelper.sp(17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            isFree ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                            color: isFree ? const Color(0xFF34D399) : AppColors.accent,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              isFree
                                  ? 'Full payment paid upfront — Slot booked instantly! ⚡'
                                  : 'Slot will be booked automatically as remaining ₹${(turfSlotCost - hostDepositAmount).toInt()} is collected via Razorpay ⏳',
                              style: GoogleFonts.inter(
                                color: isFree ? const Color(0xFF34D399) : AppColors.accent,
                                fontSize: ResponsiveHelper.sp(11),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
