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
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () {
            if (controller.currentStep.value > 1) {
              controller.previousStep();
            } else {
              Get.back();
            }
          },
        ),
        title: Text(
          "Register Team",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            Obx(() => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4),
                vertical: context.heightPct(1.5),
              ),
              child: Row(
                children: List.generate(3, (index) {
                  final isActive = index < controller.currentStep.value;
                  return Expanded(
                    child: Container(
                      height: context.heightPct(0.5).clamp(4.0, 6.0),
                      margin: EdgeInsets.symmetric(horizontal: context.widthPct(1)),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.accent : AppColors.card,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                      ),
                    ),
                  );
                }),
              ),
            )),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.widthPct(4)),
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
                  padding: EdgeInsets.all(context.widthPct(4)),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.borderDark)),
                  ),
                  child: Row(
                    children: [
                      if (controller.currentStep.value > 1) ...[
                        Expanded(
                          child: SizedBox(
                            height: context.heightPct(6).clamp(48.0, 54.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.borderDark),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                                ),
                              ),
                              onPressed: controller.previousStep,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "BACK",
                                  style: AppTypography.labelCaps10.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.responsiveFont(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: context.widthPct(3)),
                      ],
                      Expanded(
                        flex: 2,
                        child: Obx(() {
                          final bool canProceed = controller.currentStep.value != 1 || controller.isRosterFull;
                          return SizedBox(
                            height: context.heightPct(6).clamp(48.0, 54.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canProceed ? AppColors.accent : AppColors.muted.withValues(alpha: 0.3),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                                ),
                              ),
                              onPressed: canProceed ? controller.nextStep : null,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  controller.currentStep.value == 1 && !controller.isRosterFull
                                      ? "${controller.remainingSlots} MORE NEEDED"
                                      : "NEXT",
                                  style: AppTypography.labelCaps10.copyWith(
                                    color: canProceed ? AppColors.background : AppColors.muted,
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.responsiveFont(14),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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
