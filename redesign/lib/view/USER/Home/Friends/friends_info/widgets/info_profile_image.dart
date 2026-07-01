import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/player_info_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color _kGreen = AppColors.accent;
Color _kBg = AppColors.surface;
Color _kSurface = Color(0xFF222222);
Color _kMuted = Colors.white60;

class InfoProfileImage extends StatelessWidget {
  final PlayerInfoModel info;

  InfoProfileImage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring
        Container(
          width: ResponsiveHelper.w(140),
          height: ResponsiveHelper.h(140),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kGreen, width: 3),
          ),
        ),
        // Inner image
        ClipOval(
          child: Container(
            width: ResponsiveHelper.w(124),
            height: ResponsiveHelper.h(124),
            color: _kSurface,
            child: info.profileImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: info.profileImageUrl,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.person, size: 60, color: _kMuted),
          ),
        ),
        // Online Badge
        if (info.isOnline)
          Positioned(
            bottom: ResponsiveHelper.h(4),
            right: ResponsiveHelper.w(4),
            child: Container(
              width: ResponsiveHelper.w(28),
              height: ResponsiveHelper.h(28),
              decoration: BoxDecoration(
                color: _kGreen,
                shape: BoxShape.circle,
                border: Border.all(color: _kBg, width: 5),
              ),
            ),
          ),
      ],
    );
  }
}
