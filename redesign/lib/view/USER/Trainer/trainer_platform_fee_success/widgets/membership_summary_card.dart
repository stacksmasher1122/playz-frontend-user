import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kMuted = Color(0xFFA7A7A7);
const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);

class MembershipSummaryCard extends StatelessWidget {
  MembershipSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: kGreen.withValues(alpha: 0.4)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'MEMBERSHIP ACTIVE',
                style: TextStyle(
                  color: kMuted,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Spacer(),
              Icon(Icons.verified_rounded, color: kGreen, size: 18),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Trainer Pro – 1 Year',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 16, color: kGreen),
              SizedBox(width: 6),
              Text('Valid until Dec 15, 2024', style: TextStyle(color: kGreen)),
            ],
          ),
          SizedBox(height: 16),
          PriceRow(label: 'Plan Price', value: '₹4,999.00'),
          PriceRow(label: 'GST (18%)', value: '₹899.82'),
          Divider(color: kCard),
          PriceRow(
            label: 'Total Charged',
            value: '₹5,898.82',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6)),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: highlight ? Colors.white : kMuted),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? kGreen : Colors.white,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              fontSize: highlight ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
