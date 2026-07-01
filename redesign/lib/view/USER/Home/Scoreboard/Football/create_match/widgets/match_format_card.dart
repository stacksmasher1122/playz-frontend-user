import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_create_match_controller.dart';
import 'format_option_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchFormatCard extends StatelessWidget {
  MatchFormatCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballCreateMatchController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
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
                'MATCH FORMAT',
                style: TextStyle(
                  color: Color(0xFFC6FF00),
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Obx(() {
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                FormatOptionWidget(
                  title: '11v11',
                  subtitle: 'PROFESSIONAL',
                  isSelected: controller.selectedFormat.value == '11v11',
                  onTap: () => controller.selectMatchFormat('11v11'),
                ),
                FormatOptionWidget(
                  title: '7v7',
                  subtitle: 'MINI-SOCCER',
                  isSelected: controller.selectedFormat.value == '7v7',
                  onTap: () => controller.selectMatchFormat('7v7'),
                ),
                FormatOptionWidget(
                  title: '5v5',
                  subtitle: 'FUTSAL',
                  isSelected: controller.selectedFormat.value == '5v5',
                  onTap: () => controller.selectMatchFormat('5v5'),
                ),
                FormatOptionWidget(
                  title: 'Custom',
                  subtitle: 'USER DEFINED',
                  isSelected: controller.selectedFormat.value == 'Custom',
                  onTap: () => controller.selectMatchFormat('Custom'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
