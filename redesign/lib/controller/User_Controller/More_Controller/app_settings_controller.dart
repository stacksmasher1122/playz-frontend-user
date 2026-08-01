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
    _loadUserLanguage();
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

  Future<void> _loadUserLanguage() async {
    try {
      final docId = await UserPreferences.getDocId() ?? '';
      String savedLang = await UserPreferences.getPreferredLanguage();

      if (docId.isNotEmpty) {
        final userDoc = await FirebaseFirestore.instance
            .collection('User')
            .doc(docId)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          if (data['preferredLanguage'] != null) {
            savedLang = data['preferredLanguage'].toString();
          }
        }
      }

      if (savedLang.isNotEmpty) {
        final matched = availableLanguages.firstWhere(
          (l) => l.toLowerCase() == savedLang.toLowerCase() ||
                 l.toLowerCase().startsWith(savedLang.toLowerCase()),
          orElse: () => savedLang,
        );
        settings.value = settings.value.copyWith(selectedLanguage: matched);
      }
    } catch (e) {
      debugPrint('🔴 [AppSettingsController] Load language error: $e');
    }
  }

  final availableLanguages = const [
    'English',
    'Hindi (हिंदी)',
    'Marathi (मराठी)',
    'Tamil (தமிழ்)',
    'Telugu (తెలుగు)',
    'Kannada (ಕನ್ನಡ)',
    'Gujarati (ગુજરાતી)',
    'Bengali (বাংলা)',
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

  Future<void> setLanguage(String lang) async {
    settings.value = settings.value.copyWith(selectedLanguage: lang);

    // Save to SharedPreferences
    await UserPreferences.setPreferredLanguage(lang);

    // Save to Firestore
    try {
      final docId = await UserPreferences.getDocId() ?? '';
      if (docId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('User').doc(docId).set({
          'preferredLanguage': lang,
          'lastLanguageUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('🔴 [AppSettingsController] Sync language error: $e');
    }
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
