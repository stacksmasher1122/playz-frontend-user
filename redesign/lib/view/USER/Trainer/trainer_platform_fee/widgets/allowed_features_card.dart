import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'fee_card_wrapper.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;

class AllowedFeaturesCard extends StatelessWidget {
  AllowedFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FeeCardWrapper(
      title: 'WHAT YOU CAN DO',
      children: [
        CheckRow('Complete your trainer profile'),
        CheckRow('Upload certifications & details'),
        CheckRow('Set availability & pricing'),
        CheckRow('Access help & support'),
      ],
    );
  }
}

class CheckRow extends StatelessWidget {
  final String text;
  CheckRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle,
              color: kGreen, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
