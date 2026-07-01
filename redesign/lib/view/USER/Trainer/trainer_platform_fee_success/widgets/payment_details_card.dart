import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_success_simple_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class PaymentDetailsCard extends StatelessWidget {
  PaymentDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FeeSuccessSimpleCard(
      title: 'PAYMENT DETAILS',
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.download_rounded, size: 16),
        label: Text('PDF'),
        style: OutlinedButton.styleFrom(
          foregroundColor: kGreen,
          side: BorderSide(color: kGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          ),
        ),
      ),
      children: [
        DetailRow('Method', 'UPI (Google Pay)'),
        DetailRow('Transaction ID', 'TXN88291039', mono: true),
        DetailRow('Date', 'Dec 15, 2023, 10:42 AM'),
      ],
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;

  DetailRow(this.label, this.value, {super.key, this.mono = false});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6)),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: kMuted)),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: mono ? 'monospace' : null,
            ),
          ),
        ],
      ),
    );
  }
}
