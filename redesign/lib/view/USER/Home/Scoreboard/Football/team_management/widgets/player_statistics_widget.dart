import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_management/player_model.dart';
import 'package:redesign/theme/responsive_helper.dart';


class PlayerStatisticsWidget extends StatelessWidget {
  final PlayerModel player;

  PlayerStatisticsWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    // Determine which stats to show based on position
    final pos = player.position.toUpperCase();
    
    List<Widget> statWidgets = [];
    
    if (pos.contains('GK') || pos.contains('GOALKEEPER')) {
      statWidgets = [
        _buildStatCol('SAVES', '${player.statistics.saves}'),
        _buildStatCol('C.SHEETS', '${player.statistics.cleanSheets}'),
        _buildStatCol('RECOVERY', '${player.statistics.recovery}%', isRecovery: true),
      ];
    } else if (pos.contains('DEF') || pos.contains('CENTER BACK')) {
      statWidgets = [
        _buildStatCol('TACKLES', '${player.statistics.tackles}'),
        _buildStatCol('PASS %', '${player.statistics.passAccuracy}%'),
        _buildStatCol('HEALTH', player.fitness, isHealth: true),
      ];
    } else if (pos.contains('MID') || pos.contains('BOX-TO-BOX')) {
      statWidgets = [
        _buildStatCol('DIST.', '${player.statistics.distance}km'),
        _buildStatCol('SPRINTS', '${player.statistics.sprints}'),
        _buildStatCol('RATING', '${player.rating}', isRating: true),
      ];
    } else {
      // Default to attacker/forward
      statWidgets = [
        _buildStatCol('GOALS', '${player.statistics.goals}'),
        _buildStatCol('ASSISTS', '${player.statistics.assists}'),
        _buildStatCol('FORM', player.form, isForm: true),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: statWidgets,
      ),
    );
  }

  Widget _buildStatCol(String label, String value, {
    bool isHealth = false, 
    bool isRecovery = false,
    bool isForm = false,
    bool isRating = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: ResponsiveHelper.sp(9),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 8),
        if (isHealth)
          FitnessBadgeWidget(status: value)
        else if (isRecovery)
          FitnessBadgeWidget(status: 'RECOVERING', recoveryPercentage: value)
        else if (isForm)
          _buildFormIndicator()
        else if (isRating)
          Text(
            value,
            style: TextStyle(
              color: Color(0xFFC6FF00), // Lime Green
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.bold,
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildFormIndicator() {
    // 4 dots, some green, some grey based on form
    // Mocking based on player form string or just static for UI phase
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _formDot(true),
        SizedBox(width: 2),
        _formDot(true),
        SizedBox(width: 2),
        _formDot(true),
        SizedBox(width: 2),
        _formDot(false),
      ],
    );
  }

  Widget _formDot(bool good) {
    return Container(
      width: ResponsiveHelper.w(6),
      height: ResponsiveHelper.h(6),
      decoration: BoxDecoration(
        color: good ? Color(0xFFC6FF00) : Colors.grey.shade700,
        shape: BoxShape.circle,
      ),
    );
  }
}


class FitnessBadgeWidget extends StatelessWidget {
  final String? status;
  final String? recoveryPercentage;
  FitnessBadgeWidget({super.key, this.status, this.recoveryPercentage});
  @override
  Widget build(BuildContext context) => SizedBox();
}
