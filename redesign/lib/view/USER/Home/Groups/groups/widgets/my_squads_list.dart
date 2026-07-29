import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'squad_list_tile.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MySquadsList extends StatelessWidget {
  const MySquadsList({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          if (ctrl.isLoading.value && ctrl.myGroups.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(4)),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            );
          }

          if (ctrl.myGroups.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.heightPct(4),
                horizontal: context.widthPct(4),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      color: AppColors.muted.withValues(alpha: 0.4),
                      size: 48,
                    ),
                    SizedBox(height: context.heightPct(1.5)),
                    Text(
                      'No groups yet',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: context.responsiveFont(15),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.5)),
                    Text(
                      'Create a group or join one to get started!',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ctrl.myGroups.length,
            separatorBuilder: (_, __) => Divider(
              height: context.heightPct(0.1),
              color: AppColors.borderDark,
              indent: context.widthPct(20),
              endIndent: context.widthPct(4),
            ),
            itemBuilder: (context, index) {
              final group = ctrl.myGroups[index];
              return SquadListTile(group: group);
            },
          );
        }),

        Divider(
          height: context.heightPct(0.1),
          color: AppColors.borderDark,
          indent: context.widthPct(20),
          endIndent: context.widthPct(4),
        ),
      ],
    );
  }
}
