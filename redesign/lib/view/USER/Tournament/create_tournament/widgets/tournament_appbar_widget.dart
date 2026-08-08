import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';

class TournamentAppbarWidget extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onClose;

  const TournamentAppbarWidget({
    super.key,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Common App Back Button
          AppBackButton(onPressed: onBack),

          // Header Title
          Text(
            "Create Tournament",
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.primary,
              fontSize: ResponsiveHelper.sp(18.0),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ).responsive(context),
          ),

          // Common Circular Green Close Button (✕)
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
            child: Container(
              width: ResponsiveHelper.w(36.0),
              height: ResponsiveHelper.w(36.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.card,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.close_rounded,
                color: AppColors.primaryGreen,
                size: ResponsiveHelper.w(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
