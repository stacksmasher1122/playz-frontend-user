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
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: context.responsiveFont(20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Create Tournament",
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.accent,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textPrimary,
              size: context.responsiveFont(22),
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
                    horizontal: context.widthPct(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.heightPct(2)),
                      const ProgressHeader(
                        currentStep: 5,
                        totalSteps: 5,
                        title: "Step 5 of 5: Review & Publish",
                      ),
                      SizedBox(height: context.heightPct(3)),

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
                          Expanded(
                            child: Text(
                              "Tournament Details",
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: context.responsiveFont(16),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.editAll(context),
                            child: Text(
                              "EDIT ALL",
                              style: AppTypography.labelCaps10.copyWith(
                                color: AppColors.accent,
                                fontSize: context.responsiveFont(12),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.heightPct(1.5)),

                      // Bento Grid Cards
                      DetailCardWidget(
                        icon: Icons.location_on_rounded,
                        title: "Venue & Date",
                        value1: controller.venueName,
                        value2: controller.dateRange,
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      DetailCardWidget(
                        icon: Icons.account_tree_rounded,
                        title: "Format",
                        value1: controller.formatType,
                        value2: controller.formatDetails,
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      PrizePoolCard(
                        title: "Prize Pool",
                        total: controller.prizeTotal,
                        distribution: controller.prizeDistribution,
                      ),
                      SizedBox(height: context.heightPct(3)),

                      // Publish Settings
                      Text(
                        "Publish Settings",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(1.5)),
                      PublishSettingTile(controller: controller),
                      SizedBox(height: context.heightPct(1.5)),

                      // Copy Invite Link Button
                      InkWell(
                        onTap: controller.copyInviteLink,
                        borderRadius: BorderRadius.circular(
                          context.minDimensionPct(3.5),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(context.widthPct(4)),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(
                              context.minDimensionPct(3.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.link_rounded,
                                color: AppColors.textPrimary,
                                size: context.responsiveFont(22),
                              ),
                              SizedBox(width: context.widthPct(2)),
                              Text(
                                "Copy Invite Link",
                                style: AppTypography.bodyLg.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: context.responsiveFont(14),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: context.heightPct(3)),
                    ],
                  ),
                ),
              ),
            ),

            // Custom Bottom Navigation
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4),
                vertical: context.heightPct(1.8),
              ),
              decoration: const BoxDecoration(
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
                        context.minDimensionPct(3.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: context.heightPct(1.5),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(
                            context.minDimensionPct(3.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Back",
                            style: AppTypography.labelCaps10.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(13.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.widthPct(3)),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () => controller.publishTournament(context),
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(3.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: context.heightPct(1.5),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(
                            context.minDimensionPct(3.5),
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
                                width: context.responsiveFont(20),
                                height: context.responsiveFont(20),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.background,
                                ),
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.rocket_launch_rounded,
                                color: AppColors.background,
                                size: context.responsiveFont(20),
                              ),
                              SizedBox(width: context.widthPct(2)),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Publish Tournament",
                                    textAlign: TextAlign.center,
                                    style: AppTypography.headlineSm.copyWith(
                                      color: AppColors.background,
                                      fontSize: context.responsiveFont(14.5),
                                      fontWeight: FontWeight.bold,
                                    ),
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
