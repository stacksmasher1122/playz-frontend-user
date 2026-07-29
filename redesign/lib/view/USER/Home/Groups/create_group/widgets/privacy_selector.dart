import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PrivacySelector extends StatelessWidget {
  final bool isPublic;
  final Function(bool) onPrivacyChanged;

  const PrivacySelector({
    super.key,
    required this.isPublic,
    required this.onPrivacyChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Expanded(
          child: _PrivacyCard(
            title: 'Public',
            icon: Icons.public,
            isPublicCard: true,
            isSelected: isPublic,
            onTap: () => onPrivacyChanged(true),
          ),
        ),
        SizedBox(width: context.widthPct(4)),
        Expanded(
          child: _PrivacyCard(
            title: 'Private',
            icon: Icons.lock,
            isPublicCard: false,
            isSelected: !isPublic,
            onTap: () => onPrivacyChanged(false),
          ),
        ),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPublicCard;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrivacyCard({
    required this.title,
    required this.icon,
    required this.isPublicCard,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.heightPct(2.5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.borderDark,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.muted,
              size: 24,
            ),
            SizedBox(height: context.heightPct(1)),
            Text(
              title,
              style: AppTypography.headlineSm.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.muted,
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
