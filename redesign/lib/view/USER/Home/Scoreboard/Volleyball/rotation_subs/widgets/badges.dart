import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ServerBadge extends StatelessWidget {
  ServerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4), vertical: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
      ),
      child: Text('SVR', style: AppTypography.labelCaps10.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 8)),
    );
  }
}

class LiberoBadge extends StatelessWidget {
  LiberoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4), vertical: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
      ),
      child: Text('LIB', style: AppTypography.labelCaps10.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8)),
    );
  }
}

class CaptainBadge extends StatelessWidget {
  CaptainBadge({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(2)),
      decoration: BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
      child: Text('C', style: AppTypography.labelCaps10.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 8)),
    );
  }
}
