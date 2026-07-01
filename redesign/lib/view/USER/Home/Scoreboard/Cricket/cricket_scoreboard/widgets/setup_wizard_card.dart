import 'package:flutter/material.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupWizardCard extends StatefulWidget {
  final CricketController controller;
  final List<Player> battingTeam;
  final List<Player> bowlingTeam;

  SetupWizardCard({
    super.key,
    required this.controller,
    required this.battingTeam,
    required this.bowlingTeam,
  });

  @override
  State<SetupWizardCard> createState() => _SetupWizardCardState();
}

class _SetupWizardCardState extends State<SetupWizardCard> {
  Player? _selectedStriker;
  Player? _selectedNonStriker;
  Player? _selectedBowler;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      margin: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Start Innings',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          _buildPlayerSelector(
            'Select Striker',
            widget.battingTeam,
            _selectedStriker,
            (Player p) {
              if (p.name != _selectedNonStriker?.name) {
                setState(() => _selectedStriker = p);
              }
            },
          ),
          SizedBox(height: 16),
          _buildPlayerSelector(
            'Select Non-Striker',
            widget.battingTeam,
            _selectedNonStriker,
            (Player p) {
              if (p.name != _selectedStriker?.name) {
                setState(() => _selectedNonStriker = p);
              }
            },
          ),
          SizedBox(height: 16),
          _buildPlayerSelector(
            'Select Opening Bowler',
            widget.bowlingTeam,
            _selectedBowler,
            (Player p) {
              setState(() => _selectedBowler = p);
            },
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed:
                (_selectedStriker != null &&
                    _selectedNonStriker != null &&
                    _selectedBowler != null)
                ? () {
                    widget.controller.startInnings(
                      strikerName: _selectedStriker!.name,
                      nonStrikerName: _selectedNonStriker!.name,
                      bowlerName: _selectedBowler!.name,
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text(
              'Start Match',
              style: TextStyle(color: Colors.black, fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSelector(
    String label,
    List<Player> pool,
    Player? selected,
    Function(Player) onSelect,
  ) {
    if (selected != null && !pool.any((p) => p.name == selected!.name)) {
      selected = null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.muted, fontSize: 14)),
        SizedBox(height: 8),
        Container(
          height: ResponsiveHelper.h(50),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.muted.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Player>(
              isExpanded: true,
              dropdownColor: AppColors.card,
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              value: selected,
              hint: Text(
                'Select a player',
                style: TextStyle(color: Colors.white54),
              ),
              items: pool
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(
                        p.name,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (p) {
                if (p != null) onSelect(p);
              },
            ),
          ),
        ),
      ],
    );
  }
}
