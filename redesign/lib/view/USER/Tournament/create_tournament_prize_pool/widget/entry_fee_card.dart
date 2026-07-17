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
                      "Registration Fee",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4)),
                    Text(
                      "Charge teams to enter the tournament",
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                      ),
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
                children: [
                  SizedBox(height: ResponsiveHelper.h(16)),
                  Divider(color: AppColors.outlineVariant, thickness: 1),
                  SizedBox(height: ResponsiveHelper.h(16)),
                  Text(
                    "Entry Fee per Team",
                    style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary),
                  ),
                  SizedBox(height: ResponsiveHelper.h(8)),
                  CommonTextField(
                    controller: widget.controller.entryFeeController,
                    hintText: "0.00",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(Icons.attach_money, color: AppColors.muted),
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
