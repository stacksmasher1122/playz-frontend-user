import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LogisticsCard extends StatelessWidget {
  LogisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF121212).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFF1E1E1E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: AppColors.accent, // Lime Green
              ),
              SizedBox(width: 8),
              Text(
                'LOGISTICS & VENUE',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'DATE & TIME',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => controller.selectDateTime(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
              decoration: BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                border: Border.all(color: Color(0xFF1E1E1E)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final date = controller.selectedDate.value;
                      if (date == null) {
                        return Text(
                          'dd-mm-yyyy --:--',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        );
                      }
                      final day = date.day.toString().padLeft(2, '0');
                      final month = date.month.toString().padLeft(2, '0');
                      final year = date.year;
                      final hour = date.hour.toString().padLeft(2, '0');
                      final minute = date.minute.toString().padLeft(2, '0');
                      return Text(
                        '$day-$month-$year $hour:$minute',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'VENUE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: controller.selectVenue,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
              decoration: BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                border: Border.all(color: Color(0xFF1E1E1E)),
              ),
              child: Row(
                children: [
                  Icon(Icons.stadium, color: Colors.grey, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      return Text(
                        controller.venue.value.isEmpty ? 'Select Venue' : controller.venue.value,
                        style: TextStyle(
                          color: controller.venue.value.isEmpty ? Colors.grey : Colors.white,
                          fontSize: ResponsiveHelper.sp(14),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'CHIEF REFEREE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            onChanged: controller.searchReferee,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Assign or search official...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: Color(0xFF121212),
              prefixIcon: Icon(Icons.directions_run, color: Colors.grey, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Color(0xFF1E1E1E)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Color(0xFF1E1E1E)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: AppColors.accent),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
            ),
          ),
        ],
      ),
    );
  }
}
