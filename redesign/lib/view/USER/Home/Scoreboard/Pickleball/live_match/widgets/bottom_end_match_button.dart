import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class BottomEndMatchButton extends StatelessWidget {
  final VoidCallback onTap;

  const BottomEndMatchButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF8B0000), // Dark red as requested for warning/serious tone
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'END MATCH',
              style: AppTypography.headlineMd.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
