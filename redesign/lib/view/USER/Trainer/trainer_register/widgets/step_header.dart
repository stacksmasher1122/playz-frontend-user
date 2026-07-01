import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;

class StepHeader extends StatelessWidget {
  final int step;
  final String title;
  StepHeader({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        StepIndicator(number: step),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int number;
  StepIndicator({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(26),
      height: ResponsiveHelper.h(26),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: kGreen, shape: BoxShape.circle),
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: ResponsiveHelper.sp(13),
        ),
      ),
    );
  }
}
