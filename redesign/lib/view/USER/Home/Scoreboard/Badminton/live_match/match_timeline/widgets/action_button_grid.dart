import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'ai_summary_button.dart';
import 'qr_share_button.dart';
import 'export_pdf_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ActionButtonGrid extends StatelessWidget {
  ActionButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchTimelineController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
      child: Obx(() {
        return Column(
          children: [
            AiSummaryButton(
              onTap: controller.generateAISummary,
              isLoading: controller.isGeneratingSummary.value,
            ),
            SizedBox(height: 12),
            QrShareButton(
              onTap: controller.shareQRCode,
            ),
            SizedBox(height: 12),
            ExportPdfButton(
              onTap: controller.exportPDF,
              isLoading: controller.isExporting.value,
            ),
          ],
        );
      }),
    );
  }
}
