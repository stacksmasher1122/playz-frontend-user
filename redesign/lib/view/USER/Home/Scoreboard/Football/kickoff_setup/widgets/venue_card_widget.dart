import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'stadium_banner_widget.dart';
import 'info_card_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueCardWidget extends StatelessWidget {
  VenueCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KickoffSetupController>();

    return Obx(() {
      final venue = controller.venue.value;
      if (venue == null) return SizedBox();

      return Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
        decoration: BoxDecoration(
          color: Color(0xFF121212).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Color(0xFF1E1E1E)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            StadiumBannerWidget(
              status: venue.status,
              venueName: venue.venueName,
            ),
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InfoCardWidget(
                          label: 'DURATION',
                          value: '${venue.duration} MINS',
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InfoCardWidget(
                          label: 'FORMAT',
                          value: venue.format,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('Weather', Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_outlined, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        '${venue.weatherTemp} ${venue.weatherCondition}',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  )),
                  Divider(color: Color(0xFF1E1E1E), height: 24),
                  _buildInfoRow('Match Official', Text(
                    venue.referee,
                    style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.sp(14), fontWeight: FontWeight.bold),
                  )),
                  Divider(color: Color(0xFF1E1E1E), height: 24),
                  _buildInfoRow('Recording System', Text(
                    venue.recordingSystem,
                    style: TextStyle(color: AppColors.accent, fontSize: ResponsiveHelper.sp(14), fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, Widget valueWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
        valueWidget,
      ],
    );
  }
}
