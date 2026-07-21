import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoringConsole extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onPointSideA;
  final VoidCallback onPointSideB;

  ScoringConsole({
    super.key,
    required this.onUndo,
    required this.onPointSideA,
    required this.onPointSideB,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(32))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _actionButton(
                  'UNDO',
                  Icons.undo_rounded,
                  Colors.white24,
                  onUndo,
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      _pointButton(
                        '+1 SIDE A',
                        AppColors.error.withValues(alpha: 0.2),
                        onPointSideA,
                        textColor: AppColors.error,
                      ),
                      SizedBox(width: 12),
                      _pointButton(
                        '+1 SIDE B',
                        AppColors.primary.withValues(alpha: 0.2),
                        onPointSideB,
                        textColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color bg,
    VoidCallback onTap, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          ),
          child: Column(
            children: [
              Icon(icon, color: textColor, size: 20),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pointButton(
    String label,
    Color bg,
    VoidCallback onTap, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            border: Border.all(color: textColor.withValues(alpha: 0.5), width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
