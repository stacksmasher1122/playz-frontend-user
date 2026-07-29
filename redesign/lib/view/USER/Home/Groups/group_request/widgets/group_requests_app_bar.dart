import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupRequestsAppBar extends StatelessWidget {
  const GroupRequestsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(1),
        context.heightPct(1),
        context.widthPct(4),
        0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.accent,
              size: 26,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: context.widthPct(1)),
          Expanded(
            child: Text(
              'Group Requests',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.displayLg.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(22),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Obx(() => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(3),
                  vertical: context.heightPct(0.6),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accent, width: 1.5),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${ctrl.pendingGroupRequests.length} NEW',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.accent,
                      fontSize: context.responsiveFont(12),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
