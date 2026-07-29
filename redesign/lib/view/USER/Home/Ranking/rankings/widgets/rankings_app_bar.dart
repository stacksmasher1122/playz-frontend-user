import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RankingsAppBar extends StatelessWidget {
  const RankingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.widthPct(4),
          context.heightPct(1.5),
          context.widthPct(4),
          context.heightPct(0.5),
        ),
        child: Row(
          children: [
            Text(
              'Rankings',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(24),
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            const _HeaderIcon(Icons.share),
            SizedBox(width: context.widthPct(2.5)),
            const _HeaderIcon(Icons.info_outline),
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
        borderRadius: BorderRadius.circular(999),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(context.widthPct(2)),
          decoration: const BoxDecoration(
            color: AppColors.card,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 18),
        ),
      ),
    );
  }
}
