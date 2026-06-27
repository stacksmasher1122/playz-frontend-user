import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;

class StepHeader extends StatelessWidget {
  final int step;
  final String title;
  const StepHeader({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StepIndicator(number: step),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int number;
  const StepIndicator({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: kGreen, shape: BoxShape.circle),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
