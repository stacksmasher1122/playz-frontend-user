import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupWizardCard extends StatefulWidget {
  final CricketController controller;
  final List<Player> battingTeam;
  final List<Player> bowlingTeam;

  const SetupWizardCard({
    super.key,
    required this.controller,
    required this.battingTeam,
    required this.bowlingTeam,
  });

  @override
  State<SetupWizardCard> createState() => _SetupWizardCardState();
}

class _SetupWizardCardState extends State<SetupWizardCard> {
  String? _selectedStrikerName;
  String? _selectedNonStrikerName;
  String? _selectedBowlerName;

  @override
  void initState() {
    super.initState();
    _initDefaults();
  }

  @override
  void didUpdateWidget(SetupWizardCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initDefaults();
  }

  void _initDefaults() {
    final batNames = widget.battingTeam.map((p) => p.name).toList();
    final bowlNames = widget.bowlingTeam.map((p) => p.name).toList();

    if (_selectedStrikerName == null || !batNames.contains(_selectedStrikerName)) {
      _selectedStrikerName = batNames.isNotEmpty ? batNames.first : null;
    }
    if (_selectedNonStrikerName == null ||
        !batNames.contains(_selectedNonStrikerName) ||
        _selectedNonStrikerName == _selectedStrikerName) {
      if (batNames.length > 1) {
        _selectedNonStrikerName = batNames.firstWhere(
          (n) => n != _selectedStrikerName,
          orElse: () => batNames[1],
        );
      } else {
        _selectedNonStrikerName = batNames.isNotEmpty ? batNames.first : null;
      }
    }
    if (_selectedBowlerName == null || !bowlNames.contains(_selectedBowlerName)) {
      _selectedBowlerName = bowlNames.isNotEmpty ? bowlNames.first : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final batNames = widget.battingTeam.map((p) => p.name).toList();
    final bowlNames = widget.bowlingTeam.map((p) => p.name).toList();

    final bool canStart = _selectedStrikerName != null &&
        _selectedNonStrikerName != null &&
        _selectedBowlerName != null &&
        (_selectedStrikerName != _selectedNonStrikerName || batNames.length == 1);

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      margin: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_cricket, color: AppColors.accent, size: 24),
              const SizedBox(width: 10),
              Text(
                'Select Opening Players',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choose the striker, non-striker, and opening bowler to start the match.',
            style: GoogleFonts.inter(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),
          const SizedBox(height: 24),

          // Striker Selector
          _buildNameSelector(
            label: 'Striker (On Strike)',
            names: batNames,
            selectedName: _selectedStrikerName,
            onChanged: (name) {
              setState(() {
                _selectedStrikerName = name;
                if (_selectedNonStrikerName == name && batNames.length > 1) {
                  _selectedNonStrikerName = batNames.firstWhere((n) => n != name);
                }
              });
            },
          ),

          const SizedBox(height: 16),

          // Non-Striker Selector
          _buildNameSelector(
            label: 'Non-Striker',
            names: batNames,
            selectedName: _selectedNonStrikerName,
            onChanged: (name) {
              setState(() {
                _selectedNonStrikerName = name;
                if (_selectedStrikerName == name && batNames.length > 1) {
                  _selectedStrikerName = batNames.firstWhere((n) => n != name);
                }
              });
            },
          ),

          const SizedBox(height: 16),

          // Opening Bowler Selector
          _buildNameSelector(
            label: 'Opening Bowler',
            names: bowlNames,
            selectedName: _selectedBowlerName,
            onChanged: (name) {
              setState(() {
                _selectedBowlerName = name;
              });
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: canStart
                  ? () {
                      widget.controller.startInnings(
                        strikerName: _selectedStrikerName!,
                        nonStrikerName: _selectedNonStrikerName!,
                        bowlerName: _selectedBowlerName!,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Start Match Scoring',
                style: GoogleFonts.inter(
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSelector({
    required String label,
    required List<String> names,
    required String? selectedName,
    required ValueChanged<String?> onChanged,
  }) {
    final String? validValue = (selectedName != null && names.contains(selectedName)) ? selectedName : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: const Color(0xFF1A1A1A),
              value: validValue,
              hint: Text(
                'Select player',
                style: GoogleFonts.inter(color: Colors.white38, fontSize: 13),
              ),
              items: names
                  .map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(
                        name,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
