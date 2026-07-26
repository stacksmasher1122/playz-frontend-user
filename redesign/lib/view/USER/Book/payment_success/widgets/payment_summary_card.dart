import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PaymentSummaryCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  PaymentSummaryCard({super.key, this.bookingData});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final amount = bookingData?['amount'] ?? 1000;
    final paymentId = bookingData?['paymentId'] ?? '';

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _priceRow('Slot Booking Fee', '₹$amount'),
          _priceRow('Convenience Fee', 'FREE'),
          if (paymentId.toString().isNotEmpty)
            _priceRow('Razorpay Payment ID', paymentId.toString()),
          Divider(color: Colors.grey.shade800),
          Row(
            children: [
              Text(
                'Total Paid',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              Spacer(),
              Text(
                '₹$amount.00',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(16),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(8),
                  vertical: ResponsiveHelper.h(4),
                ),
                decoration: BoxDecoration(
                  color: _kYellow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                ),
                child: Text('+10 ZC', style: TextStyle(color: _kYellow)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6)),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: _kMuted)),
          Spacer(),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
