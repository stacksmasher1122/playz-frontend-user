import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Top Football Scoreboard Header Card featuring team circle initials, score below team,
/// timer, and phase pill strictly adhering to AppColors design tokens.
class ScoreboardHeader extends StatelessWidget {
  final MatchEngine engine;

  const ScoreboardHeader({super.key, required this.engine});

  String _getTeamInitials(String name) {
    final cleanName = name.trim().replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    final words = cleanName.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.length >= 3) {
      return (words[0][0] + words[1][0] + words[2][0]).toUpperCase();
    } else if (cleanName.length >= 3) {
      return cleanName.substring(0, 3).toUpperCase();
    } else {
      return cleanName.toUpperCase();
    }
  }

  String _getFormattedTime() {
    int totalSec = engine.state.seconds;
    int min = totalSec ~/ 60;
    int sec = totalSec % 60;
    String minStr = min.toString().padLeft(2, '0');
    String secStr = sec.toString().padLeft(2, '0');
    int added = engine.state.addedSeconds;
    String timeStr = "$minStr:$secStr";
    if (added > 0) {
      timeStr += "+${(added ~/ 60) + 1}";
    }
    return timeStr;
  }

  String _getPhaseText(MatchPhase p) {
    switch (p) {
      case MatchPhase.firstHalf:
        return "1ST HALF";
      case MatchPhase.halfTime:
        return "HALF TIME";
      case MatchPhase.secondHalf:
        return "2ND HALF";
      case MatchPhase.extraTimeFirst:
        return "ET 1ST HALF";
      case MatchPhase.extraTimeHalf:
        return "ET HALF TIME";
      case MatchPhase.extraTimeSecond:
        return "ET 2ND HALF";
      case MatchPhase.penalties:
        return "PENALTIES";
      case MatchPhase.fullTime:
        return "FULL TIME";
      default:
        return "PRE-MATCH";
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final homeTeam = engine.state.homeTeam;
    final awayTeam = engine.state.awayTeam;

    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.w(16.0)),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(18.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Team Column (Circle Initials -> Team Name -> Score Number)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTeamCircleAvatar(
                  context,
                  initials: _getTeamInitials(homeTeam.name),
                  imageUrl: homeTeam.logo,
                ),
                SizedBox(height: ResponsiveHelper.h(6.0)),
                Text(
                  homeTeam.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(12.0),
                  ).responsive(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveHelper.h(4.0)),
                Text(
                  '${engine.state.homeScore}',
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(34.0),
                    fontWeight: FontWeight.w900,
                  ).responsive(context),
                ),
              ],
            ),
          ),

          // Center Column (Digital Timer & Phase Badge)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getFormattedTime(),
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(28.0),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'JetBrains Mono',
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(8.0)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(10.0),
                  vertical: ResponsiveHelper.h(4.0),
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                  border: Border.all(color: AppColors.accent, width: 1.0),
                ),
                child: Text(
                  _getPhaseText(engine.state.phase),
                  style: AppTypography.labelCaps.copyWith(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(10.0),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ).responsive(context),
                ),
              ),
            ],
          ),

          // Right Team Column (Circle Initials -> Team Name -> Score Number)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTeamCircleAvatar(
                  context,
                  initials: _getTeamInitials(awayTeam.name),
                  imageUrl: awayTeam.logo,
                ),
                SizedBox(height: ResponsiveHelper.h(6.0)),
                Text(
                  awayTeam.name,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(12.0),
                  ).responsive(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ResponsiveHelper.h(4.0)),
                Text(
                  '${engine.state.awayScore}',
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: ResponsiveHelper.sp(34.0),
                    fontWeight: FontWeight.w900,
                  ).responsive(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCircleAvatar(
    BuildContext context, {
    required String initials,
    String? imageUrl,
  }) {
    final bool hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return Container(
      width: ResponsiveHelper.w(52.0),
      height: ResponsiveHelper.w(52.0),
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        image: hasImage
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: !hasImage
          ? Center(
              child: Text(
                initials,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ).responsive(context),
              ),
            )
          : null,
    );
  }
}
