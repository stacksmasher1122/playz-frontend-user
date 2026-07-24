import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomActionWidget extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onSaveTemplate;

  BottomActionWidget({
    super.key,
    required this.onCreate,
    required this.onSaveTemplate,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(16.0),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(
                    alpha: 0.3,
                  ), // Lime Green glow
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
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
              border: Border.all(color: Colors.grey),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onSaveTemplate,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.h(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'SAVE AS TEMPLATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(14),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
