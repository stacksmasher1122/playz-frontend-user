import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Colors.white70;

class SuggestedPlayersSection extends StatelessWidget {
  SuggestedPlayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SectionHeader('Suggested Players', action: 'View Map'),
        SuggestedPlayerCard(
          name: 'Rahul S.',
          level: 'Intermediate',
          meta: '500m · Football',
        ),
        SuggestedPlayerCard(
          name: 'Sneha K.',
          level: 'Pro',
          meta: '1.2km · Badminton',
        ),
      ],
    );
  }
}

class SuggestedPlayerCard extends StatelessWidget {
  final String name;
  final String level;
  final String meta;

  SuggestedPlayerCard({
    super.key,
    required this.name,
    required this.level,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(14)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      LevelBadge(level),
                    ],
                  ),
                  Text(
                    meta,
                    style: TextStyle(color: kMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.person_add_alt, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  final String label;
  LevelBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final color = label == 'Pro' ? kGreen : kMuted;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(3)),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  SectionHeader(this.title, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: FontWeight.w800,
            ),
          ),
          Spacer(),
          if (action != null)
            Text(
              action!,
              style: TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
