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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Team Name",
          style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        CommonTextField(
          controller: controller.teamNameController,
          hintText: "e.g. Neon Panthers",
          prefixIcon: Icon(Icons.shield, color: AppColors.muted),
        ),
        SizedBox(height: ResponsiveHelper.h(32)),

        Text(
          "Team Logo (Optional)",
          style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
        ),
        SizedBox(height: ResponsiveHelper.h(12)),
        Center(
          child: GestureDetector(
            onTap: controller.pickTeamLogo,
            child: Obx(() {
              final path = controller.teamLogoPath.value;
              return Container(
                width: ResponsiveHelper.w(120),
                height: ResponsiveHelper.w(120),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outlineVariant),
                  image: path.isNotEmpty
                      ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover)
                      : null,
                ),
                child: path.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: AppColors.muted, size: ResponsiveHelper.w(32)),
                          SizedBox(height: ResponsiveHelper.h(4)),
                          Text("Upload", style: AppTypography.labelCaps.copyWith(color: AppColors.muted)),
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
