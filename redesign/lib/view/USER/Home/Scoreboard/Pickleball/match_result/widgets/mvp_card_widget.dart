import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MvpCardWidget extends StatelessWidget {
  final String teamName;
  final String winRate;

  MvpCardWidget({
    super.key,
    required this.teamName,
    required this.winRate,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.military_tech,
              color: AppColors.outlineVariant.withOpacity(0.3),
              size: 100,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEAM OF THE MATCH (MVP)',
                style: AppTypography.labelCaps10.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: ResponsiveHelper.w(72),
                    height: ResponsiveHelper.h(48),
                    child: Stack(
                      children: [
                        Positioned(
                          left: ResponsiveHelper.w(0),
                          child: _buildAvatar(),
                        ),
                        Positioned(
                          left: ResponsiveHelper.w(24),
                          child: _buildAvatar(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teamName, style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold)),
                      Text(winRate, style: AppTypography.bodySm.copyWith(color: AppColors.muted)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: ResponsiveHelper.w(48),
      height: ResponsiveHelper.h(48),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.card, width: 2),
      ),
      child: CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
      ),
    );
  }
}
