import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrainerEndOfResults extends StatelessWidget {
  const TrainerEndOfResults({super.key});

  static const _illustrationUrl =
      'https://illustrations.popsy.co/gray/fitness-trainer.svg';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final imageSize = context.minDimensionPct(28).clamp(90.0, 140.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(5),
        context.heightPct(4),
        context.widthPct(5),
        context.heightPct(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ILLUSTRATION (CACHED + SHIMMER)
          CachedNetworkImage(
            imageUrl: _illustrationUrl,
            height: imageSize,
            width: imageSize,
            fit: BoxFit.contain,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
              highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
              child: Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.fitness_center,
              size: imageSize * 0.6,
              color: AppColors.muted.withValues(alpha: 0.6),
            ),
          ),

          SizedBox(height: context.heightPct(2.5)),

          /// TITLE
          Text(
            'That’s all for now',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineLgMobile.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: context.heightPct(1)),

          /// SUBTITLE
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.widthPct(85)),
            child: Text(
              'No more trainers or academies found.\nTry a different sport or expand your filters.',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textSecondary,
                fontSize: context.responsiveFont(13),
                height: 1.4,
              ),
            ),
          ),

          SizedBox(height: context.heightPct(2.2)),

          /// CTA BUTTON
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: const BorderSide(color: AppColors.accent),
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(5),
                vertical: context.heightPct(1.2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Try Another Sport',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
