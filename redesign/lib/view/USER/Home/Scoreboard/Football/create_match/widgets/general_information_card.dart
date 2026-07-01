import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GeneralInformationCard extends StatelessWidget {
  GeneralInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.w(4),
                height: ResponsiveHelper.h(16),
                color: Color(0xFFC6FF00), // Lime Green
              ),
              SizedBox(width: 8),
              Text(
                'GENERAL INFORMATION',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'MATCH NAME',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            onChanged: (val) => controller.matchName.value = val,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. PlayZ Champions Cup',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Colors.grey.shade800),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Color(0xFFC6FF00)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'TOURNAMENT',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Obx(() {
            return DropdownButtonFormField<String>(
              initialValue: controller.tournament.value.isEmpty ? null : controller.tournament.value,
              hint: Text(
                'Select Tournament',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              dropdownColor: Colors.grey.shade900,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  borderSide: BorderSide(color: Colors.grey.shade800),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                  borderSide: BorderSide(color: Color(0xFFC6FF00)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(14)),
              ),
              items: controller.tournamentOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: controller.selectTournament,
            );
          }),
        ],
      ),
    );
  }
}
