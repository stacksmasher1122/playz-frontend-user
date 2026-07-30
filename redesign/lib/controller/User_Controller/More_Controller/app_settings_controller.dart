import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/model/User_Models/More_Models/app_settings_model.dart';
import 'package:redesign/services/global_groups_service.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class AppSettingsController extends GetxController {
  final settings = const AppSettingsModel().obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFavoriteSports();
  }

  Future<void> _loadUserFavoriteSports() async {
    try {
      final docId = await UserPreferences.getDocId() ?? '';
      if (docId.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(docId)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          if (data['favoriteSports'] != null) {
            final sports = List<String>.from(data['favoriteSports']);
            if (sports.isNotEmpty) {
              settings.value = settings.value.copyWith(favoriteSports: sports);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('🔴 [AppSettingsController] Load favorite sports error: $e');
    }
  }

  final availableLanguages = const [
    'English (US)',
    'Hindi (हिंदी)',
    'Spanish (Español)',
    'French (Français)',
    'German (Deutsch)',
    'Japanese (日本語)',
  ];

  final allSports = const [
    'Cricket',
    'Badminton',
    'Football',
    'Tennis',
    'Basketball',
    'Volleyball',
    'Table Tennis',
    'Padel',
    'Pickleball',
    'Rugby',
    'Baseball',
    'Swimming',
    'Cycling',
    'Boxing',
  ];

  void setLanguage(String lang) {
    settings.value = settings.value.copyWith(selectedLanguage: lang);
  }

  Future<void> toggleFavoriteSport(String sport) async {
    final current = List<String>.from(settings.value.favoriteSports);
    if (current.contains(sport)) {
      if (current.length > 1) {
        current.remove(sport);
      }
    } else {
      current.add(sport);
    }
    settings.value = settings.value.copyWith(favoriteSports: current);
    await syncFavoriteSportsToFirebase();
  }

  Future<void> syncFavoriteSportsToFirebase() async {
    try {
      final docId = await UserPreferences.getDocId() ?? '';
      final userName = await UserPreferences.getUserName() ?? '';
      final userPic = await UserPreferences.getProfileImageUrl() ?? '';

      if (docId.isNotEmpty) {
        final sports = settings.value.favoriteSports;
        await FirebaseFirestore.instance.collection('User').doc(docId).set({
          'favoriteSports': sports,
        }, SetOptions(merge: true));

        await GlobalGroupsService.syncUserSportGroups(
          userDocId: docId,
          userName: userName,
          userPic: userPic,
          favoriteSports: sports,
        );

        if (Get.isRegistered<GroupsController>()) {
          await Get.find<GroupsController>().fetchMyGroups();
        }
      }
    } catch (e) {
      debugPrint(
        '🔴 [AppSettingsController] syncFavoriteSportsToFirebase error: $e',
      );
    }
  }

  void togglePushNotifications(bool val) {
    settings.value = settings.value.copyWith(pushNotificationsEnabled: val);
  }

  void toggleMatchAlerts(bool val) {
    settings.value = settings.value.copyWith(matchAlertsEnabled: val);
  }

  void toggleBookingReminders(bool val) {
    settings.value = settings.value.copyWith(bookingRemindersEnabled: val);
  }

  void toggleChatNotifications(bool val) {
    settings.value = settings.value.copyWith(chatNotificationsEnabled: val);
  }

  void toggleSoundEffects(bool val) {
    settings.value = settings.value.copyWith(soundEffectsEnabled: val);
  }

  void toggleBiometricLock(bool val) {
    settings.value = settings.value.copyWith(biometricLockEnabled: val);
  }
}
