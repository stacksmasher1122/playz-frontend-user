import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreboardHeader extends StatelessWidget {
  final MatchEngine engine;

  ScoreboardHeader({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(20),
      ),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamBlock(
                engine.state.homeTeam,
                engine.state.homeScore,
                engine.state.homeTeam.penaltiesScored,
                CrossAxisAlignment.start,
              ),
              _buildClock(),
              _buildTeamBlock(
                engine.state.awayTeam,
                engine.state.awayScore,
                engine.state.awayTeam.penaltiesScored,
                CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClock() {
    int added = engine.state.addedSeconds;
    String timeStr = "\$min:\$s";
    if (added > 0) {
      timeStr += "+\${(added ~/ 60) + 1}";
    }

    return Column(
      children: [
        Text(
          timeStr,
          style: TextStyle(
            color: AppColors.accent,
            fontSize: ResponsiveHelper.sp(28),
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrains Mono',
          ),
        ),
        SizedBox(height: 4),
        _buildPhaseBadge(engine.state.phase),
      ],
    );
  }

  Widget _buildPhaseBadge(MatchPhase p) {
    String label = "PRE-MATCH";
    Color col = AppColors.muted;
    switch (p) {
      case MatchPhase.firstHalf:
        label = "1ST HALF";
        col = AppColors.success;
        break;
      case MatchPhase.halfTime:
        label = "HALF TIME";
        col = AppColors.warning;
        break;
      case MatchPhase.secondHalf:
        label = "2ND HALF";
        col = AppColors.success;
        break;
      case MatchPhase.extraTimeFirst:
        label = "ET 1ST HALF";
        col = Colors.purpleAccent;
        break;
      case MatchPhase.extraTimeHalf:
        label = "ET HALF TIME";
        col = AppColors.warning;
        break;
      case MatchPhase.extraTimeSecond:
        label = "ET 2ND HALF";
        col = Colors.purpleAccent;
        break;
      case MatchPhase.penalties:
        label = "PENALTIES";
        col = Colors.cyanAccent;
        break;
      case MatchPhase.fullTime:
        label = "FULL TIME";
        col = AppColors.error;
        break;
      default:
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(8),
        vertical: ResponsiveHelper.h(2),
      ),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
        border: Border.all(color: col.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: col,
          fontSize: ResponsiveHelper.sp(10),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTeamBlock(
    MatchTeam team,
    int score,
    int penScore,
    CrossAxisAlignment align,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            team.name,
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.sp(14),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (align == CrossAxisAlignment.end &&
                  engine.state.phase == MatchPhase.penalties)
                Padding(
                  padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: Text(
                    "(\$penScore)",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                ),
              Text(
                "\$score",
                style: TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: ResponsiveHelper.sp(48),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
              if (align == CrossAxisAlignment.start &&
                  engine.state.phase == MatchPhase.penalties)
                Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "(\$penScore)",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
