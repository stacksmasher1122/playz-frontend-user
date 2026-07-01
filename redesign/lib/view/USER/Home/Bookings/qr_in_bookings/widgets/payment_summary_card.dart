import 'package:flutter/material.dart';
import '../qr_in_bookings_screen.dart';
import 'qr_amount_row.dart';
import 'qr_card.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return QrCard(
      title: 'Payment Summary',
      child: Column(
        children: const [
          QrAmountRow('Court Fee', '₹1,200'),
          QrAmountRow('Conv. Fee', '₹40'),
          Divider(color: Colors.white12),
          QrAmountRow('Total Paid', '₹1,240', highlight: true),
          SizedBox(height: 6),
          QrAmountRow('Payment Method', 'UPI ••••8821'),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '⬇ Download Invoice',
              style: TextStyle(
                color: QrBookingConstants.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
