import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Volleyball/team_management/volleyball_team_management_screen.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Scoreboard_SQF/volleyballSqflite.dart';
import 'package:uuid/uuid.dart';

class VolleyballInitializeMatchController extends GetxController {
  RxString matchName = "Volleyball Showdown".obs;
  RxString tournament = "".obs;
  RxString venue = "Local Arena".obs;
  RxString court = "Main Court".obs;
  RxString referee = "Self-Officiated".obs;
  RxString assistantReferee = "".obs;
  RxString category = "Mixed".obs;
  RxString format = "B3".obs;
  RxString date = "Today".obs;
  RxString time = "Now".obs;

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

  RxInt squadLimit = 6.obs;
  RxBool subsEnabled = true.obs;
  RxInt maxSubstitutes = 3.obs;
  RxString homeTeamName = "Team Red".obs;
  RxString awayTeamName = "Team Blue".obs;
  final TextEditingController homeTeamController = TextEditingController(
    text: "Team Red",
  );
  final TextEditingController awayTeamController = TextEditingController(
    text: "Team Blue",
  );

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
  void toggleVideoReview(bool val) => videoReview.value = val;

  void incrementSquadLimit() => squadLimit.value++;
  void decrementSquadLimit() {
    if (squadLimit.value > 1) squadLimit.value--;
  }

  void toggleSubs(bool val) => subsEnabled.value = val;

  void incrementSubs() => maxSubstitutes.value++;
  void decrementSubs() {
    if (maxSubstitutes.value > 0) maxSubstitutes.value--;
  }

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.accent,
              surface: AppColors.outlineVariant,
              onSurface: AppColors.accent,
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
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              onPrimary: AppColors.accent,
              surface: AppColors.outlineVariant,
              onSurface: AppColors.accent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null && context.mounted) {
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
    // Simplified UI layout no longer asks for Name, Venue, Date, Time etc.
    // So we just return true. Default values are injected above.
    return true;
  }

  Future<void> initializeMatch(BuildContext context) async {
    if (!validateForm()) return;

    loading.value = true;
    try {
      final matchId = const Uuid().v4();
      final currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? 'local_user';

      final match = VolleyballMatchModel(
        matchId: matchId,
        createdBy: currentUserId,
        matchName: matchName.value.trim(),
        tournament: tournament.value.trim(),
        date: date.value.trim(),
        time: time.value.trim(),
        venue: venue.value.trim(),
        court: court.value.trim(),
        referee: referee.value.trim(),
        assistantReferee: assistantReferee.value.trim(),
        category: category.value,
        format: format.value,
        pointsPerSet: pointsPerSet.value,
        finalSetPoints: finalSetPoints.value,
        timeouts: timeouts.value,
        substitutions: substitutions.value,
        technicalTimeout: technicalTimeout.value,
        liberoEnabled: liberoEnabled.value,
        challengeEnabled: challengeEnabled.value,
        videoReview: videoReview.value,
        winByTwo: winByTwo.value,
        status: 'setup',
        homeTeamName: homeTeamController.text.trim(),
        awayTeamName: awayTeamController.text.trim(),
      );

      await VolleyballSqflite.instance.insertMatch(match);
      try {
        await FirebaseFirestore.instance
            .collection('volleyball_matches')
            .doc(matchId)
            .set(match.toJson());
      } catch (e) {
        debugPrint('Firestore save failed for volleyball match: $e');
      }

      if (!context.mounted) {
        loading.value = false;
        return;
      }

      Get.snackbar(
        'Match Ready',
        'Volleyball match setup saved successfully.',
        backgroundColor: AppColors.accent,
        colorText: Colors.black,
        duration: Duration(seconds: 1),
      );

      await Future.delayed(Duration(milliseconds: 800));

      if (!context.mounted) {
        loading.value = false;
        return;
      }

      loading.value = false;

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VolleyballTeamManagementScreen(),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error in initializeMatch: $e');
      loading.value = false;
      Get.snackbar(
        'Error',
        'Failed to initialize match: $e',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }
}
