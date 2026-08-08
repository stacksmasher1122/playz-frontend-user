import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

/// Reusable Team Formation Card styled strictly using standard AppColors without any glow effects.
/// Features Team A name at the top, circular player slots, central VS divider, and Team B name at the bottom.
class CommonTeamFormationCard extends StatelessWidget {
  final String format; // 'SINGLES' or 'DOUBLES'
  final TextEditingController homeTeamController;
  final TextEditingController awayTeamController;
  final RxList<FriendModel> homeTeamRoster;
  final RxList<FriendModel> awayTeamRoster;
  final VoidCallback onSelectHomePlayer;
  final VoidCallback onSelectAwayPlayer;
  final Function(bool isHome, FriendModel friend)? onRemovePlayer;

  const CommonTeamFormationCard({
    super.key,
    required this.format,
    required this.homeTeamController,
    required this.awayTeamController,
    required this.homeTeamRoster,
    required this.awayTeamRoster,
    required this.onSelectHomePlayer,
    required this.onSelectAwayPlayer,
    this.onRemovePlayer,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final bool isDoubles = format == 'DOUBLES';
    final int requiredCount = isDoubles ? 2 : 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(22.0),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20.0)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // ─── 1. TOP OF CARD: SIDE A TEAM NAME INPUT FIELD ───
          TextField(
            controller: homeTeamController,
            textAlign: TextAlign.center,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(15.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12.0),
                vertical: ResponsiveHelper.h(8.0),
              ),
              hintText: 'Side A Name',
              hintStyle: TextStyle(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(14.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent, width: 1.5),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(18.0)),

          // ─── 2. SIDE A PLAYER SLOTS ROW (DYNAMICALLY REACTIVE) ───
          Obx(() {
            final roster = homeTeamRoster.toList();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(requiredCount, (index) {
                final friend = index < roster.length ? roster[index] : null;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8.0)),
                    child: _buildCircularPlayerSlot(
                      context,
                      isHome: true,
                      friend: friend,
                      onTap: onSelectHomePlayer,
                    ),
                  ),
                );
              }),
            );
          }),

          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── 3. CENTER: CLEAN VS DIVIDER (NO GLOW) ───
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1.0,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12.0)),
                width: ResponsiveHelper.w(44.0),
                height: ResponsiveHelper.w(44.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF181818),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.0),
                ),
                child: Center(
                  child: Text(
                    'VS',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: ResponsiveHelper.sp(13.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ).responsive(context),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1.0,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── 4. SIDE B PLAYER SLOTS ROW (DYNAMICALLY REACTIVE) ───
          Obx(() {
            final roster = awayTeamRoster.toList();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(requiredCount, (index) {
                final friend = index < roster.length ? roster[index] : null;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8.0)),
                    child: _buildCircularPlayerSlot(
                      context,
                      isHome: false,
                      friend: friend,
                      onTap: onSelectAwayPlayer,
                    ),
                  ),
                );
              }),
            );
          }),

          SizedBox(height: ResponsiveHelper.h(18.0)),

          // ─── 5. BOTTOM OF CARD: SIDE B TEAM NAME INPUT FIELD ───
          TextField(
            controller: awayTeamController,
            textAlign: TextAlign.center,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: ResponsiveHelper.sp(15.0),
              fontWeight: FontWeight.bold,
            ).responsive(context),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12.0),
                vertical: ResponsiveHelper.h(8.0),
              ),
              hintText: 'Side B Name',
              hintStyle: TextStyle(
                color: AppColors.mutedText,
                fontSize: ResponsiveHelper.sp(14.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.accent, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularPlayerSlot(
    BuildContext context, {
    required bool isHome,
    required FriendModel? friend,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: ResponsiveHelper.w(64.0),
                  height: ResponsiveHelper.w(64.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: friend != null ? AppColors.accent : Colors.white.withValues(alpha: 0.08),
                      width: friend != null ? 1.5 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: friend != null
                        ? (friend.profileImageUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: ResponsiveHelper.w(28.0),
                                backgroundImage: NetworkImage(friend.profileImageUrl),
                              )
                            : Text(
                                friend.fullName.isNotEmpty
                                    ? friend.fullName.substring(0, 1).toUpperCase()
                                    : 'P',
                                style: AppTypography.headlineSm.copyWith(
                                  color: AppColors.accent,
                                  fontSize: ResponsiveHelper.sp(20.0),
                                  fontWeight: FontWeight.w900,
                                ).responsive(context),
                              ))
                        : Icon(
                            Icons.add_rounded,
                            color: AppColors.accent,
                            size: ResponsiveHelper.w(30.0),
                          ),
                  ),
                ),
              ),
            ),

            // Remove Cross Button (✕) when player is selected
            if (friend != null && onRemovePlayer != null)
              Positioned(
                top: -2,
                right: -2,
                child: GestureRemoveButton(
                  onTap: () => onRemovePlayer!(isHome, friend),
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(8.0)),
        Text(
          friend != null
              ? (friend.fullName.isNotEmpty ? friend.fullName : friend.email)
              : 'Add Player',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTypography.bodySm.copyWith(
            color: friend != null ? AppColors.textPrimary : AppColors.mutedText,
            fontSize: ResponsiveHelper.sp(12.0),
            fontWeight: friend != null ? FontWeight.bold : FontWeight.w500,
          ).responsive(context),
        ),
      ],
    );
  }
}

class GestureRemoveButton extends StatelessWidget {
  final VoidCallback onTap;

  const GestureRemoveButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3.5),
        decoration: const BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.close_rounded,
          color: Colors.black,
          size: 13.0,
        ),
      ),
    );
  }
}
