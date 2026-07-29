import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/view/USER/More/edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());

    final avatarOuterSize = context.minDimensionPct(26).clamp(90.0, 116.0);
    final avatarInnerSize = context.minDimensionPct(24.5).clamp(84.0, 108.0);
    final editButtonSize = context.minDimensionPct(10).clamp(36.0, 44.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(18),
          ),
        ),
        centerTitle: true,
        actions: [
          /// Rounded Square Pen Edit Button
          Padding(
            padding: EdgeInsets.only(right: context.widthPct(4)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
                child: Container(
                  width: editButtonSize,
                  height: editButtonSize,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.accent,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.rxUser.value;
        final name = user?.fullName.isNotEmpty == true ? user!.fullName : 'PlayZ Athlete';
        final username = user?.effectiveUsername ?? '@player';
        final bio = user?.bio.isNotEmpty == true ? user!.bio : 'Sports Enthusiast & PlayZ Athlete 🏆';
        final imageUrl = user?.profileImageUrl ?? '';
        final currentXp = user?.xpPoints ?? 100;
        final tier = TierHelper.getTierFromXp(currentXp);
        final tierGradient = TierHelper.getTierGradient(tier);
        final subStatus = user?.subscriptionStatus ?? 'FREE';
        final isPremium = subStatus.toUpperCase().contains('PREMIUM');
        final sports = user?.favoriteSports ?? ['Cricket', 'Badminton', 'Football'];

        // Calculate next tier target
        int nextTierXp = 500;
        if (currentXp >= 7500) {
          nextTierXp = 10000;
        } else if (currentXp >= 3500) {
          nextTierXp = 7500;
        } else if (currentXp >= 1500) {
          nextTierXp = 3500;
        } else if (currentXp >= 500) {
          nextTierXp = 1500;
        }
        final double xpProgress = (currentXp / nextTierXp).clamp(0.0, 1.0);

        return ListView(
          padding: EdgeInsets.fromLTRB(
            context.widthPct(4),
            context.heightPct(1),
            context.widthPct(4),
            context.heightPct(5),
          ),
          children: [
            /// PROFILE AVATAR WITH TIER GRADIENT GLOW BORDER
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: avatarOuterSize,
                    height: avatarOuterSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: tierGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.25),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: avatarInnerSize,
                    height: avatarInnerSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipOval(
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Shimmer.fromColors(
                                  baseColor: AppColors.surfaceElevated,
                                  highlightColor: AppColors.borderDark,
                                  child: const CircleAvatar(backgroundColor: AppColors.card),
                                ),
                                errorWidget: (_, __, ___) => const CircleAvatar(
                                  backgroundColor: AppColors.card,
                                  child: Icon(Icons.person, color: AppColors.muted, size: 40),
                                ),
                              )
                            : const CircleAvatar(
                                backgroundColor: AppColors.card,
                                child: Icon(Icons.person, color: AppColors.muted, size: 40),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(1.8)),

            /// NAME & USERNAME
            Center(
              child: Text(
                name,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(20),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: context.heightPct(0.5)),
            Center(
              child: Text(
                username,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: context.responsiveFont(14),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: context.heightPct(1)),

            /// BIO / DESCRIPTION
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(6)),
              child: Text(
                bio,
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(13),
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: context.heightPct(2.5)),

            /// TIER & XP CARD
            Container(
              padding: EdgeInsets.all(context.widthPct(4.5)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// TIER PILL BADGE WITH TIER GRADIENT
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(3.5),
                          vertical: context.heightPct(0.8),
                        ),
                        decoration: BoxDecoration(
                          gradient: tierGradient,
                          borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          tier,
                          style: AppTypography.labelCaps10.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: context.responsiveFont(12),
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded, color: AppColors.coinsGold, size: 20),
                          SizedBox(width: context.widthPct(1)),
                          Text(
                            '$currentXp XP',
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.coinsGold,
                              fontWeight: FontWeight.bold,
                              fontSize: context.responsiveFont(16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tier Progress',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                      Text(
                        '$currentXp / $nextTierXp XP',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.8)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                    child: LinearProgressIndicator(
                      value: xpProgress,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(1.8)),

            /// SUBSCRIPTION STATUS CARD
            Container(
              padding: EdgeInsets.all(context.widthPct(4.5)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                border: Border.all(
                  color: isPremium ? AppColors.premiumGold : AppColors.borderDark,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.widthPct(3)),
                    decoration: BoxDecoration(
                      gradient: isPremium ? AppColors.tierZPremium : AppColors.tierRookie,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPremium ? Icons.workspace_premium_rounded : Icons.star_border_rounded,
                      color: isPremium ? AppColors.background : AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: context.widthPct(3.5)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium ? 'Z PREMIUM MEMBER' : 'FREE PLAYER PLAN',
                          style: AppTypography.headlineSm.copyWith(
                            color: isPremium ? AppColors.premiumGold : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.heightPct(0.3)),
                        Text(
                          isPremium
                              ? 'Unlimited Scoreboard sessions & VIP stats access'
                              : 'Upgrade to Z Premium for zero ads & priority slots',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(12),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(1.8)),

            /// SPORTS PLAYED SECTION
            Container(
              padding: EdgeInsets.all(context.widthPct(4.5)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_soccer_rounded, color: AppColors.accent, size: 20),
                      SizedBox(width: context.widthPct(2)),
                      Text(
                        'SPORTS PLAYED',
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(1.5)),
                  Wrap(
                    spacing: context.widthPct(2),
                    runSpacing: context.heightPct(1),
                    children: sports.map((sport) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(3.5),
                          vertical: context.heightPct(1),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          sport,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: context.responsiveFont(13),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
