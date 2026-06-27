import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
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
  static const kSpotifyGreen = AppColors.accent;
  static const kMuted = Color(0xFFA7A7A7);

  final List<String> _sports = [
    'Football', 'Basketball', 'Tennis', 'Cricket',
    'Badminton', 'Boxing', 'Swimming', 'Cycling',
    'Baseball', 'Table Tennis', 'Volleyball', 'Rugby',
  ];

  final List<List<Color>> _gradients = [
    [Color(0xFF8B9B7E), Color(0xFF4A5C43)], 
    [Color(0xFFBA7647), Color(0xFF6B3A1C)], 
    [Color(0xFFB57053), Color(0xFF653018)], 
    [Color(0xFFD69A6E), Color(0xFF345864)], 
    [Color(0xFFCE8853), Color(0xFF69351C)], 
    [Color(0xFFDAC090), Color(0xFF4A4B56)], 
    [Color(0xFFDB9A54), Color(0xFF5A3018)], 
    [Color(0xFF90A39C), Color(0xFF354641)], 
    [Color(0xFF9CB8B5), Color(0xFF425654)], 
    [Color(0xFFD38B6B), Color(0xFF4B201A)], 
    [Color(0xFF9DB8A9), Color(0xFF324647)], 
    [Color(0xFFC9A254), Color(0xFF324B4C)],
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
    final bool canProceed = _selectedSports.length >= 4;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'STEP 1 OF 2',
              style: TextStyle(
                color: kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 3, width: 30, color: kSpotifyGreen),
                const SizedBox(width: 4),
                Container(height: 3, width: 30, color: Colors.white24),
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
