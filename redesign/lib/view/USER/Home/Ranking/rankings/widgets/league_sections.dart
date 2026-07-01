import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kGreen = AppColors.accent;
Color kSurface = Color(0xFF0E0E0E);
Color kMuted = Color(0xFFA7A7A7);
Color kGold = Color(0xFFFFC107);
Color kRed = Color(0xFFE53935);

class GoldLeagueSection extends StatelessWidget {
  GoldLeagueSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return _LeagueSection(
      title: 'GOLD LEAGUE',
      icon: Icons.emoji_events,
      info: 'Top 10 players promote to Platinum League next week.',
      rows: [
        _RankRow(rank: 1, name: 'Rohan K.', pts: 2100, up: true),
        _RankRow(rank: 2, name: 'Priya S.', pts: 1950),
        _RankRow(rank: 3, name: 'Amit V.', pts: 1820, down: true),
      ],
    );
  }
}

class SilverLeagueSection extends StatelessWidget {
  SilverLeagueSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return _LeagueSection(
      title: 'SILVER LEAGUE',
      icon: Icons.shield,
      rows: [
        _RankRow(rank: 41, name: 'Vikram S.', pts: 1255),
        _RankRow(
          rank: 42,
          name: 'You',
          pts: 1240,
          highlight: true,
          up: true,
        ),
        _RankRow(rank: 43, name: 'Neha M.', pts: 1230, down: true),
      ],
    );
  }
}

class _LeagueSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? info;
  final List<Widget> rows;

  const _LeagueSection({
    required this.title,
    required this.icon,
    this.info,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Icon(icon, color: kGold, size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              Spacer(),
              if (info != null)
                Text(
                  'View Rules',
                  style: TextStyle(
                    color: kMuted,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
            ],
          ),

          if (info != null) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(12)),
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              ),
              child: Text(
                info!,
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
            ),
          ],

          SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final int rank;
  final String name;
  final int pts;
  final bool up;
  final bool down;
  final bool highlight;

  const _RankRow({
    required this.rank,
    required this.name,
    required this.pts,
    this.up = false,
    this.down = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: highlight ? kGreen.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Row(
        children: [
          Text('$rank',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          Text('$pts',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700)),
          SizedBox(width: 6),
          if (up)
            Icon(Icons.arrow_upward, size: 16, color: kGreen),
          if (down)
            Icon(Icons.arrow_downward, size: 16, color: kRed),
        ],
      ),
    );
  }
}
