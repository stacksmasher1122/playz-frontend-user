import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'setup_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupQualityIndicator extends StatelessWidget {
  final double progress;

  SetupQualityIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Setup Quality",
                style: TextStyle(
                  color: kTextSecondary,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (progress >= 1.0)
                    Icon(Icons.verified, color: kAccent, size: 14),
                  SizedBox(width: 4),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: progress >= 1.0 ? kAccent : kWarning,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: kSurfaceHighlight,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0 ? kAccent : kWarning,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
