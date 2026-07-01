import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/player_info_controller.dart';

// Internal Widgets
import 'widgets/info_app_bar.dart';
import 'widgets/info_profile_image.dart';
import 'widgets/info_stat_card.dart';
import 'widgets/account_details_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color _kGreen = AppColors.accent;
Color _kBg = AppColors.surface;

class FriendsInfoScreen extends StatefulWidget {
  final String friendEmail;
  final String friendName;
  final String friendPic;
  final bool isOnline;

  FriendsInfoScreen({
    super.key,
    required this.friendEmail,
    required this.friendName,
    required this.friendPic,
    required this.isOnline,
  });

  @override
  State<FriendsInfoScreen> createState() => _FriendsInfoScreenState();
}

class _FriendsInfoScreenState extends State<FriendsInfoScreen> {
  late final PlayerInfoController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(PlayerInfoController());
    _ctrl.loadPlayerInfo(
      email: widget.friendEmail,
      name: widget.friendName,
      pic: widget.friendPic,
      isOnline: widget.isOnline,
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: _kBg,
      appBar: InfoAppBar(),
      body: Obx(() {
        if (_ctrl.isLoading.value || _ctrl.playerInfo.value == null) {
          return Center(
            child: CircularProgressIndicator(color: _kGreen),
          );
        }

        final info = _ctrl.playerInfo.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              // Profile Image
              InfoProfileImage(info: info),
              SizedBox(height: 20),

              // Name
              Text(
                info.fullName.isNotEmpty ? info.fullName : "Player",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(32),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),

              // Online Status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ResponsiveHelper.w(8),
                    height: ResponsiveHelper.h(8),
                    decoration: BoxDecoration(
                      color: info.isOnline ? _kGreen : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    info.isOnline ? "ONLINE NOW" : "OFFLINE",
                    style: TextStyle(
                      color: info.isOnline ? _kGreen : Colors.grey,
                      fontSize: ResponsiveHelper.sp(11),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Bio
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                child: Text(
                  info.bio,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: ResponsiveHelper.sp(14),
                    height: ResponsiveHelper.h(1.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: InfoStatCard(
                      icon: Icons.sports_soccer,
                      value: info.matchesPlayed.toString(),
                      label: "MATCHES PLAYED",
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InfoStatCard(
                      icon: Icons.bolt,
                      value: "${info.winRate}%",
                      label: "WIN RATE",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36),

              // Account Details Card (Header + List)
              AccountDetailsCard(info: info),
              SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
