import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'venue_policy_box.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingSummary extends StatelessWidget {
  final double slotPrice;
  final int hours;

  const BookingSummary({
    super.key,
    required this.slotPrice,
    this.hours = 1,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final slotTotal = slotPrice * hours;
    final displaySlotPrice = slotPrice > 0 ? '₹${slotTotal.toInt()}' : '₹--';
    final displayTotal = slotPrice > 0 ? '₹${slotTotal.toInt()}' : '₹--';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(text: 'Additional Notes'),
          _textArea(context, 'Write any special requests...'),
          SizedBox(height: context.heightPct(2)),

          const VenuePolicyBox(),
          SizedBox(height: context.heightPct(2.5)),

          _priceRow(
            context,
            'Slot Price ($hours hr${hours > 1 ? 's' : ''})',
            displaySlotPrice,
          ),
          _priceRow(context, 'Add-ons', '₹0'),
          const Divider(color: AppColors.borderDark),
          _priceRow(context, 'Total Amount', displayTotal, highlight: true),
        ],
      ),
    );
  }

  Widget _textArea(BuildContext context, String hint) {
    return Container(
      margin: EdgeInsets.only(top: context.heightPct(1)),
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: TextField(
        maxLines: 3,
        style: AppTypography.bodySm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(14),
        ),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: AppTypography.bodySm.copyWith(
            color: AppColors.muted,
            fontSize: context.responsiveFont(14),
          ),
        ),
      ),
    );
  }

  Widget _priceRow(BuildContext context, String label, String value, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(0.6)),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.headlineSm.copyWith(
              color: highlight ? AppColors.accent : AppColors.textPrimary,
              fontSize: context.responsiveFont(highlight ? 16 : 14),
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Text(
      text,
      style: AppTypography.headlineSm.copyWith(
        color: AppColors.textPrimary,
        fontSize: context.responsiveFont(18),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
