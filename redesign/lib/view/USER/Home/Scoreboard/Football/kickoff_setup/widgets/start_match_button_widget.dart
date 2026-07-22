import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StartMatchButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  StartMatchButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(16.0)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'INITIALIZE DATA STREAM',
                        style: TextStyle(
                          color: AppColors.background.withValues(alpha: 0.6),
                          fontSize: ResponsiveHelper.sp(8),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'START MATCH',
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: ResponsiveHelper.sp(22),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'By starting, you confirm all player\nregistrations and venue synchronization protocols.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              height: ResponsiveHelper.h(1.5),
            ),
          ),
        ],
      ),
    );
  }
}
