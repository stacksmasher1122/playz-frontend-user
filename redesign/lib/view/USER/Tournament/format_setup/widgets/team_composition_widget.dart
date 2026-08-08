import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/format_setup_controller.dart';

class TeamCompositionWidget extends StatelessWidget {
  final FormatSetupController controller;

  const TeamCompositionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Obx(() {
      if (controller.isRacquetSport) {
        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(4.0)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(color: AppColors.borderDark, width: 1.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setTeamMode("singles"),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.h(12.0),
                    ),
                    decoration: BoxDecoration(
                      color: controller.teamMode.value == "singles"
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(10.0),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Singles (1v1)",
                      style: AppTypography.bodyMd.copyWith(
                        color: controller.teamMode.value == "singles"
                            ? Colors.black
                            : AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(14.0),
                        fontWeight: controller.teamMode.value == "singles"
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ).responsive(context),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8.0)),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.setTeamMode("doubles"),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.h(12.0),
                    ),
                    decoration: BoxDecoration(
                      color: controller.teamMode.value == "doubles"
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(10.0),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Doubles (2v2)",
                      style: AppTypography.bodyMd.copyWith(
                        color: controller.teamMode.value == "doubles"
                            ? Colors.black
                            : AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(14.0),
                        fontWeight: controller.teamMode.value == "doubles"
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ).responsive(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (controller.isCombatSport) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16.0),
            vertical: ResponsiveHelper.h(14.0),
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(color: AppColors.borderDark, width: 1.0),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sports_kabaddi_rounded,
                color: AppColors.primary,
                size: ResponsiveHelper.w(22.0),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Individual Combat (1v1)",
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(14.0),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                  SizedBox(height: ResponsiveHelper.h(2.0)),
                  Text(
                    "Standard 1-on-1 bout per registered slot",
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(12.0),
                    ).responsive(context),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        // Team Sports (Football, Cricket, Basketball, Volleyball, Hockey, etc.)
        return Column(
          children: [
            // 1. Players in Each Team Stepper Card
            _buildCounterCard(
              context,
              title: "PLAYERS PER TEAM",
              subtitle: "Starting lineup count per squad",
              count: controller.teamSize.value,
              onIncrement: controller.incrementTeamSize,
              onDecrement: controller.decrementTeamSize,
              icon: Icons.groups_rounded,
            ),
            SizedBox(height: ResponsiveHelper.h(12.0)),

            // 2. Substitutes Toggle Switch Card
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16.0),
                vertical: ResponsiveHelper.h(12.0),
              ),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                border: Border.all(color: AppColors.borderDark, width: 1.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.published_with_changes_rounded,
                    color: AppColors.primary,
                    size: ResponsiveHelper.w(20.0),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ALLOW SUBSTITUTES",
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ).responsive(context),
                        ),
                        SizedBox(height: ResponsiveHelper.h(2.0)),
                        Text(
                          "Permit reserve players on squad bench",
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(12.0),
                          ).responsive(context),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: controller.allowSubstitutes.value,
                    onChanged: controller.toggleSubstitutes,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),

            // 3. No. of Substitutes Stepper Card (Shown when Substitutes Toggle is ON)
            if (controller.allowSubstitutes.value) ...[
              SizedBox(height: ResponsiveHelper.h(12.0)),
              _buildCounterCard(
                context,
                title: "RESERVE SUBSTITUTES",
                subtitle: "Maximum allowed bench players",
                count: controller.substituteCount.value,
                onIncrement: controller.incrementSubstitutes,
                onDecrement: controller.decrementSubstitutes,
                icon: Icons.airline_seat_recline_normal_rounded,
              ),
            ],
          ],
        );
      }
    });
  }

  Widget _buildCounterCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(14.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
        border: Border.all(color: AppColors.borderDark, width: 1.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: ResponsiveHelper.w(20.0),
          ),
          SizedBox(width: ResponsiveHelper.w(12.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(12.0),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ).responsive(context),
                ),
                SizedBox(height: ResponsiveHelper.h(2.0)),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontSize: ResponsiveHelper.sp(12.0),
                  ).responsive(context),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: onDecrement,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                child: Container(
                  width: ResponsiveHelper.w(32.0),
                  height: ResponsiveHelper.w(32.0),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: AppColors.textPrimary,
                    size: ResponsiveHelper.w(18.0),
                  ),
                ),
              ),
              SizedBox(
                width: ResponsiveHelper.w(36.0),
                child: Text(
                  "$count",
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.primary,
                    fontSize: ResponsiveHelper.sp(16.0),
                    fontWeight: FontWeight.w900,
                  ).responsive(context),
                ),
              ),
              InkWell(
                onTap: onIncrement,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                child: Container(
                  width: ResponsiveHelper.w(32.0),
                  height: ResponsiveHelper.w(32.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8.0)),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.black,
                    size: ResponsiveHelper.w(18.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
