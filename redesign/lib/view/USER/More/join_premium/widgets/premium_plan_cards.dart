import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/join_premium_model.dart';

class PremiumPlanCards extends StatelessWidget {
  final List<PremiumPlanModel> plans;
  final String selectedPlanId;
  final ValueChanged<String> onPlanSelected;

  const PremiumPlanCards({
    super.key,
    required this.plans,
    required this.selectedPlanId,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: plans.map((plan) {
        final isSelected = plan.id == selectedPlanId;

        return Padding(
          padding: EdgeInsets.only(bottom: context.heightPct(2)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Card Container
              InkWell(
                onTap: () => onPlanSelected(plan.id),
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.all(context.widthPct(4)),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : AppColors.borderDark,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side: Title & Savings Tag
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.title,
                                  style: AppTypography.headlineSm.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: context.responsiveFont(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (plan.savingsTag != null) ...[
                                  SizedBox(height: context.heightPct(0.3)),
                                  Text(
                                    plan.savingsTag!,
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.accent,
                                      fontSize: context.responsiveFont(12),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Right side: Price & Period / Equivalent Text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    plan.priceText,
                                    style: AppTypography.displayLg.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: context.responsiveFont(22),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  if (plan.periodText.isNotEmpty)
                                    Text(
                                      plan.periodText,
                                      style: AppTypography.bodySm.copyWith(
                                        color: AppColors.muted,
                                        fontSize: context.responsiveFont(12),
                                      ),
                                    ),
                                ],
                              ),
                              if (plan.equivalentText != null) ...[
                                SizedBox(height: context.heightPct(0.3)),
                                Text(
                                  plan.equivalentText!,
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.muted,
                                    fontSize: context.responsiveFont(11),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),

                      // Inner Savings Banner (for Annual)
                      if (plan.bottomSavingsBanner != null) ...[
                        SizedBox(height: context.heightPct(1.5)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: context.heightPct(1),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                          ),
                          child: Center(
                            child: Text(
                              plan.bottomSavingsBanner!,
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(12),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Badge Tag Pill at Top Center (BEST VALUE / MOST POPULAR)
              if (plan.badgeTag != null)
                Positioned(
                  top: -12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3.5),
                        vertical: context.heightPct(0.4),
                      ),
                      decoration: BoxDecoration(
                        color: plan.isBestValue ? AppColors.accent : AppColors.card,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                        boxShadow: plan.isBestValue
                            ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        plan.badgeTag!,
                        style: AppTypography.labelCaps10.copyWith(
                          color: plan.isBestValue ? AppColors.background : AppColors.textPrimary,
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
