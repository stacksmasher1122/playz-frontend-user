import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EventFeed extends StatelessWidget {
  final MatchEngine engine;

  EventFeed({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final events = engine.state.events;

    if (events.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            "No events yet.",
            style: TextStyle(color: AppColors.muted),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((ctx, i) {
        final event = events[i];
        bool isHome = event.side == TeamSide.home;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16),
            vertical: ResponsiveHelper.h(8),
          ),
          child: Row(
            mainAxisAlignment: isHome
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (!isHome) Expanded(child: SizedBox()),
              _buildEventBubble(event, isHome),
              if (isHome) Expanded(child: SizedBox()),
            ],
          ),
        );
      }, childCount: events.length),
    );
  }

  Widget _buildEventBubble(MatchEvent event, bool isHome) {
    return Container(
      width: ResponsiveHelper.w(220),
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(8)),
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(event.icon, color: event.color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        color: event.color,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.sp(14),
                      ),
                    ),
                    Text(
                      "\${event.displayMinute}'\${event.addedMinute > 0 ? '+\${event.addedMinute}' : ''}",
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: ResponsiveHelper.sp(12),
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  event.subtitle,
                  style: TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
