import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'stadium_banner_widget.dart';
import 'info_card_widget.dart';

class VenueCardWidget extends StatelessWidget {
  const VenueCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KickoffSetupController>();

    return Obx(() {
      final venue = controller.venue.value;
      if (venue == null) return const SizedBox();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade900.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            StadiumBannerWidget(
              status: venue.status,
              venueName: venue.venueName,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoCardWidget(
                          label: 'FORMAT',
                          value: venue.format,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Weather', Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${venue.weatherTemp} ${venue.weatherCondition}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  )),
                  Divider(color: Colors.grey.shade800, height: 24),
                  _buildInfoRow('Match Official', Text(
                    venue.referee,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  )),
                  Divider(color: Colors.grey.shade800, height: 24),
                  _buildInfoRow('Recording System', Text(
                    venue.recordingSystem,
                    style: const TextStyle(color: Color(0xFFC6FF00), fontSize: 14, fontWeight: FontWeight.bold),
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
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        valueWidget,
      ],
    );
  }
}
