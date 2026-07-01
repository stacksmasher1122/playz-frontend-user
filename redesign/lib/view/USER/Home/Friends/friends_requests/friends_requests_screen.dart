import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

// Internal Widgets
import 'widgets/friends_requests_app_bar.dart';
import 'widgets/request_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBg = AppColors.background;
const kMuted = Colors.white70;

class FriendsRequestsScreen extends StatelessWidget {
  FriendsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            FriendsRequestsAppBar(),

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
                    'PENDING REQUESTS',
                    style: TextStyle(
                      color: kMuted,
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
                final requests = ctrl.pendingRequests;

                if (requests.isEmpty) {
                  return Center(
                    child: Text(
                      'No pending requests',
                      style: TextStyle(color: kMuted, fontSize: 15),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  physics: BouncingScrollPhysics(),
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
