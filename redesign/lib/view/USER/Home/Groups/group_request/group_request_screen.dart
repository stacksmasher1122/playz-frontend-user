import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';

// Internal Widgets
import 'widgets/group_requests_app_bar.dart';
import 'widgets/group_request_card.dart';

const _kBg = AppColors.background;
const _kMuted = Colors.white70;

class GroupRequestScreen extends StatelessWidget {
  final String groupId;
  
  const GroupRequestScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<GroupsController>();

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            const GroupRequestsAppBar(),

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
                    'PENDING PLAYERS',
                    style: TextStyle(
                      color: _kMuted,
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
                final requests = ctrl.pendingGroupRequests;

                if (requests.isEmpty) {
                  return const Center(
                    child: Text(
                      'No pending requests for this group',
                      style: TextStyle(color: _kMuted, fontSize: 15),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return GroupRequestCard(
                      request: req,
                      onApprove: () => ctrl.approveGroupRequest(req),
                      onDecline: () => ctrl.declineGroupRequest(req),
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
