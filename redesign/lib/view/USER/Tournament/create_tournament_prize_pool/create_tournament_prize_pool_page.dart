import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/prize_pool_controller.dart';
import '../venue_selection/widgets/bottom_navigation.dart';
import '../venue_selection/widgets/progress_header.dart';
import 'widget/entry_fee_card.dart';
import 'widget/prize_pool_card.dart';

class CreateTournamentPrizePoolPage extends StatefulWidget {
  const CreateTournamentPrizePoolPage({super.key});

  @override
  State<CreateTournamentPrizePoolPage> createState() => _CreateTournamentPrizePoolPageState();
}

class _CreateTournamentPrizePoolPageState extends State<CreateTournamentPrizePoolPage> {
  late final PrizePoolController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PrizePoolController());
  }

  @override
  void dispose() {
    Get.delete<PrizePoolController>();
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
          icon: Icon(Icons.arrow_back, color: AppColors.onPrimary, size: ResponsiveHelper.w(24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Tournament",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.onPrimary, size: ResponsiveHelper.w(24)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.card,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.h(16)),
                      const ProgressHeader(
                        currentStep: 4,
                        totalSteps: 6,
                        title: "Step 4 of 6: Prize Pool & Entry Fee",
                      ),
                      SizedBox(height: ResponsiveHelper.h(32)),

                      EntryFeeCard(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(24)),

                      PrizePoolCard(controller: controller),
                      SizedBox(height: ResponsiveHelper.h(32)),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavigation(
              onBack: () => controller.goBack(context),
              onNext: () => controller.goNext(context),
            ),
          ],
        ),
      ),
    );
  }
}
