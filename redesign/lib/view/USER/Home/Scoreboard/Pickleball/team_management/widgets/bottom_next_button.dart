import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BottomNextButton extends StatelessWidget {
  final VoidCallback onTap;

  BottomNextButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: AppColors.background, // Match scaffold bg
      padding: EdgeInsets.all(ResponsiveHelper.w(16)).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: ResponsiveHelper.h(56),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(28)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NEXT',
                style: AppTypography.headlineMd.copyWith(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.black, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
