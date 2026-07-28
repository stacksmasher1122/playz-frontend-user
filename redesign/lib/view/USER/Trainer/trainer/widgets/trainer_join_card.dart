import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrainerJoinCard extends StatelessWidget {
  final VoidCallback onTap;

  const TrainerJoinCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final iconContainerSize = context.minDimensionPct(11).clamp(38.0, 48.0);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        onTap: onTap,
        splashColor: AppColors.accent.withValues(alpha: 0.15),
        highlightColor: AppColors.accent.withValues(alpha: 0.08),
        child: Container(
          padding: EdgeInsets.all(context.widthPct(4)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.accent.withValues(alpha: 0.18),
                AppColors.background,
              ],
            ),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.18),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT ICON
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.2),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.accent,
                  size: iconContainerSize * 0.5,
                ),
              ),

              SizedBox(width: context.widthPct(3.5)),

              /// TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you a Trainer?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(15),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.4)),
                    Text(
                      'Join us to manage sessions, earnings, and your player roster — all in one dashboard.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: context.responsiveFont(12),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: context.widthPct(3)),

              /// CTA BUTTON
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(3.5),
                  vertical: context.heightPct(1),
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                  border: Border.all(color: AppColors.accent, width: 1),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Register',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.background,
                      fontSize: context.responsiveFont(12.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
