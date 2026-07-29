import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../../controller/User_Controller/Tournament_Controller/register_team_controller.dart';
import '../../../../Tournament/create_tournament_prize_pool/widget/common_textfield.dart';

class TeamBasicsStep extends StatelessWidget {
  final RegisterTeamController controller;

  const TeamBasicsStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final logoSize = context.minDimensionPct(28).clamp(90.0, 130.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team Name",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(15),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1.5)),
        CommonTextField(
          controller: controller.teamNameController,
          hintText: "e.g. Neon Panthers",
          prefixIcon: const Icon(Icons.shield_outlined, color: AppColors.accent),
        ),
        SizedBox(height: context.heightPct(3.5)),

        Text(
          "Team Logo (Optional)",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(15),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.heightPct(1.5)),
        Center(
          child: GestureDetector(
            onTap: controller.pickTeamLogo,
            child: Obx(() {
              final path = controller.teamLogoPath.value;
              return Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderDark),
                  image: path.isNotEmpty
                      ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover)
                      : null,
                ),
                child: path.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.muted,
                            size: logoSize * 0.28,
                          ),
                          SizedBox(height: context.heightPct(0.5)),
                          Text(
                            "Upload",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(11),
                            ),
                          ),
                        ],
                      )
                    : null,
              );
            }),
          ),
        ),
      ],
    );
  }
}
