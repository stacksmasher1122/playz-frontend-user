import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_success_simple_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class NextStepsCard extends StatelessWidget {
  NextStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FeeSuccessSimpleCard(
      title: 'NEXT STEPS',
      children: [
        StepRow(
          step: '1',
          title: 'Complete Your Profile',
          subtitle: 'Add photos and bio to attract students',
        ),
        StepRow(
          step: '2',
          title: 'Set Availability',
          subtitle: 'Define your training slots',
        ),
        StepRow(
          step: '3',
          title: 'Start Accepting Students',
          subtitle: 'Reply to incoming leads',
        ),
      ],
    );
  }
}

class StepRow extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;

  StepRow({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: ResponsiveHelper.h(28),
            width: ResponsiveHelper.w(28),
            decoration: BoxDecoration(
              color: kGreen,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: kMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
