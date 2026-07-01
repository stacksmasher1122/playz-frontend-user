import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/pickleball_initialize_match_controller.dart';
import 'widgets/pickleball_appbar.dart';
import 'widgets/match_core_card.dart';
import 'widgets/category_chip_group.dart';
import 'widgets/format_chip_group.dart';
import 'widgets/custom_rules_card.dart';
import 'widgets/advanced_options_card.dart';
import 'widgets/primary_action_button.dart';
import 'widgets/secondary_action_button.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Pickleball/team_management/pickleball_team_management_screen.dart';

class PickleballInitializeMatchScreen extends StatefulWidget {
  const PickleballInitializeMatchScreen({super.key});

  @override
  State<PickleballInitializeMatchScreen> createState() => _PickleballInitializeMatchScreenState();
}

class _PickleballInitializeMatchScreenState extends State<PickleballInitializeMatchScreen> with SingleTickerProviderStateMixin {
  late final PickleballInitializeMatchController controller;
  late final TextEditingController matchNameController;
  late final TextEditingController courtNumberController;
  late final TextEditingController refereeController;
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(PickleballInitializeMatchController());
    controller.initialize();
    controller.loadDefaults();

    matchNameController = TextEditingController();
    courtNumberController = TextEditingController();
    refereeController = TextEditingController();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    matchNameController.dispose();
    courtNumberController.dispose();
    refereeController.dispose();
    _fadeController.dispose();
    Get.delete<PickleballInitializeMatchController>();
    super.dispose();
  }

  void _onInitializeTap() {
    controller.initializeMatch(
      matchNameController.text,
      courtNumberController.text,
      controller.selectedDate.value,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PickleballTeamManagementScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PickleballAppbar(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Create New Match', style: AppTypography.headlineLg),
                    const SizedBox(height: 8),
                    Text(
                      'Initialize a high-intensity pickleball encounter. Define your tournament context, court allocation, and performance rules.',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 24),
                    MatchCoreCard(
                      controller: controller,
                      nameController: matchNameController,
                      courtController: courtNumberController,
                      refereeController: refereeController,
                    ),
                    const SizedBox(height: 24),
                    Obx(() => CategoryChipGroup(
                      options: controller.categoryOptions,
                      selected: controller.selectedCategory.value,
                      onSelect: controller.selectCategory,
                    )),
                    const SizedBox(height: 24),
                    Obx(() => FormatChipGroup(
                      options: controller.formatOptions,
                      selected: controller.selectedFormat.value,
                      onSelect: controller.selectFormat,
                    )),
                    const SizedBox(height: 24),
                    CustomRulesCard(controller: controller),
                    const SizedBox(height: 24),
                    AdvancedOptionsCard(controller: controller),
                    const SizedBox(height: 32),
                    Obx(() => PrimaryActionButton(
                      onTap: _onInitializeTap,
                      isLoading: controller.isLoading.value,
                    )),
                    const SizedBox(height: 16),
                    SecondaryActionButton(
                      text: "Save as Template",
                      onTap: () => controller.saveTemplate(),
                    ),
                    const SizedBox(height: 32), // bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
