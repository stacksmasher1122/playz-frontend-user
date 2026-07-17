import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/match_stats_controller.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/match_stats_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MsSetBreakdownWidget extends StatelessWidget {
  MsSetBreakdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchStatsController>();

    return Obx(() {
      final stats = controller.stats.value;
      if (stats == null) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(24)),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SET BREAKDOWN',
              style: AppTypography.labelCaps.copyWith(color: AppColors.muted, letterSpacing: 2.0),
            ),
            SizedBox(height: 24),
            ...stats.setBreakdowns.map((set) => _buildSetRow(set)),
          ],
        ),
      );
    });
  }

  Widget _buildSetRow(SetBreakdownModel setModel) {
    final bool isS3 = setModel.setNumber == 3;
    final bgColor = AppColors.card.withValues(alpha: 0.5);
    final borderColor = isS3 ? AppColors.accent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.05);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        border: Border.all(color: borderColor),
        boxShadow: isS3 ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.1), blurRadius: 10)] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'S${setModel.setNumber}',
                style: AppTypography.headlineMd.copyWith(
                  color: setModel.isP1Winner ? AppColors.accent : AppColors.muted,
                ),
              ),
              SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${setModel.p1Score} — ${setModel.p2Score}',
                    style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'DURATION: ${setModel.duration}',
                    style: AppTypography.labelCaps.copyWith(color: AppColors.muted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
            decoration: BoxDecoration(
              color: setModel.isMatchPoint ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
              border: Border.all(color: setModel.isMatchPoint ? Colors.transparent : (setModel.isP1Winner ? AppColors.accent.withValues(alpha: 0.5) : AppColors.muted.withValues(alpha: 0.5))),
            ),
            child: Text(
              setModel.keyInsight,
              style: AppTypography.labelCaps.copyWith(
                color: setModel.isMatchPoint ? AppColors.background : (setModel.isP1Winner ? AppColors.accent : AppColors.muted),
                fontSize: ResponsiveHelper.sp(9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
