import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;

class GroupRequestsAppBar extends StatelessWidget {
  GroupRequestsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: _kGreen,
              size: 26,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 4),
          Text(
            'Group Requests',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(22),
              fontWeight: FontWeight.w800,
            ),
          ),
          Spacer(),
          Obx(() => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: _kGreen, width: 1.5),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                ),
                child: Text(
                  '${ctrl.pendingGroupRequests.length} NEW',
                  style: TextStyle(
                    color: _kGreen,
                    fontSize: ResponsiveHelper.sp(12),
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
