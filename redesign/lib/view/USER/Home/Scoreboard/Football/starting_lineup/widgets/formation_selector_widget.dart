import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/starting_lineup_controller.dart';
import 'formation_chip_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormationSelectorWidget extends StatelessWidget {
  FormationSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<StartingLineupController>();

    return SizedBox(
      height: ResponsiveHelper.h(50),
      child: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          scrollDirection: Axis.horizontal,
          itemCount: controller.formations.length,
          itemBuilder: (context, index) {
            final formation = controller.formations[index];
            return FormationChipWidget(
              name: formation,
              isSelected: controller.selectedFormation.value == formation,
              onTap: () => controller.changeFormation(formation),
            );
          },
        );
      }),
    );
  }
}
