import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
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
          const Divider(color: AppColors.borderDark),
          QrAmountRow('Total Paid', '₹$amount', highlight: true),
          SizedBox(height: context.heightPct(0.6)),
          QrAmountRow('Payment Method / Ref', refText),
        ],
      ),
    );
  }
}
