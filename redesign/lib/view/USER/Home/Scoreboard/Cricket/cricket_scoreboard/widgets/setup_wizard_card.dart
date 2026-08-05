import 'package:flutter/material.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_state_models.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// An elevated, app-themed card widget presented after setup & coin toss
/// for picking the Opening Striker, Non-Striker, and Opening Bowler.
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
      margin: EdgeInsets.all(ResponsiveHelper.w(16.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20.0)),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24.0)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Icon Badge & Title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                ),
                child: Icon(
                  Icons.sports_cricket_rounded,
                  color: AppColors.accent,
                  size: ResponsiveHelper.w(24.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Opening Players',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: ResponsiveHelper.sp(20.0),
                        fontWeight: FontWeight.bold,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      'Draft opening batters and bowler to begin scoring.',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.mutedText,
                        fontSize: ResponsiveHelper.sp(12.0),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(24.0)),

          // 1. Striker Selector Card
          _buildRoleSelectorCard(
            context,
            roleTitle: 'STRIKER (ON STRIKE)',
            icon: Icons.sports_cricket_rounded,
            accentColor: AppColors.accent,
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

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // 2. Non-Striker Selector Card
          _buildRoleSelectorCard(
            context,
            roleTitle: 'NON-STRIKER',
            icon: Icons.sports_cricket_rounded,
            accentColor: const Color(0xFF4D96FF),
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

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // 3. Opening Bowler Selector Card
          _buildRoleSelectorCard(
            context,
            roleTitle: 'OPENING BOWLER',
            icon: Icons.sports_baseball_rounded,
            accentColor: const Color(0xFFFF6B6B),
            names: bowlNames,
            selectedName: _selectedBowlerName,
            onChanged: (name) {
              setState(() {
                _selectedBowlerName = name;
              });
            },
          ),

          SizedBox(height: ResponsiveHelper.h(28.0)),

          // Start Match Scoring Action Button
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(54.0),
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
                foregroundColor: AppColors.background,
                disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
                disabledForegroundColor: Colors.white38,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                ),
              ),
              child: Text(
                'START MATCH SCORING',
                style: AppTypography.headlineSm.copyWith(
                  color: canStart ? AppColors.background : Colors.white38,
                  fontSize: ResponsiveHelper.sp(16.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ).responsive(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectorCard(
    BuildContext context, {
    required String roleTitle,
    required IconData icon,
    required Color accentColor,
    required List<String> names,
    required String? selectedName,
    required ValueChanged<String> onChanged,
  }) {
    final String displayValue = selectedName ?? 'Select player';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _openPlayerSelectorSheet(
            context,
            roleTitle: roleTitle,
            accentColor: accentColor,
            names: names,
            selectedName: selectedName,
            onSelected: onChanged,
          );
        },
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16.0),
            vertical: ResponsiveHelper.h(14.0),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF131313),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
            border: Border(
              left: BorderSide(color: accentColor, width: 4.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: accentColor,
                    size: ResponsiveHelper.w(18.0),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8.0)),
                  Text(
                    roleTitle,
                    style: AppTypography.labelCaps.copyWith(
                      color: accentColor,
                      fontSize: ResponsiveHelper.sp(11.0),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ).responsive(context),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayValue,
                    style: AppTypography.bodyMd.copyWith(
                      color: selectedName != null ? AppColors.textPrimary : AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(15.0),
                      fontWeight: selectedName != null ? FontWeight.bold : FontWeight.normal,
                    ).responsive(context),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.mutedText,
                    size: ResponsiveHelper.w(22.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPlayerSelectorSheet(
    BuildContext context, {
    required String roleTitle,
    required Color accentColor,
    required List<String> names,
    required String? selectedName,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveHelper.w(24.0)),
        ),
      ),
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(20.0),
            vertical: ResponsiveHelper.h(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle Pill
              Center(
                child: Container(
                  width: ResponsiveHelper.w(44.0),
                  height: ResponsiveHelper.h(4.5),
                  margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16.0)),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
                  ),
                ),
              ),

              // Title
              Text(
                'SELECT $roleTitle',
                style: AppTypography.labelCaps.copyWith(
                  color: accentColor,
                  fontSize: ResponsiveHelper.sp(12.0),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(4.0)),
              Text(
                'Choose player for this role',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(13.0),
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(16.0)),

              // Player List
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: names.length,
                  separatorBuilder: (c, i) => SizedBox(height: ResponsiveHelper.h(8.0)),
                  itemBuilder: (context, index) {
                    final name = names[index];
                    final isSelected = name == selectedName;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onSelected(name);
                          Navigator.of(ctx).pop();
                        },
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.w(16.0),
                            vertical: ResponsiveHelper.h(14.0),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? accentColor.withValues(alpha: 0.15)
                                : const Color(0xFF131313),
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                            border: Border.all(
                              color: isSelected
                                  ? accentColor
                                  : Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: ResponsiveHelper.w(16.0),
                                backgroundColor: isSelected
                                    ? accentColor
                                    : const Color(0xFF2A2A2A),
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    color: isSelected ? AppColors.background : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.sp(13.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.w(12.0)),
                              Expanded(
                                child: Text(
                                  name,
                                  style: AppTypography.bodyMd.copyWith(
                                    color: isSelected ? accentColor : AppColors.textPrimary,
                                    fontSize: ResponsiveHelper.sp(15.0),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  ).responsive(context),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: accentColor,
                                  size: ResponsiveHelper.w(20.0),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(16.0)),
            ],
          ),
        );
      },
    );
  }
}
