import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProfessionalMatchControls extends StatelessWidget {
  final VoidCallback onLet;
  final VoidCallback onConduct;
  final VoidCallback onTimeout;

  const ProfessionalMatchControls({
    super.key,
    required this.onLet,
    required this.onConduct,
    required this.onTimeout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlButton(Icons.replay, "Let", onLet),
          SizedBox(width: ResponsiveHelper.w(16)),
          _buildControlButton(Icons.gavel, "Conduct", onConduct),
          SizedBox(width: ResponsiveHelper.w(16)),
          _buildControlButton(Icons.medical_services, "Timeout", onTimeout),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(color: AppColors.muted.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.muted, size: 16),
            SizedBox(width: ResponsiveHelper.w(6)),
            Text(
              label,
              style: AppTypography.labelCaps.copyWith(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
