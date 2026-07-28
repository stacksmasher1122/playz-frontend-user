import 'package:flutter/material.dart';
import 'qr_amount_row.dart';
import 'qr_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PaymentSummaryCard extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const PaymentSummaryCard({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final amount = bookingData?['amount'] ?? 0;
    final paymentId = (bookingData?['paymentId'] ?? '').toString();
    final paymentType = bookingData?['bookingType'] ?? 'Online App';
    final refText = paymentId.isNotEmpty ? paymentId : paymentType.toString();

    return QrCard(
      title: 'Payment Summary',
      child: Column(
        children: [
          QrAmountRow('Court Fee', '₹$amount'),
          Divider(color: Colors.white12),
          QrAmountRow('Total Paid', '₹$amount', highlight: true),
          SizedBox(height: 6),
          QrAmountRow('Payment Method / Ref', refText),
        ],
      ),
    );
  }
}
