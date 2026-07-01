import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ActionChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool outlined;

  ActionChipWidget(
    this.icon,
    this.label, {
    this.onTap,
    this.outlined = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final borderColor = outlined
        ? Colors.white.withValues(alpha: 0.35)
        : Colors.transparent;

    final backgroundColor = outlined
        ? Colors.transparent
        : Colors.white.withValues(alpha: 0.08);

    final contentColor = Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(10)),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: contentColor),
              SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: contentColor,
                  fontSize: ResponsiveHelper.sp(13),
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
