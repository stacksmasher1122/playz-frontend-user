import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';

// Internal Widgets
import 'widgets/group_requests_app_bar.dart';
import 'widgets/group_request_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kBg = AppColors.background;
const _kMuted = Colors.white70;

class GroupRequestScreen extends StatelessWidget {
  final String groupId;
  
  GroupRequestScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            GroupRequestsAppBar(),

            SizedBox(height: 20),

            // ── Divider ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              child: Divider(color: Colors.white12, height: 1),
            ),

            SizedBox(height: 20),

            // ── Section Title ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
              child: Row(
                children: [
                  Text(
                    'PENDING PLAYERS',
                    style: TextStyle(
                      color: _kMuted,
                      fontSize: ResponsiveHelper.sp(13),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: ResponsiveHelper.h(1),
                      color: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // ── Request Cards ──
            Expanded(
              child: Obx(() {
                final requests = ctrl.pendingGroupRequests;

                if (requests.isEmpty) {
                  return Center(
                    child: Text(
                      'No pending requests for this group',
                      style: TextStyle(color: _kMuted, fontSize: 15),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  physics: BouncingScrollPhysics(),
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
