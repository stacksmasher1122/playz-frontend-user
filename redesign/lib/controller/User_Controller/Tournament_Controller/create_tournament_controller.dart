import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redesign/theme/app_colors.dart';
import '../../../view/USER/Tournament/venue_selection/venue_selection_page.dart';

class CreateTournamentController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString selectedSport = "Cricket".obs;
  final RxString searchQuery = "".obs;

  final Rx<DateTime?> startDate = Rx<DateTime?>(DateTime.now());
  final Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(const TimeOfDay(hour: 9, minute: 0));
  final Rx<DateTime?> endDate = Rx<DateTime?>(DateTime.now().add(const Duration(days: 3)));
  final Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(const TimeOfDay(hour: 18, minute: 0));

  final RxInt currentStep = 1.obs;
  final RxString coverImagePath = "".obs;

  // Storing form fields to construct model later
  final RxString tournamentName = "".obs;
  final RxString description = "".obs;

  final RxList<String> sports = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDefaults();
    Future.delayed(const Duration(milliseconds: 300), () {
      isLoading.value = false;
    });
  }

  void loadDefaults() {
    sports.assignAll([
      "Cricket",
      "Football",
      "Basketball",
      "Tennis",
      "Badminton",
      "Table Tennis",
      "Volleyball",
      "Hockey",
      "Kabaddi",
      "Kho Kho",
      "Boxing",
      "MMA",
      "Wrestling",
      "Judo",
      "Karate",
      "Taekwondo",
      "Squash",
      "Pickleball",
    ]);
  }

  List<String> get filteredSports {
    if (searchQuery.value.trim().isEmpty) {
      return sports;
    }
    final query = searchQuery.value.trim().toLowerCase();
    return sports.where((s) => s.toLowerCase().contains(query)).toList();
  }

  void selectSport(String sport) {
    selectedSport.value = sport;
  }

  Future<void> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      coverImagePath.value = image.path;
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startDate.value = picked;
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = picked;
      }
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime.value ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startTime.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime.value ?? const TimeOfDay(hour: 18, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: AppColors.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      endTime.value = picked;
    }
  }

  void saveDraft() {
    showSuccess("Draft Saved Successfully");
  }

  void goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VenueSelectionPage()),
    );
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
