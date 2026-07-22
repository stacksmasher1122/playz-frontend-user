import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ScoreboardHeader extends StatelessWidget {
  final MatchEngine engine;

  ScoreboardHeader({
    super.key,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(20)),
      color: kSurface,
      child: Column(
        children: [
          // Teams & Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamBlock(
                engine.homeTeam,
                engine.homeScore,
                CrossAxisAlignment.start,
              ),
              _buildClock(),
              _buildTeamBlock(
                engine.awayTeam,
                engine.awayScore,
                CrossAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClock() {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: engine.seconds,
          builder: (ctx, sec, _) {
            // Logic to display 45+2 etc
            int displaySec = sec;

            // Format mm:ss
            String min = (displaySec ~/ 60).toString().padLeft(2, '0');
            String s = (displaySec % 60).toString().padLeft(2, '0');

            return ValueListenableBuilder<int>(
              valueListenable: engine.addedSeconds,
              builder: (ctx, added, _) {
                String timeStr = "$min:$s";
                if (added > 0) {
                  timeStr +=
                      "+${(added ~/ 60) + 1}"; // Show +1 minute immediately
                }
                return Text(
                  timeStr,
                  style: TextStyle(
                    color: kAccent,
                    fontSize: ResponsiveHelper.sp(28),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                );
              },
            );
          },
        ),
        SizedBox(height: 4),
        ValueListenableBuilder<MatchPhase>(
          valueListenable: engine.phase,
          builder: (_, p, __) => _buildPhaseBadge(p),
        ),
      ],
    );
  }

  Widget _buildPhaseBadge(MatchPhase p) {
    String label = "PRE-MATCH";
    Color col = kTextSecondary;
    switch (p) {
      case MatchPhase.firstHalf:
        label = "1ST HALF";
        col = kSuccess;
        break;
      case MatchPhase.halfTime:
        label = "HALF TIME";
        col = kWarning;
        break;
      case MatchPhase.secondHalf:
        label = "2ND HALF";
        col = kSuccess;
        break;
      case MatchPhase.fullTime:
        label = "FULL TIME";
        col = kRed;
        break;
      default:
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: col.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: col, fontSize: ResponsiveHelper.sp(10), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTeamBlock(
    MatchTeam team,
    ValueNotifier<int> score,
    CrossAxisAlignment align,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            team.name,
            style: TextStyle(
              color: kTextSecondary,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.sp(14),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          ValueListenableBuilder<int>(
            valueListenable: score,
            builder: (_, val, __) => Text(
              "$val",
              style: TextStyle(
                color: kTextPrimary,
                fontSize: ResponsiveHelper.sp(48),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
