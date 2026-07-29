import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/player_info_controller.dart';

// Internal Widgets
import 'widgets/info_app_bar.dart';
import 'widgets/info_profile_image.dart';
import 'widgets/info_stat_card.dart';
import 'widgets/account_details_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const InfoAppBar(),
      body: Obx(() {
        if (_ctrl.isLoading.value || _ctrl.playerInfo.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }

        final info = _ctrl.playerInfo.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(5),
            vertical: context.heightPct(1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.heightPct(1)),
              // Profile Image
              InfoProfileImage(info: info),
              SizedBox(height: context.heightPct(2.5)),

              // Name
              Text(
                info.fullName.isNotEmpty ? info.fullName : "Player",
                style: AppTypography.displayLg.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(26),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: context.heightPct(0.8)),

              // Online Status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: info.isOnline ? AppColors.accent : AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: context.widthPct(2)),
                  Text(
                    info.isOnline ? "ONLINE NOW" : "OFFLINE",
                    style: AppTypography.labelCaps10.copyWith(
                      color: info.isOnline ? AppColors.accent : AppColors.muted,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(2.5)),

              // Bio
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                child: Text(
                  info.bio,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(14),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: context.heightPct(3.5)),

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
                  SizedBox(width: context.widthPct(4)),
                  Expanded(
                    child: InfoStatCard(
                      icon: Icons.bolt,
                      value: "${info.winRate}%",
                      label: "WIN RATE",
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(4)),

              // Account Details Card (Header + List)
              AccountDetailsCard(info: info),
              SizedBox(height: context.heightPct(4)),
            ],
          ),
        );
      }),
    );
  }
}
