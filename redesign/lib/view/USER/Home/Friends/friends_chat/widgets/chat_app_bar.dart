import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Home/Friends/friends_info/friends_info_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kSurface = Color(0xFF222222);
const kMuted = Colors.white38;

class ChatAppBar extends StatelessWidget {
  final String email;
  final String name;
  final String pic;
  final bool isOnline;

  ChatAppBar({
    super.key,
    required this.email,
    required this.name,
    required this.pic,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      padding: EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
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
                      CircleAvatar(
                        radius: 19,
                        backgroundColor: kSurface,
                        backgroundImage: pic.isNotEmpty
                            ? CachedNetworkImageProvider(pic) as ImageProvider
                            : null,
                        child: pic.isEmpty
                            ? Icon(Icons.person, color: kMuted)
                            : null,
                      ),
                      if (isOnline)
                        Positioned(
                          right: ResponsiveHelper.w(0),
                          bottom: ResponsiveHelper.h(0),
                          child: Container(
                            width: ResponsiveHelper.w(12),
                            height: ResponsiveHelper.h(12),
                            decoration: BoxDecoration(
                              color: kGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isOnline ? "ONLINE" : "OFFLINE",
                        style: TextStyle(
                          color: isOnline ? kGreen : kMuted,
                          fontSize: ResponsiveHelper.sp(11),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.videocam_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
