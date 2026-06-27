import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kGreen = AppColors.accent;
const Color kSurface = Color(0xFF0E0E0E);
const Color kMuted = Color(0xFFA7A7A7);
const Color kGold = Color(0xFFFFC107);
const Color kSilver = Color(0xFFB0BEC5);
const Color kBronze = Color(0xFFCD7F32);

class UserRankCard extends StatelessWidget {
  const UserRankCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/32.jpg',
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('#42',
                        style: TextStyle(
                            color: kGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    Text('Global Rank',
                        style: TextStyle(color: kMuted, fontSize: 12)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 14),
            const _ProgressBar(
              current: 1240,
              target: 1500,
              label: 'Target: Gold (1,500)',
            ),
            const SizedBox(height: 10),
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
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('$current pts',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(label,
                style: const TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: const AlwaysStoppedAnimation(kGreen),
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
    final trends = [true, true, false, true, false]; // mock

    return Row(
      children: [
        const Text(
          'Top 15% (Rising)',
          style: TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Row(
          children: trends.map((up) {
            return Container(
              margin: const EdgeInsets.only(left: 6),
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                color: up ? kGreen : kMuted.withOpacity(0.4),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
