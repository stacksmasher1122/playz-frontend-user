import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_state_models.dart';

/// Modal bottom sheet for recording basketball personal and technical fouls matching the design image.
class BasketballRecordFoulSheet extends StatefulWidget {
  final BasketballController controller;

  const BasketballRecordFoulSheet({
    super.key,
    required this.controller,
  });

  static void show(BuildContext context, BasketballController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => BasketballRecordFoulSheet(controller: controller),
    );
  }

  @override
  State<BasketballRecordFoulSheet> createState() => _BasketballRecordFoulSheetState();
}

class _BasketballRecordFoulSheetState extends State<BasketballRecordFoulSheet> {
  bool _isTechnicalFoul = false;
  String _selectedTeam = 'sideA'; // 'sideA' or 'sideB'
  String? _selectedPlayerId;

  // Fallback player definitions if roster is empty
  late List<BasketballPlayer> _sideAPlayers;
  late List<BasketballPlayer> _sideBPlayers;

  @override
  void initState() {
    super.initState();
    final state = widget.controller.liveState.value;
    if (state != null) {
      _sideAPlayers = state.teamA.isNotEmpty ? state.teamA : _generateDefaultPlayers('sideA');
      _sideBPlayers = state.teamB.isNotEmpty ? state.teamB : _generateDefaultPlayers('sideB');
    } else {
      _sideAPlayers = _generateDefaultPlayers('sideA');
      _sideBPlayers = _generateDefaultPlayers('sideB');
    }

    if (_sideAPlayers.isNotEmpty) {
      _selectedPlayerId = _sideAPlayers.first.id;
    }
  }

  List<BasketballPlayer> _generateDefaultPlayers(String side) {
    final isA = side == 'sideA';
    if (isA) {
      return const [
        BasketballPlayer(id: 'a_07', name: 'Uzerrr (You)', isOnCourt: true),
        BasketballPlayer(id: 'a_10', name: 'Shirraj Deshpande', isOnCourt: true),
        BasketballPlayer(id: 'a_23', name: 'Atharv Kulkarni', isOnCourt: true),
        BasketballPlayer(id: 'a_30', name: 'Rohan Patil', isOnCourt: true),
        BasketballPlayer(id: 'a_45', name: 'Vedant Jadhav', isOnCourt: true),
      ];
    } else {
      return const [
        BasketballPlayer(id: 'b_08', name: 'Shirraj', isOnCourt: true),
        BasketballPlayer(id: 'b_11', name: 'Ganesh Akolkar', isOnCourt: true),
        BasketballPlayer(id: 'b_21', name: 'Pranav More', isOnCourt: true),
        BasketballPlayer(id: 'b_33', name: 'Yash Shelar', isOnCourt: true),
        BasketballPlayer(id: 'b_47', name: 'Omkar Jagtap', isOnCourt: true),
      ];
    }
  }

  String _getJerseyNum(BasketballPlayer p, int idx) {
    if (p.id.contains('_')) {
      final parts = p.id.split('_');
      if (parts.length > 1 && int.tryParse(parts[1]) != null) {
        return parts[1].padLeft(2, '0');
      }
    }
    final nums = [7, 10, 23, 30, 45, 8, 11, 21, 33, 47];
    return (nums[idx % nums.length]).toString().padLeft(2, '0');
  }

  void _onConfirmFoul() {
    widget.controller.recordFoul(
      _selectedTeam,
      playerFouledId: _selectedPlayerId,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final state = widget.controller.liveState.value;

    final homeName = widget.controller.currentMatch.value?.homeTeam.isNotEmpty == true
        ? widget.controller.currentMatch.value!.homeTeam
        : 'Side A';
    final awayName = widget.controller.currentMatch.value?.awayTeam.isNotEmpty == true
        ? widget.controller.currentMatch.value!.awayTeam
        : 'Side B';

    final teamFoulsA = state?.teamFoulsA ?? 0;
    final teamFoulsB = state?.teamFoulsB ?? 0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(18.0),
        vertical: ResponsiveHelper.h(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle Pill
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12.0)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // Header Row: Title + Close Button
          Row(
            children: [
              Text(
                'Record Foul',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: ResponsiveHelper.sp(20.0),
                  fontWeight: FontWeight.w900,
                ).responsive(context),
              ),
              const Spacer(),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  shape: const CircleBorder(),
                ),
                icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(14.0)),

          // Segmented Tab Switch: Personal Foul vs Technical Foul
          Container(
            height: ResponsiveHelper.h(46.0),
            padding: EdgeInsets.all(ResponsiveHelper.w(4.0)),
            decoration: BoxDecoration(
              color: const Color(0xFF181E2B),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(24.0)),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isTechnicalFoul = false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_isTechnicalFoul ? Colors.transparent : Colors.transparent,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                        border: Border.all(
                          color: !_isTechnicalFoul ? AppColors.accent : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Personal Foul',
                          style: AppTypography.labelCaps.copyWith(
                            color: !_isTechnicalFoul ? AppColors.accent : AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isTechnicalFoul = true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isTechnicalFoul ? Colors.transparent : Colors.transparent,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
                        border: Border.all(
                          color: _isTechnicalFoul ? AppColors.accent : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Technical Foul',
                          style: AppTypography.labelCaps.copyWith(
                            color: _isTechnicalFoul ? AppColors.accent : AppColors.mutedText,
                            fontSize: ResponsiveHelper.sp(12.0),
                            fontWeight: FontWeight.bold,
                          ).responsive(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(16.0)),

          // Scrollable List of Players per Team
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── SIDE A SECTION ───
                  _buildTeamSectionHeader(
                    context,
                    teamName: homeName,
                    teamFouls: teamFoulsA,
                    accentColor: AppColors.accent,
                  ),
                  SizedBox(height: ResponsiveHelper.h(10.0)),
                  ...List.generate(_sideAPlayers.length, (idx) {
                    final p = _sideAPlayers[idx];
                    return _buildPlayerFoulCard(
                      context,
                      player: p,
                      jerseyNum: _getJerseyNum(p, idx),
                      isSideA: true,
                      isSelected: _selectedTeam == 'sideA' && _selectedPlayerId == p.id,
                      onTap: () {
                        setState(() {
                          _selectedTeam = 'sideA';
                          _selectedPlayerId = p.id;
                        });
                      },
                    );
                  }),

                  SizedBox(height: ResponsiveHelper.h(16.0)),

                  // ─── SIDE B SECTION ───
                  _buildTeamSectionHeader(
                    context,
                    teamName: awayName,
                    teamFouls: teamFoulsB,
                    accentColor: const Color(0xFF4D96FF),
                  ),
                  SizedBox(height: ResponsiveHelper.h(10.0)),
                  ...List.generate(_sideBPlayers.length, (idx) {
                    final p = _sideBPlayers[idx];
                    return _buildPlayerFoulCard(
                      context,
                      player: p,
                      jerseyNum: _getJerseyNum(p, idx + 5),
                      isSideA: false,
                      isSelected: _selectedTeam == 'sideB' && _selectedPlayerId == p.id,
                      onTap: () {
                        setState(() {
                          _selectedTeam = 'sideB';
                          _selectedPlayerId = p.id;
                        });
                      },
                    );
                  }),

                  SizedBox(height: ResponsiveHelper.h(16.0)),

                  // Bottom Rule Box
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181E2B),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.accent,
                              size: ResponsiveHelper.w(18.0),
                            ),
                            SizedBox(width: ResponsiveHelper.w(8.0)),
                            Expanded(
                              child: Text(
                                'After 5 personal fouls, player is disqualified',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: ResponsiveHelper.sp(12.5),
                                  fontWeight: FontWeight.w600,
                                ).responsive(context),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(4.0)),
                        Padding(
                          padding: EdgeInsets.only(left: ResponsiveHelper.w(26.0)),
                          child: Text(
                            'Technical fouls are not counted in player total',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.mutedText,
                              fontSize: ResponsiveHelper.sp(11.5),
                            ).responsive(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(16.0)),
                ],
              ),
            ),
          ),

          // Bottom Action Button: RECORD FOUL
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(50.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
                ),
                elevation: 0,
              ),
              onPressed: _onConfirmFoul,
              child: Text(
                'RECORD FOUL',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ).responsive(context),
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(10.0)),
        ],
      ),
    );
  }

  Widget _buildTeamSectionHeader(
    BuildContext context, {
    required String teamName,
    required int teamFouls,
    required Color accentColor,
  }) {
    return Row(
      children: [
        Text(
          teamName,
          style: AppTypography.headlineSm.copyWith(
            color: accentColor,
            fontSize: ResponsiveHelper.sp(15.0),
            fontWeight: FontWeight.w900,
          ).responsive(context),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(10.0),
            vertical: ResponsiveHelper.h(4.0),
          ),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
            border: Border.all(color: accentColor.withValues(alpha: 0.4)),
          ),
          child: Text(
            'Team Fouls: $teamFouls',
            style: AppTypography.labelCaps.copyWith(
              color: accentColor,
              fontSize: ResponsiveHelper.sp(11.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerFoulCard(
    BuildContext context, {
    required BasketballPlayer player,
    required String jerseyNum,
    required bool isSideA,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final accentColor = isSideA ? AppColors.accent : const Color(0xFF4D96FF);

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(12.0),
              vertical: ResponsiveHelper.h(10.0),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141822),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14.0)),
              border: Border.all(
                color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.08),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Jersey Number Circle Badge
                Container(
                  width: ResponsiveHelper.w(36.0),
                  height: ResponsiveHelper.w(36.0),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      jerseyNum,
                      style: AppTypography.headlineSm.copyWith(
                        color: accentColor,
                        fontSize: ResponsiveHelper.sp(13.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),

                // Player Name & PF Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: ResponsiveHelper.sp(13.5),
                          fontWeight: FontWeight.bold,
                        ).responsive(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ResponsiveHelper.h(2.0)),
                      Row(
                        children: [
                          Text(
                            'PF: ',
                            style: AppTypography.labelCaps.copyWith(
                              color: AppColors.mutedText,
                              fontSize: ResponsiveHelper.sp(10.5),
                              fontWeight: FontWeight.bold,
                            ).responsive(context),
                          ),
                          Text(
                            '${player.personalFouls} / 5',
                            style: AppTypography.labelCaps.copyWith(
                              color: accentColor,
                              fontSize: ResponsiveHelper.sp(11.0),
                              fontWeight: FontWeight.w900,
                            ).responsive(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 5 Personal Foul Circles Indicator (1, 2, 3, 4, 5)
                Row(
                  children: List.generate(5, (circleIdx) {
                    final isFilled = circleIdx < player.personalFouls;
                    return Container(
                      margin: EdgeInsets.only(left: ResponsiveHelper.w(4.0)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ResponsiveHelper.w(14.0),
                            height: ResponsiveHelper.w(14.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? accentColor : Colors.transparent,
                              border: Border.all(
                                color: isFilled ? accentColor : AppColors.mutedText.withValues(alpha: 0.5),
                                width: 1.2,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.h(1.5)),
                          Text(
                            '${circleIdx + 1}',
                            style: TextStyle(
                              color: AppColors.mutedText,
                              fontSize: ResponsiveHelper.sp(8.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),

                SizedBox(width: ResponsiveHelper.w(10.0)),

                // Selection Checkmark Badge
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? accentColor : AppColors.mutedText.withValues(alpha: 0.3),
                  size: ResponsiveHelper.w(20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
