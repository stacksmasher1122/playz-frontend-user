import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_rotation_subs_controller.dart';
import 'widgets/rotation_header.dart';
import 'widgets/rotation_court_widget.dart';
import 'widgets/action_buttons_row.dart';
import 'widgets/live_efficiency_card.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VolleyballRotationSubsScreen extends StatefulWidget {
  VolleyballRotationSubsScreen({super.key});

  @override
  State<VolleyballRotationSubsScreen> createState() => _VolleyballRotationSubsScreenState();
}

class _VolleyballRotationSubsScreenState extends State<VolleyballRotationSubsScreen> {
  late VolleyballRotationSubsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VolleyballRotationSubsController());
  }

  @override
  void dispose() {
    Get.delete<VolleyballRotationSubsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.sports_volleyball, color: AppColors.primaryContainer),
            SizedBox(width: 8),
            Text('PLAYZ SCOREBOARD', style: AppTypography.headlineMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveHelper.w(8),
                  height: ResponsiveHelper.h(8),
                  decoration: BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                ),
                SizedBox(width: 8),
                Text('LIVE', style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.account_circle, color: AppColors.muted),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(24.0)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RotationHeader(controller: controller),
                SizedBox(height: 24),
                
                RotationCourtWidget(controller: controller),
                SizedBox(height: 24),
                
                ActionButtonsRow(controller: controller),
                SizedBox(height: 16),
                
                LiveEfficiencyCard(),
                SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BENCH • AVAILABLE', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, letterSpacing: 1.5)),
                    Obx(() => Text('${controller.substitutionsUsed.value}/6 SUBS USED', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted))),
                  ],
                ),
                SizedBox(height: 16),
                // Show first two bench players as a quick preview
                Obx(() {
                  if (controller.benchPlayers.isEmpty) return SizedBox.shrink();
                  int count = controller.benchPlayers.length > 2 ? 2 : controller.benchPlayers.length;
                  return Column(
                    children: List.generate(count, (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: ResponsiveHelper.w(32),
                              height: ResponsiveHelper.h(32),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
                              ),
                              child: Center(
                                child: Text(controller.benchPlayers[index].jerseyNumber, style: AppTypography.bodySm.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.benchPlayers[index].name, style: AppTypography.bodyMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                  Text(controller.benchPlayers[index].position, style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontSize: 8)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
