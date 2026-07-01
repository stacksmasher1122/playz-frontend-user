import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_dimensions.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SmAppbarWidget extends StatelessWidget {
  SmAppbarWidget({super.key});

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
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
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
                      border: Border.all(
                        color: AppColors.primaryContainer,
                        width: ResponsiveHelper.w(1),
                      ),
                    ),
                    child: ClipOval(
                      // Mock profile image
                      child: Image.network(
                        'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=40',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.md),
                  Text(
                    'PlayZ Match Center',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: ResponsiveHelper.sp(24),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  print('Settings tapped');
                },
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                hoverColor: AppColors.primaryContainer.withValues(alpha: 0.1),
                child: Container(
                  width: ResponsiveHelper.w(40),
                  height: ResponsiveHelper.h(40),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.settings, // Fallback for material_symbols_outlined settings
                    color: AppColors.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
