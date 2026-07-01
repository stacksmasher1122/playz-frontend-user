import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

const kBg = Color(0xFF0C0C0C);
const kSurface = Color(0xFF161616);
const kGreen = Color(0xFF6EDC6A);
const kMuted = Colors.white54;

class CreateGroupScreen extends StatefulWidget {
  CreateGroupScreen({super.key});

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
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Group',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(20)),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo section
                  GroupImagePicker(),
                  SizedBox(height: 32),

                  // Group Name
                  _buildSectionTitle('GROUP NAME'),
                  SizedBox(height: 12),
                  CreateGroupTextField(
                    controller: _nameController,
                    hint: 'Enter your squad name',
                  ),
                  SizedBox(height: 24),

                  // Group Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('GROUP DESCRIPTION'),
                      Text(
                        '$_descLength / 200',
                        style: TextStyle(
                          color: kMuted,
                          fontSize: ResponsiveHelper.sp(10),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  CreateGroupTextField(
                    controller: _descController,
                    hint: 'Tell players what this group is about...',
                    maxLines: 4,
                    maxLength: 200,
                  ),
                  SizedBox(height: 24),

                  // Select Sport
                  _buildSectionTitle('SELECT SPORT'),
                  SizedBox(height: 12),
                  SportSelector(
                    sports: _sports,
                    selectedSport: _selectedSport,
                    onSportSelected: (sport) =>
                        setState(() => _selectedSport = sport),
                  ),
                  SizedBox(height: 24),

                  // Group Privacy
                  _buildSectionTitle('GROUP PRIVACY'),
                  SizedBox(height: 12),
                  PrivacySelector(
                    isPublic: _isPublic,
                    onPrivacyChanged: (val) => setState(() => _isPublic = val),
                  ),
                  SizedBox(height: 24),

                  // Maximum Members
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('MAXIMUM MEMBERS'),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
                        ),
                        child: Text(
                          _maxMembers.toInt().toString(),
                          style: TextStyle(
                            color: kGreen,
                            fontSize: ResponsiveHelper.sp(13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  MemberCountSlider(
                    maxMembers: _maxMembers,
                    onChanged: (val) => setState(() => _maxMembers = val),
                  ),
                  SizedBox(height: 48),

                  // Create Group Button
                  CreateGroupSubmitButton(onPressed: _handleCreate),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Full-screen loading overlay during creation
          CreateGroupOverlay(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: kMuted,
        fontSize: ResponsiveHelper.sp(10),
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
