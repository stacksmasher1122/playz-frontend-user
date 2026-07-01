import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../theme/app_colors.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/setup_match_controller.dart';
import 'widgets/sm_appbar_widget.dart';
import 'widgets/sm_breadcrumb_widget.dart';
import 'widgets/sm_basic_info_card_widget.dart';
import 'widgets/sm_category_selector_widget.dart';
import 'widgets/sm_set_format_card_widget.dart';
import 'widgets/sm_match_settings_card_widget.dart';
import 'widgets/sm_create_button_widget.dart';
import 'widgets/sm_background_effect_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';


class SetupMatchScreen extends StatefulWidget {
  const SetupMatchScreen({super.key});

  @override
  State<SetupMatchScreen> createState() => _SetupMatchScreenState();
}

class _SetupMatchScreenState extends State<SetupMatchScreen> {
  late final SetupMatchController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SetupMatchController());
  }

  @override
  void dispose() {
    Get.delete<SetupMatchController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const SmBackgroundEffectWidget(),
          
          SafeArea(
            child: Column(
              children: [
                const SmAppbarWidget(),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmBreadcrumbWidget(),
                        const SmBasicInfoCardWidget(),
                        SizedBox(height: ResponsiveHelper.h(24)),
                        const SmCategorySelectorWidget(),
                        SizedBox(height: ResponsiveHelper.h(24)),
                        
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth >= 768) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(child: SmSetFormatCardWidget()),
                                  SizedBox(width: ResponsiveHelper.w(16)),
                                  const Expanded(child: SmMatchSettingsCardWidget()),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  const SmSetFormatCardWidget(),
                                  SizedBox(height: ResponsiveHelper.h(16)),
                                  const SmMatchSettingsCardWidget(),
                                ],
                              );
                            }
                          }
                        ),
                        
                        const SmCreateButtonWidget(),
                        // Bottom padding to ensure scroll clears the fixed bottom nav
                        SizedBox(height: ResponsiveHelper.h(100)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
