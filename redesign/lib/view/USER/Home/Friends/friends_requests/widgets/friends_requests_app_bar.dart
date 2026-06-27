import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';

const kGreen = AppColors.accent;

class FriendsRequestsAppBar extends StatelessWidget {
  const FriendsRequestsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FriendsController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: kGreen,
              size: 26,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          const Text(
            'Requests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: kGreen, width: 1.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${ctrl.pendingRequests.length} NEW',
                  style: const TextStyle(
                    color: kGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
