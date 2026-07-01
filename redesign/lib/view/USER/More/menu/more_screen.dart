import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

import 'widgets/menu_profile_header.dart';
import 'widgets/z_coins_card.dart';
import 'widgets/tools_grid.dart';
import 'widgets/sports_row.dart';
import 'widgets/rewards_card.dart';
import 'widgets/settings_tile.dart';
import 'widgets/dark_mode_tile.dart';
import 'widgets/section_title.dart';
import 'widgets/logout_dialog.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MoreScreen extends StatefulWidget {
  MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _controller = Get.find<UserProfileController>();
  bool darkMode = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) => LogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
          children: [
            MenuProfileHeader(),
            SizedBox(height: 16),
            ZCoinsCard(),
            SizedBox(height: 28),
            SectionTitle('My Tools'),
            SizedBox(height: 14),
            ToolsGrid(),
            SizedBox(height: 28),
            SectionTitle('Dive Into Your Sports'),
            SizedBox(height: 14),
            SportsRow(),
            SizedBox(height: 28),
            RewardsCard(),
            SizedBox(height: 28),
            SectionTitle('Help & Preferences'),
            SizedBox(height: 12),
            SettingsTile(
              icon: Icons.help_outline,
              label: 'Support & FAQ',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.settings,
              label: 'App Settings',
              onTap: () {},
            ),
            DarkModeTile(
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
            ),
            SettingsTile(
              icon: Icons.logout,
              label: 'Log Out',
              color: Colors.red,
              onTap: () => _showLogoutDialog(context),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Version 2.4.0 (Build 3020)',
                style: GoogleFonts.inter(color: Colors.white24, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
