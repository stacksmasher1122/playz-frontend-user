import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';

class LogisticsCard extends StatelessWidget {
  const LogisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                color: const Color(0xFFC6FF00), // Lime Green
              ),
              const SizedBox(width: 8),
              const Text(
                'LOGISTICS & VENUE',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'DATE & TIME',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => controller.selectDateTime(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final date = controller.selectedDate.value;
                      if (date == null) {
                        return Text(
                          'dd-mm-yyyy --:--',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        );
                      }
                      final day = date.day.toString().padLeft(2, '0');
                      final month = date.month.toString().padLeft(2, '0');
                      final year = date.year;
                      final hour = date.hour.toString().padLeft(2, '0');
                      final minute = date.minute.toString().padLeft(2, '0');
                      return Text(
                        '$day-$month-$year $hour:$minute',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'VENUE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: controller.selectVenue,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stadium, color: Colors.grey, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      return Text(
                        controller.venue.value.isEmpty ? 'Select Venue' : controller.venue.value,
                        style: TextStyle(
                          color: controller.venue.value.isEmpty ? Colors.grey.shade600 : Colors.white,
                          fontSize: 14,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'CHIEF REFEREE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: controller.searchReferee,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Assign or search official...',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.3),
              prefixIcon: const Icon(Icons.directions_run, color: Colors.grey, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFC6FF00)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
