import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

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
  final _controller = Get.find<UserProfileController>();
  bool showMyTrainers = true;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: SafeArea(
        top: true,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: TrainerDiscoveryHeader()),
            SliverToBoxAdapter(
              child: TrainersToggle(
                isMyTrainers: showMyTrainers,
                onChanged: (v) => setState(() => showMyTrainers = v),
              ),
            ),

            /// SWITCH
            if (showMyTrainers)
              const MyTrainersSection()
            else ...[
              const OtherTrainersSection(),
              const SliverToBoxAdapter(child: TrainerEndOfResults()),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ],
        ),
      ),
    );
  }
}
