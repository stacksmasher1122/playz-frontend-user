import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);
const kCard = Color(0xFF1A1A1A);

class ProFaqSection extends StatelessWidget {
  ProFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FREQUENTLY ASKED QUESTIONS',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(12.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 12),
        FaqTile(
          question: 'How do payouts work?',
          answer:
              'Payouts are processed securely and deposited directly into your bank account.',
        ),
        FaqTile(
          question: 'Can I upgrade my plan later?',
          answer: 'Yes, you can upgrade anytime and only pay the difference.',
        ),
        FaqTile(
          question: 'Is my data secure?',
          answer: 'We use bank-grade security and encrypted storage.',
        ),
        FaqTile(
          question: 'Do you provide students?',
          answer:
              'We help you get discovered. Direct inquiries depend on your profile and activity.',
        ),
      ],
    );
  }
}

class FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  FaqTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      collapsedBackgroundColor: kCard,
      backgroundColor: kCard,
      iconColor: kGreen,
      collapsedIconColor: kMuted,
      title: Text(
        question,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(color: kMuted, height: 1.4),
          ),
        ),
      ],
    );
  }
}
