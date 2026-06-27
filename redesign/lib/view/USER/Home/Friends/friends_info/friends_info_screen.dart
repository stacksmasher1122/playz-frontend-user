import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/player_info_controller.dart';

// Internal Widgets
import 'widgets/info_app_bar.dart';
import 'widgets/info_profile_image.dart';
import 'widgets/info_stat_card.dart';
import 'widgets/account_details_card.dart';

const Color _kGreen = AppColors.accent;
const Color _kBg = AppColors.surface;

class FriendsInfoScreen extends StatefulWidget {
  final String friendEmail;
  final String friendName;
  final String friendPic;
  final bool isOnline;

  const FriendsInfoScreen({
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
    return Scaffold(
      backgroundColor: _kBg,
      appBar: const InfoAppBar(),
      body: Obx(() {
        if (_ctrl.isLoading.value || _ctrl.playerInfo.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: _kGreen),
          );
        }

        final info = _ctrl.playerInfo.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Profile Image
              InfoProfileImage(info: info),
              const SizedBox(height: 20),

              // Name
              Text(
                info.fullName.isNotEmpty ? info.fullName : "Player",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Online Status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: info.isOnline ? _kGreen : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    info.isOnline ? "ONLINE NOW" : "OFFLINE",
                    style: TextStyle(
                      color: info.isOnline ? _kGreen : Colors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bio
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  info.bio,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

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
                  const SizedBox(width: 16),
                  Expanded(
                    child: InfoStatCard(
                      icon: Icons.bolt,
                      value: "${info.winRate}%",
                      label: "WIN RATE",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Account Details Card (Header + List)
              AccountDetailsCard(info: info),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
