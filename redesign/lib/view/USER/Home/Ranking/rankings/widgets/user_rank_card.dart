import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kGreen = AppColors.accent;
Color kSurface = Color(0xFF0E0E0E);
Color kMuted = Color(0xFFA7A7A7);
Color kGold = Color(0xFFFFC107);
Color kSilver = Color(0xFFB0BEC5);
Color kBronze = Color(0xFFCD7F32);

class UserRankCard extends StatelessWidget {
  UserRankCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(22)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      _LeaguePill('SILVER'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('#42',
                        style: TextStyle(
                            color: kGreen,
                            fontSize: ResponsiveHelper.sp(24),
                            fontWeight: FontWeight.w800)),
                    Text('Global Rank',
                        style: TextStyle(color: kMuted, fontSize: 12)),
                  ],
                )
              ],
            ),
            SizedBox(height: 14),
            const _ProgressBar(
              current: 1240,
              target: 1500,
              label: 'Target: Gold (1,500)',
            ),
            SizedBox(height: 10),
            const _TrendRow(),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int target;
  final String label;

  const _ProgressBar({
    required this.current,
    required this.target,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$current pts',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            Spacer(),
            Text(label,
                style: TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation(kGreen),
          ),
        ),
      ],
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final trends = [true, true, false, true, false]; // mock

    return Row(
      children: [
        Text(
          'Top 15% (Rising)',
          style: TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
        Spacer(),
        Row(
          children: trends.map((up) {
            return Container(
              margin: EdgeInsets.only(left: 6),
              height: ResponsiveHelper.h(6),
              width: ResponsiveHelper.w(6),
              decoration: BoxDecoration(
                color: up ? kGreen : kMuted.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _LeaguePill extends StatelessWidget {
  final String label;
  const _LeaguePill(this.label);

  Color get color {
    switch (label) {
      case 'GOLD':
        return kGold;
      case 'SILVER':
        return kSilver;
      case 'BRONZE':
        return kBronze;
      default:
        return kMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: ResponsiveHelper.sp(11),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
