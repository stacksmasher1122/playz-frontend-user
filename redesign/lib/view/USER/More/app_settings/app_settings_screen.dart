import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/More_Controller/app_settings_controller.dart';
import 'widgets/settings_section_title.dart';
import 'widgets/settings_toggle_tile.dart';
import 'widgets/settings_action_tile.dart';
import 'widgets/language_selector_sheet.dart';
import 'widgets/favorite_sports_sheet.dart';
import 'widgets/app_tutorial_modal.dart';

import 'package:redesign/common/app_back_button.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<AppSettingsController>()
        ? Get.find<AppSettingsController>()
        : Get.put(AppSettingsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
        title: Text(
          'App Settings',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(18),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final s = controller.settings.value;
        return ListView(
          padding: EdgeInsets.only(bottom: context.heightPct(5)),
          children: [
            const SettingsSectionTitle(title: 'Preferences'),
            SettingsActionTile(
              icon: Icons.language_rounded,
              title: 'App Language',
              valueText: s.selectedLanguage,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (ctx) => LanguageSelectorSheet(
                    languages: controller.availableLanguages,
                    currentLanguage: s.selectedLanguage,
                    onSelected: (lang) => controller.setLanguage(lang),
                  ),
                );
              },
            ),
            SettingsActionTile(
              icon: Icons.sports_cricket_rounded,
              title: 'Favorite Sports',
              valueText: '${s.favoriteSports.length} Selected',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (ctx) => FavoriteSportsSheet(
                    allSports: controller.allSports,
                    selectedSports: s.favoriteSports,
                    onToggle: (sport) => controller.toggleFavoriteSport(sport),
                  ),
                );
              },
            ),
            SettingsActionTile(
              icon: Icons.auto_stories_rounded,
              title: 'App Tutorial & Walkthrough',
              valueText: 'Re-play',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => const AppTutorialModal(),
                );
              },
            ),

            const SettingsSectionTitle(title: 'Notifications & Alerts'),
            SettingsToggleTile(
              icon: Icons.notifications_active_outlined,
              title: 'Push Notifications',
              subtitle: 'Allow instant updates and reminders',
              value: s.pushNotificationsEnabled,
              onChanged: controller.togglePushNotifications,
            ),
            SettingsToggleTile(
              icon: Icons.timer_outlined,
              title: 'Scoreboard Slot Alerts',
              subtitle: 'Remind 20 mins before slot scoreboard access',
              value: s.bookingRemindersEnabled,
              onChanged: controller.toggleBookingReminders,
            ),
            SettingsToggleTile(
              icon: Icons.forum_outlined,
              title: 'Group Chat Messages',
              subtitle: 'Alerts when team chat messages arrive',
              value: s.chatNotificationsEnabled,
              onChanged: controller.toggleChatNotifications,
            ),

            const SettingsSectionTitle(title: 'Security & App Data'),
            SettingsToggleTile(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric App Lock',
              subtitle: 'Require Face ID / Fingerprint to open PlayZ',
              value: s.biometricLockEnabled,
              onChanged: controller.toggleBiometricLock,
            ),
            SettingsToggleTile(
              icon: Icons.volume_up_outlined,
              title: 'Scoreboard Sound Effects',
              subtitle: 'Play whistle and boundary sounds',
              value: s.soundEffectsEnabled,
              onChanged: controller.toggleSoundEffects,
            ),

            SizedBox(height: context.heightPct(3)),
            Center(
              child: Text(
                'PlayZ v2.4.0 (Build 3020)\nMade with ❤️ for Sports Enthusiasts',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(12),
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
