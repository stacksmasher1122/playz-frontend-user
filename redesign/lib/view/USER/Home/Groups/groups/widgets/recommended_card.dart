import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecommendedCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onJoin;

  const RecommendedCard({
    super.key,
    required this.group,
    required this.onJoin,
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: group.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: group.imageUrl,
                          width: avatarRadius * 2,
                          height: avatarRadius * 2,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: AppColors.surface,
                            child: const Icon(Icons.group, color: AppColors.muted),
                          ),
                          errorWidget: (_, __, ___) => CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: AppColors.surface,
                            child: const Icon(Icons.group, color: AppColors.muted),
                          ),
                        )
                      : CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.group, color: AppColors.muted),
                        ),
                ),
                if (group.isPlayZGlobalGroup)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1.5),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF1DB954),
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: context.widthPct(3.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          group.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (group.isPlayZGlobalGroup) ...[
                        SizedBox(width: context.widthPct(1)),
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF1DB954),
                          size: 15,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.4)),
                  Text(
                    '${group.members.length} MEMBERS • ${group.sport.toUpperCase()}',
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
              onPressed: onJoin,
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
                  group.isPublic ? 'JOIN' : 'REQUEST',
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
