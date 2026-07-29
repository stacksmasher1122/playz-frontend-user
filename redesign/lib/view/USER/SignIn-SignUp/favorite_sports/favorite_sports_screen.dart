import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../profile_setup/profile_setup_screen.dart';

import 'widgets/favorite_sports_header.dart';
import 'widgets/sports_selection_grid.dart';
import 'widgets/sports_selection_bottom.dart';

class FavoriteSportsScreen extends StatefulWidget {
  const FavoriteSportsScreen({super.key});

  @override
  State<FavoriteSportsScreen> createState() => _FavoriteSportsScreenState();
}

class _FavoriteSportsScreenState extends State<FavoriteSportsScreen> {
  final List<String> _sports = [
    'Football', 'Basketball', 'Tennis', 'Cricket',
    'Badminton', 'Boxing', 'Swimming', 'Cycling',
    'Baseball', 'Table Tennis', 'Volleyball', 'Rugby',
  ];

  final List<List<Color>> _gradients = [
    [const Color(0xFF8B9B7E), const Color(0xFF4A5C43)], 
    [const Color(0xFFBA7647), const Color(0xFF6B3A1C)], 
    [const Color(0xFFB57053), const Color(0xFF653018)], 
    [const Color(0xFFD69A6E), const Color(0xFF345864)], 
    [const Color(0xFFCE8853), const Color(0xFF69351C)], 
    [const Color(0xFFDAC090), const Color(0xFF4A4B56)], 
    [const Color(0xFFDB9A54), const Color(0xFF5A3018)], 
    [const Color(0xFF90A39C), const Color(0xFF354641)], 
    [const Color(0xFF9CB8B5), const Color(0xFF425654)], 
    [const Color(0xFFD38B6B), const Color(0xFF4B201A)], 
    [const Color(0xFF9DB8A9), const Color(0xFF324647)], 
    [const Color(0xFFC9A254), const Color(0xFF324B4C)],
  ];

  final Set<String> _selectedSports = {};

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }
    });
  }

  void _goNext() {
    if (_selectedSports.length < 4) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileSetupScreen(selectedSports: _selectedSports.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bool canProceed = _selectedSports.length >= 4;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'STEP 1 OF 2',
              style: AppTypography.labelCaps10.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(11),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: context.heightPct(0.8)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: context.widthPct(1)),
                Container(
                  height: context.heightPct(0.4).clamp(3.0, 4.0),
                  width: context.widthPct(8),
                  decoration: BoxDecoration(
                    color: AppColors.borderDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FavoriteSportsHeader(),
          SportsSelectionGrid(
            sports: _sports,
            gradients: _gradients,
            selectedSports: _selectedSports,
            onSportToggle: _toggleSport,
          ),
          SportsSelectionBottom(
            selectedCount: _selectedSports.length,
            canProceed: canProceed,
            onNext: _goNext,
          ),
        ],
      ),
    );
  }
}
