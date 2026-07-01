import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_success_simple_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;

class BenefitsUnlockedCard extends StatelessWidget {
  BenefitsUnlockedCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FeeSuccessSimpleCard(
      title: 'BENEFITS UNLOCKED',
      children: [
        BenefitRow('Verified Trainer Badge Activated'),
        BenefitRow('Public Profile is Now Live'),
        BenefitRow('Student Leads Enabled'),
        BenefitRow('Analytics Dashboard Access'),
      ],
    );
  }
}

class BenefitRow extends StatelessWidget {
  final String text;
  BenefitRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: ResponsiveHelper.h(28),
            width: ResponsiveHelper.w(28),
            decoration: BoxDecoration(
              color: kGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, size: 16, color: kGreen),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
