import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';

// Internal Widgets
import 'widgets/group_image_picker.dart';
import 'widgets/create_group_text_field.dart';
import 'widgets/sport_selector.dart';
import 'widgets/privacy_selector.dart';
import 'widgets/member_count_slider.dart';
import 'widgets/create_group_submit_button.dart';
import 'widgets/create_group_overlay.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _ctrl = Get.find<GroupsController>();
  int _descLength = 0;

  String _selectedSport = 'Cricket';
  final List<String> _sports = [
    'Cricket',
    'Football',
    'Basketball',
    'Tennis',
    'Badminton',
    'Hockey',
    'Volleyball',
  ];

  bool _isPublic = true;
  double _maxMembers = 25;

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      if (mounted) {
        setState(() {
          _descLength = _descController.text.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final success = await _ctrl.createGroup(
      name: _nameController.text,
      description: _descController.text,
      sport: _selectedSport,
      isPublic: _isPublic,
      maxMembers: _maxMembers.toInt(),
    );

    if (success) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Group',
          style: AppTypography.displayLg.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4),
                vertical: context.heightPct(2),
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo section
                  const GroupImagePicker(),
                  SizedBox(height: context.heightPct(3)),

                  // Group Name
                  _buildSectionTitle(context, 'GROUP NAME'),
                  SizedBox(height: context.heightPct(1.2)),
                  CreateGroupTextField(
                    controller: _nameController,
                    hint: 'Enter your squad name',
                  ),
                  SizedBox(height: context.heightPct(2.5)),

                  // Group Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle(context, 'GROUP DESCRIPTION'),
                      Text(
                        '$_descLength / 200',
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(1.2)),
                  CreateGroupTextField(
                    controller: _descController,
                    hint: 'Tell players what this group is about...',
                    maxLines: 4,
                    maxLength: 200,
                  ),
                  SizedBox(height: context.heightPct(2.5)),

                  // Select Sport
                  _buildSectionTitle(context, 'SELECT SPORT'),
                  SizedBox(height: context.heightPct(1.2)),
                  SportSelector(
                    sports: _sports,
                    selectedSport: _selectedSport,
                    onSportSelected: (sport) =>
                        setState(() => _selectedSport = sport),
                  ),
                  SizedBox(height: context.heightPct(2.5)),

                  // Group Privacy
                  _buildSectionTitle(context, 'GROUP PRIVACY'),
                  SizedBox(height: context.heightPct(1.2)),
                  PrivacySelector(
                    isPublic: _isPublic,
                    onPrivacyChanged: (val) => setState(() => _isPublic = val),
                  ),
                  SizedBox(height: context.heightPct(2.5)),

                  // Maximum Members
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle(context, 'MAXIMUM MEMBERS'),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(2.5),
                          vertical: context.heightPct(0.5),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(context.minDimensionPct(1.5)),
                          border: Border.all(color: AppColors.borderDark),
                        ),
                        child: Text(
                          _maxMembers.toInt().toString(),
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.accent,
                            fontSize: context.responsiveFont(13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(1)),
                  MemberCountSlider(
                    maxMembers: _maxMembers,
                    onChanged: (val) => setState(() => _maxMembers = val),
                  ),
                  SizedBox(height: context.heightPct(4)),

                  // Create Group Button
                  CreateGroupSubmitButton(onPressed: _handleCreate),
                  SizedBox(height: context.heightPct(2)),
                ],
              ),
            ),
          ),

          // Full-screen loading overlay during creation
          const CreateGroupOverlay(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: AppTypography.labelCaps10.copyWith(
        color: AppColors.muted,
        fontSize: context.responsiveFont(11),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
