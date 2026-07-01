import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_team_management_controller.dart';
import 'widgets/team_management_appbar.dart';
import 'widgets/roster_header_widget.dart';
import 'widgets/bulk_import_button.dart';
import 'widgets/player_card_widget.dart';
import 'widgets/bottom_navigation_widget.dart';

class FootballTeamManagementScreen extends StatelessWidget {
  FootballTeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.put(FootballTeamManagementController());
    
    // Automatically initialize when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TeamManagementAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColors.accent));
        }
        
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16),
                    vertical: ResponsiveHelper.h(16)
                  ),
                  child: Column(
                    children: [
                      RosterHeaderWidget(),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      BulkImportButton(onTap: () => controller.bulkImport()),
                      SizedBox(height: ResponsiveHelper.h(16)),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.filteredPlayers.length,
                        separatorBuilder: (context, index) => SizedBox(height: ResponsiveHelper.h(12)),
                        itemBuilder: (context, index) {
                          return PlayerCardWidget(
                            player: controller.filteredPlayers[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavigationWidget(),
          ],
        );
      }),
    );
  }
}
