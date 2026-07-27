import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
          padding: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Card Container
              InkWell(
                onTap: () => onPlanSelected(plan.id),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF141C16) : const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.08),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.title,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.sp(20),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (plan.savingsTag != null) ...[
                                SizedBox(height: ResponsiveHelper.h(2)),
                                Text(
                                  plan.savingsTag!,
                                  style: GoogleFonts.inter(
                                    color: AppColors.accent,
                                    fontSize: ResponsiveHelper.sp(12),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
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
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.sp(22),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  if (plan.periodText.isNotEmpty)
                                    Text(
                                      plan.periodText,
                                      style: GoogleFonts.inter(
                                        color: AppColors.muted,
                                        fontSize: ResponsiveHelper.sp(12),
                                      ),
                                    ),
                                ],
                              ),
                              if (plan.equivalentText != null) ...[
                                SizedBox(height: ResponsiveHelper.h(2)),
                                Text(
                                  plan.equivalentText!,
                                  style: GoogleFonts.inter(
                                    color: AppColors.muted,
                                    fontSize: ResponsiveHelper.sp(11),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),

                      // Inner Savings Banner (for Annual)
                      if (plan.bottomSavingsBanner != null) ...[
                        SizedBox(height: ResponsiveHelper.h(12)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.h(8),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2B22),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              plan.bottomSavingsBanner!,
                              style: GoogleFonts.inter(
                                color: AppColors.accent,
                                fontSize: ResponsiveHelper.sp(12),
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
                        horizontal: ResponsiveHelper.w(14),
                        vertical: ResponsiveHelper.h(3),
                      ),
                      decoration: BoxDecoration(
                        color: plan.isBestValue ? AppColors.accent : const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(20),
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
                        style: GoogleFonts.inter(
                          color: plan.isBestValue ? Colors.black : Colors.white,
                          fontSize: ResponsiveHelper.sp(10),
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
