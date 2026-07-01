import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);

class ProValueCard extends StatelessWidget {
  ProValueCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGreen.withValues(alpha: 0.25), Colors.black],
        ),
        border: Border.all(color: kGreen.withValues(alpha: 0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: kGreen.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ───── Header Row ─────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Icon badge
              Container(
                height: ResponsiveHelper.h(40),
                width: ResponsiveHelper.w(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGreen.withValues(alpha: 0.18),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  color: kGreen,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),

              /// Title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grow Your Business',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Get verified, manage students, and receive secure payouts directly to your bank account.',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: ResponsiveHelper.sp(13.5),
                        height: ResponsiveHelper.h(1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          /// ───── Metrics ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProValueMetric(value: '5k+', label: 'TRAINERS'),
              ProValueMetric(value: '₹10Cr+', label: 'PAID OUT'),
              ProValueMetric(value: '100%', label: 'SECURE'),
            ],
          ),
        ],
      ),
    );
  }
}

class ProValueMetric extends StatelessWidget {
  final String value;
  final String label;

  ProValueMetric({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(15.5),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(11),
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
