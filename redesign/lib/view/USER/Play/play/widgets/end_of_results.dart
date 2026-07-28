import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EndOfResults extends StatelessWidget {
  const EndOfResults({super.key});

  static const _illustrationUrl =
      'https://illustrations.popsy.co/gray/sporty-man.svg';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final imageSize = context.minDimensionPct(28).clamp(90.0, 140.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(5),
        context.heightPct(4),
        context.widthPct(5),
        context.heightPct(5),
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
              Icons.sports_soccer,
              size: imageSize * 0.6,
              color: AppColors.muted.withValues(alpha: 0.6),
            ),
          ),

          SizedBox(height: context.heightPct(2.5)),

          /// TITLE
          Text(
            'You’ve reached the end!',
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
            constraints: BoxConstraints(maxWidth: context.widthPct(80)),
            child: Text(
              'No more matches nearby. Try expanding your search radius or host a match!',
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
        ],
      ),
    );
  }
}
