import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

class SuggestedPlayersSection extends StatelessWidget {
  const SuggestedPlayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      if (ctrl.isLoadingSuggested.value && ctrl.suggestedPlayers.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        );
      }

      if (ctrl.suggestedPlayers.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Suggested Players'),
          ...ctrl.suggestedPlayers.map((player) {
            final name = (player['fullName'] ?? 'Player').toString();
            final level = (player['level'] ?? 'Intermediate').toString();
            final meta = (player['meta'] ?? 'Nearby').toString();
            final pic = (player['profileImageUrl'] ?? '').toString();

            return SuggestedPlayerCard(
              name: name,
              level: level,
              meta: meta,
              profilePicUrl: pic,
              onAddPressed: () {
                ctrl.sendFriendRequest(player);
                Get.snackbar(
                  'Request Sent',
                  'Friend request sent to $name',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.surface,
                  colorText: AppColors.textPrimary,
                  duration: const Duration(seconds: 2),
                );
              },
            );
          }),
        ],
      );
    });
  }
}

class SuggestedPlayerCard extends StatelessWidget {
  final String name;
  final String level;
  final String meta;
  final String profilePicUrl;
  final VoidCallback onAddPressed;

  const SuggestedPlayerCard({
    super.key,
    required this.name,
    required this.level,
    required this.meta,
    this.profilePicUrl = '',
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarSize = context.minDimensionPct(11).clamp(38.0, 48.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(0.6),
        context.widthPct(4),
        context.heightPct(0.6),
      ),
      child: Container(
        padding: EdgeInsets.all(context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: AppColors.card,
              backgroundImage: profilePicUrl.isNotEmpty
                  ? CachedNetworkImageProvider(profilePicUrl)
                  : null,
              child: profilePicUrl.isEmpty
                  ? const Icon(Icons.person, color: AppColors.muted)
                  : null,
            ),
            SizedBox(width: context.widthPct(3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(15),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: context.widthPct(1.5)),
                      LevelBadge(level),
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.3)),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt, color: AppColors.accent),
              onPressed: onAddPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  final String label;
  const LevelBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final isPro = label.toLowerCase() == 'pro' || label.toLowerCase() == 'legend';
    final color = isPro ? AppColors.accent : AppColors.muted;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(2),
        vertical: context.heightPct(0.4),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: AppTypography.labelCaps10.copyWith(
            color: color,
            fontSize: context.responsiveFont(11),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  const SectionHeader(this.title, {super.key, this.action});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(2),
        context.widthPct(4),
        context.heightPct(1),
      ),
      child: Row(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(16),
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (action != null)
            Text(
              action!,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                fontSize: context.responsiveFont(13),
              ),
            ),
        ],
      ),
    );
  }
}
