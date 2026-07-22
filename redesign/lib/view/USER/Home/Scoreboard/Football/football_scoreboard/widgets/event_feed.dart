import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EventFeed extends StatelessWidget {
  final MatchEngine engine;

  EventFeed({
    super.key,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ValueListenableBuilder<List<MatchEvent>>(
      valueListenable: engine.events,
      builder: (ctx, events, _) {
        if (events.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                "Waiting for Kick Off...",
                style: TextStyle(color: kTextSecondary),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final e = events[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: kDivider, width: 0.5)),
                color: kSurface,
              ),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(50),
                    alignment: Alignment.center,
                    child: Text(
                      e.timeLabel,
                      style: TextStyle(
                        color: kTextSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                    decoration: BoxDecoration(
                      color: e.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(e.icon, size: 18, color: e.color),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: TextStyle(
                            color: kTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (e.subtitle.isNotEmpty)
                          Text(
                            e.subtitle,
                            style: TextStyle(
                              color: kTextMuted,
                              fontSize: ResponsiveHelper.sp(12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, childCount: events.length),
        );
      },
    );
  }
}
