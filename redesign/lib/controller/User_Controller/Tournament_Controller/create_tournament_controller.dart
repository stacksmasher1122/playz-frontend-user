import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../view/USER/Tournament/venue_selection/venue_selection_page.dart';

class CreateTournamentController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString selectedSport = "Football".obs;
  final RxString selectedTiming = "Morning (6 AM - 12 PM)".obs;
  final RxBool isPublicAccess = true.obs;
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final RxInt currentStep = 1.obs;
  final RxString coverImagePath = "".obs;
  
  // Storing form fields to construct model later
  final RxString tournamentName = "".obs;
  final RxString description = "".obs;

  final RxList<String> sports = <String>[].obs;
  final RxList<String> timingOptions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDefaults();
    // Simulate loading for UI testing
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }

  void loadDefaults() {
    sports.assignAll(["Cricket", "Football", "Tennis", "Badminton", "Basketball"]);
    timingOptions.assignAll([
      "Morning (6 AM - 12 PM)",
      "Afternoon (12 PM - 6 PM)",
      "Evening (6 PM - 10 PM)",
      "Any Time"
    ]);
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
    );
    if (picked != null) {
      startDate.value = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      endDate.value = picked;
    }
  }

  void selectTiming(String value) {
    selectedTiming.value = value;
  }

  void toggleAccess() {
    isPublicAccess.toggle();
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
