class AppSettingsModel {
  final String selectedLanguage;
  final List<String> favoriteSports;
  final bool pushNotificationsEnabled;
  final bool matchAlertsEnabled;
  final bool bookingRemindersEnabled;
  final bool chatNotificationsEnabled;
  final bool soundEffectsEnabled;
  final bool biometricLockEnabled;

  const AppSettingsModel({
    this.selectedLanguage = 'English (US)',
    this.favoriteSports = const ['Cricket', 'Badminton', 'Football'],
    this.pushNotificationsEnabled = true,
    this.matchAlertsEnabled = true,
    this.bookingRemindersEnabled = true,
    this.chatNotificationsEnabled = true,
    this.soundEffectsEnabled = true,
    this.biometricLockEnabled = false,
  });

  AppSettingsModel copyWith({
    String? selectedLanguage,
    List<String>? favoriteSports,
    bool? pushNotificationsEnabled,
    bool? matchAlertsEnabled,
    bool? bookingRemindersEnabled,
    bool? chatNotificationsEnabled,
    bool? soundEffectsEnabled,
    bool? biometricLockEnabled,
  }) {
    return AppSettingsModel(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      matchAlertsEnabled: matchAlertsEnabled ?? this.matchAlertsEnabled,
      bookingRemindersEnabled: bookingRemindersEnabled ?? this.bookingRemindersEnabled,
      chatNotificationsEnabled: chatNotificationsEnabled ?? this.chatNotificationsEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
    );
  }
}
