import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

// Internal Widgets
import 'widgets/friends_requests_app_bar.dart';
import 'widgets/request_card.dart';

const kBg = AppColors.background;
const kMuted = Colors.white70;

class FriendsRequestsScreen extends StatelessWidget {
  const FriendsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FriendsController>();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            const FriendsRequestsAppBar(),

            const SizedBox(height: 20),

            // ── Divider ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.white12, height: 1),
            ),

            const SizedBox(height: 20),

            // ── Section Title ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'PENDING REQUESTS',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Request Cards ──
            Expanded(
              child: Obx(() {
                final requests = ctrl.pendingRequests;

                if (requests.isEmpty) {
                  return const Center(
                    child: Text(
                      'No pending requests',
                      style: TextStyle(color: kMuted, fontSize: 15),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return RequestCard(
                      request: req,
                      onApprove: () => ctrl.approveFriendRequest(req),
                      onDecline: () => ctrl.declineRequest(req),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
