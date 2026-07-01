import 'package:flutter/material.dart';
import '../football_scoreboard_screen.dart';

class EventFeed extends StatelessWidget {
  final MatchEngine engine;

  const EventFeed({
    super.key,
    required this.engine,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MatchEvent>>(
      valueListenable: engine.events,
      builder: (ctx, events, _) {
        if (events.isEmpty) {
          return const SliverFillRemaining(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: kDivider, width: 0.5)),
                color: kSurface,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.center,
                    child: Text(
                      e.timeLabel,
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: e.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(e.icon, size: 18, color: e.color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title,
                          style: const TextStyle(
                            color: kTextPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (e.subtitle.isNotEmpty)
                          Text(
                            e.subtitle,
                            style: const TextStyle(
                              color: kTextMuted,
                              fontSize: 12,
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
