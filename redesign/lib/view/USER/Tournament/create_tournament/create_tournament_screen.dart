import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

import '../../../../controller/User_Controller/Tournament_Controller/create_tournament_controller.dart';
import 'create_tournament_skeleton.dart';
import 'widgets/bottom_action_bar_widget.dart';
import 'widgets/cover_image_widget.dart';
import 'widgets/description_field_widget.dart';
import 'widgets/schedule_date_time_widget.dart';
import 'widgets/sport_selector_widget.dart';
import 'widgets/step_progress_widget.dart';
import 'widgets/tournament_appbar_widget.dart';
import 'widgets/tournament_text_field.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({super.key});

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  late final CreateTournamentController controller;
  final TextEditingController _tournamentNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(CreateTournamentController());
  }

  @override
  void dispose() {
    _tournamentNameController.dispose();
    _descriptionController.dispose();
    Get.delete<CreateTournamentController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isLoading.value
              ? const CreateTournamentSkeleton(key: ValueKey('skeleton'))
              : _CreateTournamentContent(
                  key: const ValueKey('content'),
                  controller: controller,
                  formKey: _formKey,
                  nameController: _tournamentNameController,
                  descriptionController: _descriptionController,
                ),
        )),
      ),
    );
  }
}

class _CreateTournamentContent extends StatefulWidget {
  final CreateTournamentController controller;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;

  const _CreateTournamentContent({
    super.key,
    required this.controller,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  State<_CreateTournamentContent> createState() => _CreateTournamentContentState();
}

class _CreateTournamentContentState extends State<_CreateTournamentContent> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Column(
      children: [
        // 1. Common AppBar with AppBackButton and Green Cross Button ✕
        TournamentAppbarWidget(
          onBack: () => widget.controller.goBack(context),
          onClose: () => widget.controller.goBack(context),
        ),

        // 2. Step Progress Bar
        Obx(() => StepProgressWidget(currentStep: widget.controller.currentStep.value)),

        // 3. Scrollable Form Body
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16.0),
                vertical: ResponsiveHelper.h(16.0),
              ),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Sports Search Bar + Scoreable Sports Selector
                    Obx(() => SportSelectorWidget(
                          sports: widget.controller.filteredSports,
                          selectedSport: widget.controller.selectedSport.value,
                          onSportSelected: widget.controller.selectSport,
                          searchQuery: widget.controller.searchQuery.value,
                          onSearchChanged: (query) =>
                              widget.controller.searchQuery.value = query,
                        )),
                    SizedBox(height: ResponsiveHelper.h(20.0)),

                    // B. Cover Image Selection Card
                    Obx(() => CoverImageWidget(
                          onTap: widget.controller.pickCoverImage,
                          imagePath: widget.controller.coverImagePath.value,
                        )),
                    SizedBox(height: ResponsiveHelper.h(16.0)),

                    // C. Tournament Name Text Field
                    TournamentTextField(
                      label: "Tournament Name",
                      controller: widget.nameController,
                      hint: "e.g. PlayZ Championship 2026",
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Enter tournament name';
                        return null;
                      },
                    ),
                    SizedBox(height: ResponsiveHelper.h(20.0)),

                    // D. Schedule Timings: Start Date, Start Time, End Date, End Time
                    Obx(() => ScheduleDateTimeWidget(
                          startDate: widget.controller.startDate.value,
                          startTime: widget.controller.startTime.value,
                          endDate: widget.controller.endDate.value,
                          endTime: widget.controller.endTime.value,
                          onSelectStartDate: () =>
                              widget.controller.selectStartDate(context),
                          onSelectStartTime: () =>
                              widget.controller.selectStartTime(context),
                          onSelectEndDate: () =>
                              widget.controller.selectEndDate(context),
                          onSelectEndTime: () =>
                              widget.controller.selectEndTime(context),
                        )),
                    SizedBox(height: ResponsiveHelper.h(20.0)),

                    // E. Description Field
                    DescriptionFieldWidget(controller: widget.descriptionController),
                    SizedBox(height: ResponsiveHelper.h(24.0)),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 4. Bottom Action Bar
        BottomActionBarWidget(
          onBack: () => widget.controller.goBack(context),
          onSaveDraft: widget.controller.saveDraft,
          onNext: () {
            if (widget.formKey.currentState!.validate()) {
              widget.controller.tournamentName.value = widget.nameController.text;
              widget.controller.description.value = widget.descriptionController.text;
              widget.controller.goNext(context);
            }
          },
        ),
      ],
    );
  }
}