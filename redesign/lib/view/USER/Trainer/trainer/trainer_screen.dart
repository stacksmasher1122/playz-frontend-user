import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/responsive_helper.dart';

import 'widgets/trainer_discovery_header.dart';
import 'widgets/trainers_toggle.dart';
import 'widgets/my_trainers_section.dart';
import 'widgets/other_trainers_section.dart';
import 'widgets/trainer_end_of_results.dart';

class TrainerDiscoveryScreen extends StatefulWidget {
  const TrainerDiscoveryScreen({super.key});

  @override
  State<TrainerDiscoveryScreen> createState() => _TrainerDiscoveryScreenState();
}

class _TrainerDiscoveryScreenState extends State<TrainerDiscoveryScreen> {
  late final UserProfileController _controller;
  bool showMyTrainers = true;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<UserProfileController>()
        ? Get.find<UserProfileController>()
        : Get.put(UserProfileController());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final iconContainerSize = context.minDimensionPct(22).clamp(76.0, 96.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF003819), // Rich Deep Emerald Green
              Color(0xFF001F0E), // Soft Dark Green
              AppColors.background,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(7)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// GLOWING ICON CONTAINER
                Container(
                  width: iconContainerSize,
                  height: iconContainerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: AppColors.accent,
                    size: iconContainerSize * 0.46,
                  ),
                ),
                SizedBox(height: context.heightPct(3)),

                /// PILL BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(4),
                    vertical: context.heightPct(0.7),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'TRAINER PORTAL',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(11),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(2)),

                /// TITLE
                Text(
                  'Coming Soon',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.displayLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(32),
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: context.heightPct(1.5)),

                /// SUBTITLE / DESCRIPTION
                Text(
                  'We are building an all-in-one experience to discover certified coaches, personal trainers, and top sports academies near you.',
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: context.responsiveFont(14),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: context.heightPct(3.5)),

                /// STATUS INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                    ),
                    SizedBox(width: context.widthPct(2)),
                    Text(
                      'Development in progress',
                      style: AppTypography.bodyXs.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Preserved original screen UI layout for future activation
  Widget buildOriginalView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: TrainerDiscoveryHeader()),
        SliverToBoxAdapter(
          child: TrainersToggle(
            isMyTrainers: showMyTrainers,
            onChanged: (v) => setState(() => showMyTrainers = v),
          ),
        ),
        if (showMyTrainers)
          const MyTrainersSection()
        else ...[
          OtherTrainersSection(),
          SliverToBoxAdapter(child: TrainerEndOfResults()),
          SliverToBoxAdapter(child: SizedBox(height: context.heightPct(5))),
        ],
      ],
    );
  }
}
