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
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
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
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(15),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.heightPct(0.5)),
                    Text(
                      "Reward top performers",
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                  SizedBox(height: context.heightPct(1.8)),
                  const Divider(color: AppColors.outlineVariant, thickness: 1),
                  SizedBox(height: context.heightPct(1.8)),
                  ...widget.controller.prizeTiers.map((tier) {
                    return PrizeTierWidget(
                      key: ValueKey(tier.id),
                      tier: tier,
                      onDelete: tier.isDefault ? null : () => widget.controller.removeTier(tier.id),
                      onTitleChanged: tier.isDefault ? null : (newTitle) => widget.controller.updateCustomTierTitle(tier.id, newTitle),
                    );
                  }),
                  SizedBox(height: context.heightPct(1.2)),
                  TextButton.icon(
                    onPressed: widget.controller.addCustomTier,
                    icon: Icon(
                      Icons.add_rounded,
                      color: AppColors.accent,
                      size: context.responsiveFont(20),
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Add Another Tier",
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                      backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
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
