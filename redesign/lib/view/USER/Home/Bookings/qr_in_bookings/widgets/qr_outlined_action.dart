import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QrOutlinedAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  QrOutlinedAction(
    this.label,
    this.icon, {super.key, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        onTap: onTap,
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(18), vertical: ResponsiveHelper.h(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
