import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardScopeToggle extends StatelessWidget {
  final String selectedScope;
  final ValueChanged<String> onScopeChanged;

  const LeaderboardScopeToggle({
    super.key,
    required this.selectedScope,
    required this.onScopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final scopes = const ['Global', 'Friends', 'Groups'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      padding: EdgeInsets.all(context.widthPct(1)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: scopes.map((scope) {
          final isSelected = scope == selectedScope;
          return Expanded(
            child: InkWell(
              onTap: () => onScopeChanged(scope),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: context.heightPct(1.2)),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Center(
                  child: Text(
                    scope,
                    style: AppTypography.headlineSm.copyWith(
                      color: isSelected ? AppColors.background : AppColors.textSecondary,
                      fontSize: context.responsiveFont(13),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
