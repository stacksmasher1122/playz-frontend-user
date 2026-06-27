import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/player_info_model.dart';

const Color _kGreen = AppColors.accent;
const Color _kBg = AppColors.surface;
const Color _kSurface = Color(0xFF222222);
const Color _kMuted = Colors.white60;

class InfoProfileImage extends StatelessWidget {
  final PlayerInfoModel info;

  const InfoProfileImage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer ring
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kGreen, width: 3),
          ),
        ),
        // Inner image
        ClipOval(
          child: Container(
            width: 124,
            height: 124,
            color: _kSurface,
            child: info.profileImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: info.profileImageUrl,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.person, size: 60, color: _kMuted),
          ),
        ),
        // Online Badge
        if (info.isOnline)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 28,
              height: 28,
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
