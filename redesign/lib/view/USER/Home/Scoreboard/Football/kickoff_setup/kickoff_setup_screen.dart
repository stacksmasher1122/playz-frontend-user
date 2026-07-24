import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'widgets/kickoff_appbar.dart';
import 'widgets/side_selection_card.dart';
import 'widgets/possession_selector_widget.dart';
import 'widgets/venue_card_widget.dart';
import 'widgets/start_match_button_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class KickoffSetupScreen extends StatefulWidget {
  KickoffSetupScreen({super.key});

  @override
  State<KickoffSetupScreen> createState() => _KickoffSetupScreenState();
}

class _KickoffSetupScreenState extends State<KickoffSetupScreen>
    with TickerProviderStateMixin {
  late final KickoffSetupController controller;

  // Animation controllers for staggered entry
  late final AnimationController _entranceAnimController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(KickoffSetupController());
    controller.initialize();

    _entranceAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceAnimController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.05), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entranceAnimController,
            curve: Curves.easeOutCubic,
          ),
        );

    _entranceAnimController.forward();
  }

  @override
  void dispose() {
    _entranceAnimController.dispose();
    Get.delete<KickoffSetupController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KickoffAppbar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.accent, // Lime Green
            ),
          );
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SideSelectionCard(),
                  PossessionSelectorWidget(),
                  VenueCardWidget(),
                  StartMatchButtonWidget(
                    onTap: () => controller.startMatch(context),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
