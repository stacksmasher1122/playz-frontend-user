import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/prize_pool_controller.dart';
import 'common_switch.dart';
import 'prize_tier_widget.dart';

class PrizePoolCard extends StatefulWidget {
  final PrizePoolController controller;

  const PrizePoolCard({super.key, required this.controller});

  @override
  State<PrizePoolCard> createState() => _PrizePoolCardState();
}

class _PrizePoolCardState extends State<PrizePoolCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Prize Pool",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      "Reward top performers",
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => CommonSwitch(
                value: widget.controller.hasPrizePool.value,
                onChanged: widget.controller.togglePrizePool,
              )),
            ],
          ),
          Obx(() {
            if (widget.controller.hasPrizePool.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: ResponsiveHelper.h(16)),
                  Divider(color: AppColors.outlineVariant, thickness: 1),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  ...widget.controller.prizeTiers.map((tier) {
                    return PrizeTierWidget(
                      key: ValueKey(tier.id),
                      tier: tier,
                      onDelete: tier.isDefault ? null : () => widget.controller.removeTier(tier.id),
                      onTitleChanged: tier.isDefault ? null : (newTitle) => widget.controller.updateCustomTierTitle(tier.id, newTitle),
                    );
                  }),
                  SizedBox(height: ResponsiveHelper.h(12)),
                  TextButton.icon(
                    onPressed: widget.controller.addCustomTier,
                    icon: Icon(Icons.add, color: AppColors.accent),
                    label: Text(
                      "Add Another Tier",
                      style: AppTypography.bodyLg.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
