import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'widgets/create_match/badminton_create_match_app_bar.dart';
import 'widgets/create_match/step_badge.dart';
import 'widgets/create_match/match_form_section.dart';
import 'widgets/create_match/match_category_section.dart';
import 'widgets/create_match/series_format_section.dart';
import 'widgets/create_match/premium_banner.dart';
import 'widgets/create_match/custom_settings_section.dart';
import 'widgets/create_match/setup_checklist.dart';
import 'widgets/create_match/next_button.dart';
import 'player_management/player_management_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BadmintonCreateMatchScreen extends StatefulWidget {
  BadmintonCreateMatchScreen({super.key});

  @override
  State<BadmintonCreateMatchScreen> createState() =>
      _BadmintonCreateMatchScreenState();
}

class _BadmintonCreateMatchScreenState extends State<BadmintonCreateMatchScreen> {
  String _selectedCategory = "MEN'S SINGLES";
  String _seriesFormat = "Best of 3";
  bool _winBy2 = true;
  final int _pointsPerGame = 21;
  final int _maxPointCap = 30;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            BadmintonCreateMatchAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepBadge(),
                    SizedBox(height: 12),
                    Text(
                      "CREATE MATCH",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(28),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Define the core parameters for the professional\ncourt session.",
                      style: TextStyle(color: AppColors.muted, height: 1.4),
                    ),
                    SizedBox(height: 32),
                    
                    MatchFormSection(),
                    SizedBox(height: 32),
                    
                    MatchCategorySection(
                      selectedCategory: _selectedCategory,
                      onCategoryChanged: (val) => setState(() => _selectedCategory = val),
                    ),
                    SizedBox(height: 32),
                    
                    SeriesFormatSection(
                      selectedFormat: _seriesFormat,
                      onFormatChanged: (val) => setState(() => _seriesFormat = val),
                    ),
                    SizedBox(height: 32),
                    
                    PremiumBanner(),
                    SizedBox(height: 32),
                    
                    CustomSettingsSection(
                      pointsPerGame: _pointsPerGame,
                      winBy2: _winBy2,
                      maxPointCap: _maxPointCap,
                      onWinBy2Changed: (val) => setState(() => _winBy2 = val ?? false),
                    ),
                    SizedBox(height: 32),
                    
                    SetupChecklist(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            NextButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlayerManagementScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
