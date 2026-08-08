import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Chat-style Event Feed display section for Football Scoreboard.
/// Home team events align to the left, Away team events align to the right,
/// and neutral system events align to the center.
class EventFeed extends StatelessWidget {
  final MatchEngine engine;

  const EventFeed({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final events = engine.state.events;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16.0),
        vertical: ResponsiveHelper.h(12.0),
      ),
      sliver: events.isEmpty
          ? SliverToBoxAdapter(
              child: _buildSystemMessageCard(
                context,
                title: 'Match Started',
                subtitle: 'Kick Off',
                minuteStr: "0'",
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  if (index == events.length) {
                    return Padding(
                      padding: EdgeInsets.only(top: ResponsiveHelper.h(8.0)),
                      child: _buildSystemMessageCard(
                        context,
                        title: 'Match Started',
                        subtitle: 'Kick Off',
                        minuteStr: "0'",
                      ),
                    );
                  }
                  final event = events[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveHelper.h(10.0)),
                    child: _buildChatEventBubble(context, event),
                  );
                },
                childCount: events.length + 1,
              ),
            ),
    );
  }

  Widget _buildChatEventBubble(BuildContext context, MatchEvent event) {
    final bool isHome = (event.side == TeamSide.home);
    final bool isAway = (event.side == TeamSide.away);

    // Neutral / System Event -> Center Alignment
    if (!isHome && !isAway) {
      return _buildSystemMessageCard(
        context,
        title: event.title,
        subtitle: event.subtitle,
        minuteStr: "${event.displayMinute}'${event.addedMinute > 0 ? '+${event.addedMinute}' : ''}",
      );
    }

    // Team-Specific Event -> Left (Home) or Right (Away) Chat Bubble Alignment
    return Align(
      alignment: isHome ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.78,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(14.0),
          vertical: ResponsiveHelper.h(12.0),
        ),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveHelper.w(16.0)),
            topRight: Radius.circular(ResponsiveHelper.w(16.0)),
            bottomLeft: Radius.circular(isHome ? ResponsiveHelper.w(4.0) : ResponsiveHelper.w(16.0)),
            bottomRight: Radius.circular(isAway ? ResponsiveHelper.w(4.0) : ResponsiveHelper.w(16.0)),
          ),
          border: Border.all(
            color: isHome
                ? AppColors.accent.withValues(alpha: 0.4)
                : AppColors.error.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: isHome
            ? _buildLeftHomeLayout(context, event)
            : _buildRightAwayLayout(context, event),
      ),
    );
  }

  Widget _buildLeftHomeLayout(BuildContext context, MatchEvent event) {
    return Row(
      children: [
        // Event Icon Badge
        Container(
          width: ResponsiveHelper.w(36.0),
          height: ResponsiveHelper.w(36.0),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: event.color, width: 1.2),
          ),
          child: Icon(
            event.icon,
            color: event.color,
            size: ResponsiveHelper.w(18.0),
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(12.0)),

        // Event Title & Subtitle Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title,
                style: AppTypography.headlineSm.copyWith(
                  color: event.color,
                  fontSize: ResponsiveHelper.sp(14.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(2.0)),
              Text(
                event.subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(12.0),
                ).responsive(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        SizedBox(width: ResponsiveHelper.w(8.0)),
        // Minute Timestamp
        Text(
          "${event.displayMinute}'${event.addedMinute > 0 ? '+${event.addedMinute}' : ''}",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(13.0),
            fontWeight: FontWeight.w600,
            fontFamily: 'JetBrains Mono',
          ).responsive(context),
        ),
      ],
    );
  }

  Widget _buildRightAwayLayout(BuildContext context, MatchEvent event) {
    return Row(
      children: [
        // Minute Timestamp
        Text(
          "${event.displayMinute}'${event.addedMinute > 0 ? '+${event.addedMinute}' : ''}",
          style: AppTypography.bodySm.copyWith(
            color: AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(13.0),
            fontWeight: FontWeight.w600,
            fontFamily: 'JetBrains Mono',
          ).responsive(context),
        ),
        SizedBox(width: ResponsiveHelper.w(8.0)),

        // Event Title & Subtitle Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.title,
                style: AppTypography.headlineSm.copyWith(
                  color: event.color,
                  fontSize: ResponsiveHelper.sp(14.0),
                  fontWeight: FontWeight.bold,
                ).responsive(context),
              ),
              SizedBox(height: ResponsiveHelper.h(2.0)),
              Text(
                event.subtitle,
                textAlign: TextAlign.right,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.mutedText,
                  fontSize: ResponsiveHelper.sp(12.0),
                ).responsive(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(12.0)),

        // Event Icon Badge
        Container(
          width: ResponsiveHelper.w(36.0),
          height: ResponsiveHelper.w(36.0),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: event.color, width: 1.2),
          ),
          child: Icon(
            event.icon,
            color: event.color,
            size: ResponsiveHelper.w(18.0),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemMessageCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String minuteStr,
  }) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.88,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(14.0),
          vertical: ResponsiveHelper.h(10.0),
        ),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.w(32.0),
              height: ResponsiveHelper.w(32.0),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_rounded,
                color: AppColors.background,
                size: ResponsiveHelper.w(18.0),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(12.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: ResponsiveHelper.sp(14.0),
                      fontWeight: FontWeight.bold,
                    ).responsive(context),
                  ),
                  SizedBox(height: ResponsiveHelper.h(2.0)),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.mutedText,
                      fontSize: ResponsiveHelper.sp(12.0),
                    ).responsive(context),
                  ),
                ],
              ),
            ),
            Text(
              minuteStr,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(13.0),
                fontWeight: FontWeight.w600,
              ).responsive(context),
            ),
          ],
        ),
      ),
    );
  }
}
