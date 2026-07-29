import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Friends/friends_info/friends_info_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ChatAppBar extends StatelessWidget {
  final String email;
  final String name;
  final String pic;
  final bool isOnline;

  const ChatAppBar({
    super.key,
    required this.email,
    required this.name,
    required this.pic,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarRadius = context.minDimensionPct(5).clamp(18.0, 24.0);

    return Container(
      color: AppColors.background.withValues(alpha: 0.8),
      padding: EdgeInsets.fromLTRB(
        context.widthPct(2),
        context.heightPct(1.2),
        context.widthPct(3),
        context.heightPct(1.2),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FriendsInfoScreen(
                      friendEmail: email,
                      friendName: name,
                      friendPic: pic,
                      isOnline: isOnline,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: pic.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: pic,
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
                                  child: const Icon(Icons.person, color: AppColors.muted),
                                ),
                              )
                            : CircleAvatar(
                                radius: avatarRadius,
                                backgroundColor: AppColors.surface,
                                child: const Icon(Icons.person, color: AppColors.muted),
                              ),
                      ),
                      if (isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.background, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: context.widthPct(2.5)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(16),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isOnline ? "ONLINE" : "OFFLINE",
                          style: AppTypography.labelCaps10.copyWith(
                            color: isOnline ? AppColors.accent : AppColors.muted,
                            fontSize: context.responsiveFont(11),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.videocam_outlined,
              color: AppColors.textPrimary,
              size: 26,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
