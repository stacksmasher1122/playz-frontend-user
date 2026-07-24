import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerStatusChip extends StatelessWidget {
  final String status;

  PlayerStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    bool isFit = status.toLowerCase() == 'fit';

    return Text(
      status.toUpperCase(),
      style: TextStyle(
        color: isFit ? AppColors.accent : Colors.red,
        fontSize: ResponsiveHelper.sp(12),
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }
}
