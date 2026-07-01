import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class MvpCardWidget extends StatelessWidget {
  final String teamName;
  final String winRate;

  const MvpCardWidget({
    super.key,
    required this.teamName,
    required this.winRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.military_tech,
              color: AppColors.surfaceContainerHighest.withOpacity(0.3),
              size: 100,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEAM OF THE MATCH (MVP)',
                style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 72,
                    height: 48,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: _buildAvatar(),
                        ),
                        Positioned(
                          left: 24,
                          child: _buildAvatar(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(teamName, style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
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
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.card, width: 2),
      ),
      child: const CircleAvatar(
        radius: 22,
        backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
      ),
    );
  }
}
