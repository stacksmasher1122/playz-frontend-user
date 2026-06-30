import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'ai_summary_button.dart';
import 'qr_share_button.dart';
import 'export_pdf_button.dart';

class ActionButtonGrid extends StatelessWidget {
  const ActionButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MatchTimelineController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Obx(() {
        return Column(
          children: [
            AiSummaryButton(
              onTap: controller.generateAISummary,
              isLoading: controller.isGeneratingSummary.value,
            ),
            const SizedBox(height: 12),
            QrShareButton(
              onTap: controller.shareQRCode,
            ),
            const SizedBox(height: 12),
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
