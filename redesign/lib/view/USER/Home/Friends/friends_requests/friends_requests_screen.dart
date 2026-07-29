import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

// Internal Widgets
import 'widgets/friends_requests_app_bar.dart';
import 'widgets/request_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FriendsRequestsScreen extends StatelessWidget {
  const FriendsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<FriendsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            const FriendsRequestsAppBar(),

            SizedBox(height: context.heightPct(2)),

            // ── Divider ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              child: const Divider(color: AppColors.borderDark, height: 1),
            ),

            SizedBox(height: context.heightPct(2)),

            // ── Section Title ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              child: Row(
                children: [
                  Text(
                    'PENDING REQUESTS',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(width: context.widthPct(3)),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.borderDark,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.heightPct(2)),

            // ── Request Cards ──
            Expanded(
              child: Obx(() {
                final requests = ctrl.pendingRequests;

                if (requests.isEmpty) {
                  return Center(
                    child: Text(
                      'No pending requests',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(15),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
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
