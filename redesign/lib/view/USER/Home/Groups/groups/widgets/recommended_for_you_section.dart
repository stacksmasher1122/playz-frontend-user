import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'recommended_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecommendedForYouSection extends StatelessWidget {
  const RecommendedForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<GroupsController>();

    return Obx(() {
      if (controller.isLoadingRecommended.value) {
        return Container(
          color: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      }

      if (controller.recommendedGroups.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        color: AppColors.background,
        padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
        margin: EdgeInsets.symmetric(vertical: context.heightPct(0.8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECOMMENDED FOR YOU',
                    style: AppTypography.labelCaps10.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(12),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.fetchRecommendedGroups(),
                    child: Text(
                      'REFRESH',
                      style: AppTypography.labelCaps10.copyWith(
                        color: AppColors.accent,
                        fontSize: context.responsiveFont(11),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(1.5)),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recommendedGroups.length.clamp(0, 5),
              separatorBuilder: (_, __) =>
                  SizedBox(height: context.heightPct(1.2)),
              itemBuilder: (context, index) {
                final group = controller.recommendedGroups[index];
                return RecommendedCard(
                  group: group,
                  onJoin: () {
                    if (group.isPublic) {
                      controller.joinPublicGroup(group);
                    } else {
                      controller.requestToJoinGroup(group);
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }
}
