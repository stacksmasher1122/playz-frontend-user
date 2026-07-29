import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/player_info_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class InfoProfileImage extends StatelessWidget {
  final PlayerInfoModel info;

  const InfoProfileImage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final outerSize = context.minDimensionPct(36).clamp(120.0, 150.0);
    final innerSize = outerSize - 16;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring
        Container(
          width: outerSize,
          height: outerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accent, width: 3),
          ),
        ),
        // Inner image
        ClipOval(
          child: Container(
            width: innerSize,
            height: innerSize,
            color: AppColors.surface,
            child: info.profileImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: info.profileImageUrl,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.person, size: 60, color: AppColors.muted),
          ),
        ),
        // Online Badge
        if (info.isOnline)
          Positioned(
            bottom: context.heightPct(0.5),
            right: context.widthPct(1),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 4),
              ),
            ),
          ),
      ],
    );
  }
}
