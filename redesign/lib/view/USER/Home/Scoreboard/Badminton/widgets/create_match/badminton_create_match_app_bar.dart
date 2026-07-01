import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BadmintonCreateMatchAppBar extends StatelessWidget {
  BadmintonCreateMatchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 8),
              Text(
                "MATCH CENTER",
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "NEW MATCH",
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.timer_outlined, color: AppColors.muted, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
