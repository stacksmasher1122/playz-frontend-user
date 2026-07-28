import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
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
              Color(0xFF000000), // Pitch Black
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// GLOWING ICON CONTAINER
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00E676).withValues(alpha: 0.12),
                    border: Border.all(
                      color: const Color(0xFF00E676).withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E676).withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: Color(0xFF00E676),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 28),

                /// PILL BADGE
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00E676).withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    'TRAINER PORTAL',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF00E676),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// TITLE
                Text(
                  'Coming Soon',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),

                /// SUBTITLE / DESCRIPTION
                Text(
                  'We are building an all-in-one experience to discover certified coaches, personal trainers, and top sports academies near you.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),

                /// STATUS INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00E676),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Development in progress',
                      style: GoogleFonts.inter(
                        color: Colors.white54,
                        fontSize: 12,
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
          MyTrainersSection()
        else ...[
          OtherTrainersSection(),
          SliverToBoxAdapter(child: TrainerEndOfResults()),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ],
    );
  }
}
