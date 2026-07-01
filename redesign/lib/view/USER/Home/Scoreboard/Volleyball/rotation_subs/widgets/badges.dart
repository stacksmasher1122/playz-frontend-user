import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class ServerBadge extends StatelessWidget {
  const ServerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('SVR', style: AppTypography.labelCaps10.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 8)),
    );
  }
}

class LiberoBadge extends StatelessWidget {
  const LiberoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('LIB', style: AppTypography.labelCaps10.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8)),
    );
  }
}

class CaptainBadge extends StatelessWidget {
  const CaptainBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Text('C', style: AppTypography.labelCaps10.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 8)),
    );
  }
}
