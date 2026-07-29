import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecommendedCard extends StatelessWidget {
  final String name;
  final String members;
  final String status;
  final String imageUrl;

  const RecommendedCard({
    super.key,
    required this.name,
    required this.members,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = context.minDimensionPct(6).clamp(20.0, 26.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(4)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                fit: BoxFit.cover,
                placeholder: (_, __) => CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.surface,
                ),
                errorWidget: (_, __, ___) => CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AppColors.surface,
                  child: const Icon(Icons.group, color: AppColors.muted),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(3.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.4)),
                  Text(
                    '$members • $status',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(10),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.widthPct(2)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                elevation: 0,
                minimumSize: const Size(64, 32),
                padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'JOIN',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.background,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
