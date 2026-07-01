import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class WhyGoProSection extends StatelessWidget {
  WhyGoProSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHY GO PRO?',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(12.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 16),

        WhyGoProItem(
          icon: Icons.verified_rounded,
          title: 'Instant Trust Factor',
          description:
              'Verified profiles get 3x more inquiries from parents. Stand out in search results.',
        ),
        SizedBox(height: 16),

        WhyGoProItem(
          icon: Icons.group_rounded,
          title: 'Zero Commission on Leads',
          description:
              "Direct inquiries from athletes in your area. We don’t charge for connections.",
        ),
        SizedBox(height: 16),

        WhyGoProItem(
          icon: Icons.grid_view_rounded,
          title: 'Automated Management',
          description:
              'Track attendance, payments, and schedule sessions without the spreadsheet headache.',
        ),
      ],
    );
  }
}

class WhyGoProItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  WhyGoProItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: ResponsiveHelper.h(36),
          width: ResponsiveHelper.w(36),
          decoration: BoxDecoration(
            color: kGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
          ),
          child: Icon(icon, size: 18, color: kGreen),
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
                  fontSize: ResponsiveHelper.sp(14.5),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: kMuted,
                  fontSize: ResponsiveHelper.sp(13),
                  height: ResponsiveHelper.h(1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
