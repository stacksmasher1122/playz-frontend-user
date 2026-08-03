import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomActionWidget extends StatelessWidget {
  final VoidCallback onCreate;

  const BottomActionWidget({
    super.key,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(16.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(
                alpha: 0.3,
              ),
              blurRadius: 16,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onCreate,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveHelper.h(16),
              ),
              decoration: BoxDecoration(
                color: AppColors.accent, // Lime Green
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sports_soccer,
                    color: AppColors.background,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'CREATE MATCH',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: ResponsiveHelper.sp(14),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
