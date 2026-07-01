import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';

class PlayerSearchWidget extends StatelessWidget {
  PlayerSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballMatchStatisticsController>();

    return Container(
      margin: EdgeInsets.only(
        top: ResponsiveHelper.h(16),
        bottom: ResponsiveHelper.h(24),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Players...',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16),
            vertical: ResponsiveHelper.h(16),
          ),
        ),
        onChanged: controller.searchPlayers,
      ),
    );
  }
}
