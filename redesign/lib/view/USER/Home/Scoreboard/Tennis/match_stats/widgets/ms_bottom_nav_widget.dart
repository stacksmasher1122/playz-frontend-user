import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MsBottomNavWidget extends StatelessWidget {
  MsBottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: EdgeInsets.only(left: ResponsiveHelper.w(16), right: ResponsiveHelper.w(16), bottom: ResponsiveHelper.h(16), top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTab(
                  icon: Icons.settings_applications,
                  label: 'Setup',
                  isActive: false,
                  onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                ),
                _buildTab(
                  icon: Icons.sports_tennis,
                  label: 'Live',
                  isActive: false,
                  onTap: () => Navigator.pop(context),
                ),
                _buildTab(
                  icon: Icons.equalizer,
                  label: 'Stats',
                  isActive: true,
                  onTap: () {},
                ),
                _buildTab(
                  icon: Icons.description,
                  label: 'Summary',
                  isActive: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      hoverColor: AppColors.surfaceBright.withValues(alpha: 0.1),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          if (isActive)
            Positioned(
              top: ResponsiveHelper.h(0),
              left: -10,
              right: -10,
              child: Container(height: ResponsiveHelper.h(2), color: AppColors.primaryContainer),
            ),
          Padding(
            padding: EdgeInsets.only(top: ResponsiveHelper.h(8), left: ResponsiveHelper.w(16), right: ResponsiveHelper.w(16), bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.labelCaps.copyWith(
                    color: isActive ? AppColors.primaryContainer : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
