import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportsRow extends StatelessWidget {
  const SportsRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = const [
      ('Cricket', Icons.sports_cricket),
      ('Football', Icons.sports_soccer),
      ('Badminton', Icons.sports_tennis),
      ('Basketball', Icons.sports_basketball),
    ];

    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < sports.length; i++) ...[
              _SportCard(name: sports[i].$1, icon: sports[i].$2),
              if (i != sports.length - 1) SizedBox(width: context.widthPct(3)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  final String name;
  final IconData icon;

  const _SportCard({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final minW = context.widthPct(35).clamp(130.0, 160.0);
    final maxW = context.widthPct(42).clamp(150.0, 185.0);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minW,
        maxWidth: maxW,
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(3)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 18),
                SizedBox(width: context.widthPct(2)),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: context.responsiveFont(14),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.heightPct(1.2)),

            /// ACTIONS
            _SportButton('Find Game', filled: true),
            SizedBox(height: context.heightPct(0.8)),
            _SportButton('Join Group', filled: false),
          ],
        ),
      ),
    );
  }
}

class _SportButton extends StatelessWidget {
  final String label;
  final bool filled;

  const _SportButton(this.label, {required this.filled});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.accent : Colors.transparent,
          foregroundColor: filled ? AppColors.background : AppColors.textPrimary,
          side: filled ? BorderSide.none : const BorderSide(color: AppColors.borderDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
          ),
          padding: EdgeInsets.symmetric(vertical: context.heightPct(1)),
        ),
        onPressed: () {},
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTypography.bodySm.copyWith(
              fontSize: context.responsiveFont(12),
              fontWeight: FontWeight.w600,
              color: filled ? AppColors.background : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
