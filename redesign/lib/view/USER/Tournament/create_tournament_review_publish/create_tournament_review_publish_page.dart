import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/review_publish_controller.dart';
import '../venue_selection/widgets/progress_header.dart';
import 'widget/detail_card_widget.dart';
import 'widget/prize_pool_card.dart';
import 'widget/publish_setting_tile.dart';
// NOTE: registered_team_card.dart was removed because the file does not exist in widget/ directory.
import 'widget/tournament_banner_widget.dart';

class CreateTournamentReviewPublishPage extends StatefulWidget {
  const CreateTournamentReviewPublishPage({super.key});

  @override
  State<CreateTournamentReviewPublishPage> createState() =>
      _CreateTournamentReviewPublishPageState();
}

class _CreateTournamentReviewPublishPageState
    extends State<CreateTournamentReviewPublishPage> {
  late final ReviewPublishController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ReviewPublishController());
  }

  @override
  void dispose() {
    Get.delete<ReviewPublishController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.muted,
            size: ResponsiveHelper.w(24),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineMd.copyWith(color: AppColors.accent),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.muted,
              size: ResponsiveHelper.w(24),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.card, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ResponsiveHelper.h(32),
                      ), // pt-[80px] equivalent
                      // Progress Indicator
                      const ProgressHeader(
                        currentStep: 5,
                        totalSteps: 5,
                        title: "Step 5 of 5: Review & Publish",
                      ),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Banner
                      TournamentBannerWidget(
                        imageUrl: controller.bannerImageUrl,
                        title: controller.tournamentName,
                        type: controller.tournamentType,
                        category: controller.tournamentCategory,
                      ),

                      // Tournament Details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tournament Details",
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.editAll(context),
                            child: Text(
                              "EDIT ALL",
                              style: AppTypography.labelCaps.copyWith(
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(16)),

                      // Bento Grid
                      // On mobile we just stack them, on larger screens (tablet) we could wrap.
                      DetailCardWidget(
                        icon: Icons.location_on,
                        title: "Venue & Date",
                        value1: controller.venueName,
                        value2: controller.dateRange,
                      ),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      DetailCardWidget(
                        icon: Icons.account_tree,
                        title: "Format",
                        value1: controller.formatType,
                        value2: controller.formatDetails,
                      ),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      PrizePoolCard(
                        title: "Prize Pool",
                        total: controller.prizeTotal,
                        distribution: controller.prizeDistribution,
                      ),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      // Publish Settings
                      Text(
                        "Publish Settings",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      PublishSettingTile(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(16)),

                      // Copy Invite Link Button
                      InkWell(
                        onTap: controller.copyInviteLink,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.w(12),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.w(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.link,
                                color: AppColors.onPrimary,
                                size: ResponsiveHelper.w(24),
                              ),
                              SizedBox(width: ResponsiveHelper.w(8)),
                              Text(
                                "Copy Invite Link",
                                style: AppTypography.bodyLg.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.h(100),
                      ), // padding for bottom nav
                    ],
                  ),
                ),
              ),
            ),

            // Custom Bottom Navigation
            Container(
              height: ResponsiveHelper.h(96),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16),
                vertical: ResponsiveHelper.h(16),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(top: BorderSide(color: AppColors.card)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () => controller.goBack(context),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(12),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.h(16),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.w(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Back",
                            style: AppTypography.labelCaps.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(16)),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => controller.publishTournament(context),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.w(12),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveHelper.h(16),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.w(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Obx(() {
                          if (controller.isPublishing.value) {
                            return Center(
                              child: SizedBox(
                                width: ResponsiveHelper.w(20),
                                height: ResponsiveHelper.w(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.rocket_launch,
                                color: AppColors.background,
                                size: ResponsiveHelper.w(20),
                              ),
                              SizedBox(width: ResponsiveHelper.w(8)),
                              Flexible(
                                child: Text(
                                  "Publish Tournament",
                                  textAlign: TextAlign.center,
                                  style: AppTypography.headlineSm.copyWith(
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
