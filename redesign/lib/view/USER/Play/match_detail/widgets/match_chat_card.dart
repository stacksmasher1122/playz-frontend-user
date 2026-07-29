import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/Groups/groups_chat/groups_chat_screen.dart';

class MatchChatCard extends StatelessWidget {
  final String matchId;
  final String sport;
  final int memberCount;

  const MatchChatCard({
    super.key,
    required this.matchId,
    required this.sport,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.widthPct(2.5)),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
                child: const Icon(
                  Icons.forum_outlined,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              SizedBox(width: context.widthPct(3.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Match Discussion & Queries",
                      style: AppTypography.headlineSm.copyWith(
                        fontSize: context.responsiveFont(15),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.heightPct(0.3)),
                    Text(
                      "Chat with host & players before match time",
                      style: AppTypography.bodySm.copyWith(
                        fontSize: context.responsiveFont(12),
                        color: AppColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.8)),
          SizedBox(
            width: double.infinity,
            height: context.heightPct(5.5).clamp(44.0, 52.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                foregroundColor: AppColors.accent,
                elevation: 0,
                side: BorderSide(color: AppColors.accent.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupChatScreen(
                      groupId: matchId.isNotEmpty ? matchId : 'match_discussion',
                      groupName: '$sport Match Chat',
                      groupPic: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?q=80&w=200',
                      memberCount: memberCount > 0 ? memberCount : 1,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
              label: Text(
                'Open Match Chat Room',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: context.responsiveFont(13),
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
