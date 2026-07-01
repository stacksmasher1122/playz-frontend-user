import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;
const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;

class OnlineNowSection extends StatelessWidget {
  OnlineNowSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      final onlineFriends = ctrl.friends.take(4).toList();

      if (onlineFriends.isEmpty) {
        return SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Online Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(20),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.h(110),
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              scrollDirection: Axis.horizontal,
              itemCount: onlineFriends.length,
              itemBuilder: (_, i) => OnlineAvatar(
                name: onlineFriends[i].fullName.split(' ').first,
                imageUrl: onlineFriends[i].profileImageUrl,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class OnlineAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  OnlineAvatar({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: kGreen.withAlpha(76),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(ResponsiveHelper.w(3)),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                      : null,
                  backgroundColor: kSurface,
                ),
              ),
              Positioned(
                bottom: ResponsiveHelper.h(2),
                right: ResponsiveHelper.w(2),
                child: Container(
                  height: ResponsiveHelper.h(14),
                  width: ResponsiveHelper.w(14),
                  decoration: BoxDecoration(
                    color: kGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBg, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
