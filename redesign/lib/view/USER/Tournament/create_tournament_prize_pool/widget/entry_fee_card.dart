import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/prize_pool_controller.dart';
import 'common_switch.dart';
import 'common_textfield.dart';

class EntryFeeCard extends StatefulWidget {
  final PrizePoolController controller;

  const EntryFeeCard({super.key, required this.controller});

  @override
  State<EntryFeeCard> createState() => _EntryFeeCardState();
}

class _EntryFeeCardState extends State<EntryFeeCard> {
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
                      "Registration Fee",
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
                      "Charge teams to enter the tournament",
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
                value: widget.controller.hasEntryFee.value,
                onChanged: widget.controller.toggleEntryFee,
              )),
            ],
          ),
          Obx(() {
            if (widget.controller.hasEntryFee.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.heightPct(1.8)),
                  const Divider(color: AppColors.outlineVariant, thickness: 1),
                  SizedBox(height: context.heightPct(1.8)),
                  Text(
                    "Entry Fee per Team",
                    style: AppTypography.bodyLg.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.heightPct(1)),
                  CommonTextField(
                    controller: widget.controller.entryFeeController,
                    hintText: "0.00",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(
                      Icons.attach_money_rounded,
                      color: AppColors.muted,
                      size: context.responsiveFont(20),
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
