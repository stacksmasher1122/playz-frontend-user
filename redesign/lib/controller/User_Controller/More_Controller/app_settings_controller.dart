import 'package:get/get.dart';
import 'package:redesign/model/User_Models/More_Models/app_settings_model.dart';

class AppSettingsController extends GetxController {
  final settings = const AppSettingsModel().obs;

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
  ];

  void setLanguage(String lang) {
    settings.value = settings.value.copyWith(selectedLanguage: lang);
  }

  void toggleFavoriteSport(String sport) {
    final current = List<String>.from(settings.value.favoriteSports);
    if (current.contains(sport)) {
      if (current.length > 1) {
        current.remove(sport);
      }
    } else {
      current.add(sport);
    }
    settings.value = settings.value.copyWith(favoriteSports: current);
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
