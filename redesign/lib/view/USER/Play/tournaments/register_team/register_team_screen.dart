import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../../controller/User_Controller/Tournament_Controller/register_team_controller.dart';
import 'widgets/team_basics_step.dart';
import 'widgets/player_search_step.dart';
import 'widgets/payment_step.dart';

class RegisterTeamScreen extends StatefulWidget {
  final String tournamentId;
  final Map<String, dynamic> tournamentData;
  final String currentUserId;

  const RegisterTeamScreen({
    super.key,
    required this.tournamentId,
    required this.tournamentData,
    required this.currentUserId,
  });

  @override
  State<RegisterTeamScreen> createState() => _RegisterTeamScreenState();
}

class _RegisterTeamScreenState extends State<RegisterTeamScreen> {
  late RegisterTeamController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterTeamController(
      tournamentId: widget.tournamentId,
      tournamentData: widget.tournamentData,
      currentUserId: widget.currentUserId,
    ));
  }

  @override
  void dispose() {
    Get.delete<RegisterTeamController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary),
          onPressed: () {
            if (controller.currentStep.value > 1) {
              controller.previousStep();
            } else {
              Get.back();
            }
          },
        ),
        title: Text("Register Team", style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index < controller.currentStep.value;
                  return Expanded(
                    child: Container(
                      height: ResponsiveHelper.h(4),
                      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(4)),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.accent : AppColors.card,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
                      ),
                    ),
                  );
                }),
              ),
            )),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                child: Obx(() {
                  switch (controller.currentStep.value) {
                    case 1:
                      return PlayerSearchStep(controller: controller);
                    case 2:
                      return TeamBasicsStep(controller: controller);
                    case 3:
                      return PaymentStep(controller: controller);
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),

            // Bottom Nav (Only for steps 1 and 2)
            Obx(() {
              if (controller.currentStep.value < 3) {
                return Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.card)),
                  ),
                  child: Row(
                    children: [
                      if (controller.currentStep.value > 1) ...[
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.outlineVariant),
                              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                            ),
                            onPressed: controller.previousStep,
                            child: Text("BACK", style: AppTypography.labelCaps.copyWith(color: AppColors.onPrimary)),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.w(16)),
                      ],
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                          ),
                          onPressed: controller.nextStep,
                          child: Text("NEXT", style: AppTypography.labelCaps.copyWith(color: AppColors.background)),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
