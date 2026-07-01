import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFFFC107);
const kSurface = AppColors.surface;

class PackagePurchasedCard extends StatelessWidget {
  PackagePurchasedCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border(
          left: BorderSide(color: kGreen, width: 3),
        ),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PACKAGE PURCHASED',
            style: TextStyle(
              color: kGreen,
              fontSize: ResponsiveHelper.sp(11),
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1-Day Trial Access',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: kMuted),
              SizedBox(width: 6),
              Text('Valid for 24 Hours',
                  style: TextStyle(color: kMuted)),
            ],
          ),

          Divider(color: Colors.grey),

          _infoRow('Amount Paid', '₹150.00'),
          _infoRow('Rewards Earned', '+15 Z Coins',
              valueColor: kYellow),

          SizedBox(height: 8),

          Row(
            children: [
              Text('Transaction ID',
                  style: TextStyle(color: kMuted, fontSize: 12)),
              Spacer(),
              Text(
                '#TXN882901',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              PackageFeatureChip(label: 'Kit Provided'),
              PackageFeatureChip(label: '1 Hr Net Practice'),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {Color valueColor = Colors.white}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(4)),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: kMuted)),
          Spacer(),
          Text(value,
              style: TextStyle(
                  color: valueColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class PackageFeatureChip extends StatelessWidget {
  final String label;
  PackageFeatureChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(12),
        ),
      ),
    );
  }
}
