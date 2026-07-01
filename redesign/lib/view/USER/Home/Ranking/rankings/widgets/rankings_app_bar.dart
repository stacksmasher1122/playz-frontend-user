import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kGreen = AppColors.accent;
Color kSurface = Color(0xFF0E0E0E);

class RankingsAppBar extends StatelessWidget {
  RankingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Rankings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(26),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Spacer(),
                const _HeaderIcon(Icons.share),
                SizedBox(width: 10),
                const _HeaderIcon(Icons.info_outline),
              ],
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
              decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              ),
              child: Text(
                'Season 12 · 14 days left',
                style: TextStyle(
                  color: kGreen,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(8)),
          decoration: BoxDecoration(
            color: kSurface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
