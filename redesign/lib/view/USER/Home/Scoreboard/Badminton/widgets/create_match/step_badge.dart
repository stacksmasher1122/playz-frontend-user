import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StepBadge extends StatelessWidget {
  StepBadge({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveHelper.w(4)),
          topRight: Radius.circular(ResponsiveHelper.w(16)),
          bottomLeft: Radius.circular(ResponsiveHelper.w(16)),
          bottomRight: Radius.circular(ResponsiveHelper.w(4)),
        ),
      ),
      child: Text(
        "STEP 01",
        style: TextStyle(
          color: Colors.black,
          fontSize: ResponsiveHelper.sp(10),
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
