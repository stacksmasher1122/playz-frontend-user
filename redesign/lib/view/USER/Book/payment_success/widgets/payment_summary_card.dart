import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PaymentSummaryCard extends StatelessWidget {
  PaymentSummaryCard({super.key});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      ),
      child: Column(
        children: [
          _priceRow('Slot Price (1 hr)', '₹400.00'),
          _priceRow('Convenience Fee', '₹50.00'),
          _priceRow('Equipment (Ball)', 'Included'),
          Divider(color: Colors.grey),
          Row(
            children: [
              Text(
                'Total Paid',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '₹450.00',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
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
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
