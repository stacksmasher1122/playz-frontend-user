import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PaymentSummaryCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const PaymentSummaryCard({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final amount = bookingData?['amount'] ?? 1000;
    final paymentId = bookingData?['paymentId'] ?? '';

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        children: [
          _priceRow(context, 'Slot Booking Fee', '₹$amount'),
          _priceRow(context, 'Convenience Fee', 'FREE'),
          if (paymentId.toString().isNotEmpty)
            _priceRow(context, 'Razorpay Payment ID', paymentId.toString()),
          const Divider(color: AppColors.borderDark),
          Row(
            children: [
              Text(
                'Total Paid',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
              const Spacer(),
              Text(
                '₹$amount.00',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(16),
                ),
              ),
              SizedBox(width: context.widthPct(2)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(2),
                  vertical: context.heightPct(0.5),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                ),
                child: Text(
                  '+10 ZC',
                  style: AppTypography.labelCaps10.copyWith(
                    color: const Color(0xFFFFC107),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.heightPct(0.6)),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13),
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: context.responsiveFont(13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
