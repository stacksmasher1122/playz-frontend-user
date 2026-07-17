import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MsAppbarWidget extends StatelessWidget {
  MsAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(40),
                    height: ResponsiveHelper.h(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accent, width: 1),
                      image: DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=40'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'PlayZ Match',
                        style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.w700, color: AppColors.accent, height: 1.1),
                      ),
                      Text(
                        'Center',
                        style: TextStyle(fontFamily: 'Sora', fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.w700, color: AppColors.accent, height: 1.1),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.settings, color: AppColors.muted, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
