import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'match_text_field.dart';
import 'match_dropdown.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchCoreCard extends StatelessWidget {
  final PickleballInitializeMatchController controller;
  final TextEditingController nameController;
  final TextEditingController courtController;
  final TextEditingController refereeController;

  MatchCoreCard({
    super.key,
    required this.controller,
    required this.nameController,
    required this.courtController,
    required this.refereeController,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
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
            children: [
              Container(
                width: ResponsiveHelper.w(20),
                height: ResponsiveHelper.h(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.warning, width: 2),
                ),
                child: Center(
                  child: Text('i', style: TextStyle(color: AppColors.warning, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(width: 8),
              Text('Match Core Details', style: AppTypography.headlineMd),
            ],
          ),
          SizedBox(height: 16),
          MatchTextField(
            label: "Match Name",
            hint: "e.g., Quarter-Finals: Masters Open",
            controller: nameController,
          ),
          SizedBox(height: 16),
          Obx(() => MatchDropdown(
            label: "Tournament (Optional)",
            hint: "Select Tournament",
            value: controller.selectedTournament.value,
            options: controller.tournamentOptions,
            onChanged: (v) {
              if (v != null) controller.selectedTournament.value = v;
            },
          )),
          SizedBox(height: 16),
          MatchTextField(
            label: "Court Number",
            hint: "Court #",
            controller: courtController,
          ),
          SizedBox(height: 16),
          Obx(() => MatchTextField(
            label: "Date & Time",
            hint: controller.selectedDate.value == null 
                ? "dd-mm-yyyy --:--" 
                : "${controller.selectedDate.value!.day.toString().padLeft(2, '0')}-${controller.selectedDate.value!.month.toString().padLeft(2, '0')}-${controller.selectedDate.value!.year} ${controller.selectedDate.value!.hour.toString().padLeft(2, '0')}:${controller.selectedDate.value!.minute.toString().padLeft(2, '0')}",
            controller: TextEditingController(),
            readOnly: true,
            suffixIcon: Icon(Icons.calendar_today, color: AppColors.muted, size: 20),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppColors.accent,
                        onPrimary: AppColors.background,
                        surface: AppColors.card,
                        onSurface: AppColors.accent,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                // ignore: use_build_context_synchronously
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: AppColors.accent,
                          onPrimary: AppColors.background,
                          surface: AppColors.card,
                          onSurface: AppColors.accent,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedTime != null) {
                  controller.selectedDate.value = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                }
              }
            },
          )),
          SizedBox(height: 16),
          MatchTextField(
            label: "Referee (Optional)",
            hint: "Assign Official",
            controller: refereeController,
          ),
        ],
      ),
    );
  }
}
