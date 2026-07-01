import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/team_management/volleyball_team_management_screen.dart';

class VolleyballInitializeMatchController extends GetxController {
  RxString matchName = "".obs;
  RxString tournament = "".obs;
  RxString venue = "".obs;
  RxString court = "".obs;
  RxString referee = "".obs;
  RxString assistantReferee = "".obs;
  RxString category = "Mixed".obs;
  RxString format = "B3".obs;
  RxString date = "".obs;
  RxString time = "".obs;

  RxInt pointsPerSet = 25.obs;
  RxInt finalSetPoints = 15.obs;
  RxInt timeouts = 2.obs;
  RxInt substitutions = 6.obs;

  RxBool winByTwo = true.obs;
  RxBool technicalTimeout = false.obs;
  RxBool liberoEnabled = true.obs;
  RxBool challengeEnabled = false.obs;
  RxBool videoReview = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
  }

  void initializeControllers() {
    // Set initial values if needed
  }

  void selectCategory(String val) {
    category.value = val;
  }

  void selectMatchFormat(String val) {
    format.value = val;
  }

  void incrementPoints(RxInt obsValue) {
    obsValue.value++;
  }

  void decrementPoints(RxInt obsValue, {int min = 0}) {
    if (obsValue.value > min) {
      obsValue.value--;
    }
  }

  void toggleWinByTwo(bool val) => winByTwo.value = val;
  void toggleTechnicalTimeout(bool val) => technicalTimeout.value = val;
  void toggleLibero(bool val) => liberoEnabled.value = val;
  void toggleChallengeSystem(bool val) => challengeEnabled.value = val;

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryContainer,
              onPrimary: AppColors.primary,
              surface: AppColors.surfaceContainerHighest,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      date.value = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
    }
  }

  void pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryContainer,
              onPrimary: AppColors.primary,
              surface: AppColors.surfaceContainerHighest,
              onSurface: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      time.value = pickedTime.format(context);
    }
  }

  void selectVenue(String val) {
    venue.value = val;
  }

  void selectOfficial(String role, String val) {
    if (role == 'referee') {
      referee.value = val;
    } else if (role == 'assistant') {
      assistantReferee.value = val;
    }
  }

  bool validateForm() {
    if (matchName.value.isEmpty || venue.value.isEmpty || date.value.isEmpty || time.value.isEmpty || referee.value.isEmpty) {
      Get.snackbar(
        "Validation Error", 
        "Please complete all required fields (Match Name, Venue, Date, Time, Referee).",
        backgroundColor: AppColors.error,
        colorText: AppColors.primary,
      );
      return false;
    }
    return true;
  }

  void initializeMatch(BuildContext context) {
    if (validateForm()) {
      loading.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        loading.value = false;
        Get.snackbar("Success", "Match Initialized!", backgroundColor: AppColors.primaryContainer, colorText: Colors.black);
        
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VolleyballTeamManagementScreen()));
      });
    }
  }
}
