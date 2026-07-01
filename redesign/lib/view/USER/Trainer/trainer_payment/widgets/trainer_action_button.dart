import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kBg = AppColors.background;

class TrainerActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  TrainerActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
        splashColor: kGreen.withValues(alpha: 0.15),
        highlightColor: kGreen.withValues(alpha: 0.08),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
            border: Border.all(color: kGreen, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: kGreen.withValues(alpha: 0.25),
                blurRadius: 12,
                spreadRadius: -6,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: kBg, size: 20),
                SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(
                  color: kBg,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
