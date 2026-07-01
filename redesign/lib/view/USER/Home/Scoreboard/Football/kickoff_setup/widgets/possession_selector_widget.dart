import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'possession_button_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PossessionSelectorWidget extends StatelessWidget {
  PossessionSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KickoffSetupController>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INITIAL POSSESSION',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: PossessionButtonWidget(
                      badgeText: 'A',
                      label: 'TEAM A',
                      isSelected: controller.selectedPossession.value == 'A',
                      onTap: () => controller.changePossession('A'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: PossessionButtonWidget(
                      badgeText: 'B',
                      label: 'TEAM B',
                      isSelected: controller.selectedPossession.value == 'B',
                      onTap: () => controller.changePossession('B'),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
