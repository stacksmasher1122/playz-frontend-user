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

const kBg = Color(0xFF0C0C0C);
const kSurface = Color(0xFF161616);
const kGreen = Color(0xFF6EDC6A);
const kMuted = Colors.white54;

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
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Group',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo section
                  const GroupImagePicker(),
                  const SizedBox(height: 32),

                  // Group Name
                  _buildSectionTitle('GROUP NAME'),
                  const SizedBox(height: 12),
                  CreateGroupTextField(
                    controller: _nameController,
                    hint: 'Enter your squad name',
                  ),
                  const SizedBox(height: 24),

                  // Group Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('GROUP DESCRIPTION'),
                      Text(
                        '$_descLength / 200',
                        style: const TextStyle(
                          color: kMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CreateGroupTextField(
                    controller: _descController,
                    hint: 'Tell players what this group is about...',
                    maxLines: 4,
                    maxLength: 200,
                  ),
                  const SizedBox(height: 24),

                  // Select Sport
                  _buildSectionTitle('SELECT SPORT'),
                  const SizedBox(height: 12),
                  SportSelector(
                    sports: _sports,
                    selectedSport: _selectedSport,
                    onSportSelected: (sport) =>
                        setState(() => _selectedSport = sport),
                  ),
                  const SizedBox(height: 24),

                  // Group Privacy
                  _buildSectionTitle('GROUP PRIVACY'),
                  const SizedBox(height: 12),
                  PrivacySelector(
                    isPublic: _isPublic,
                    onPrivacyChanged: (val) => setState(() => _isPublic = val),
                  ),
                  const SizedBox(height: 24),

                  // Maximum Members
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('MAXIMUM MEMBERS'),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _maxMembers.toInt().toString(),
                          style: const TextStyle(
                            color: kGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  MemberCountSlider(
                    maxMembers: _maxMembers,
                    onChanged: (val) => setState(() => _maxMembers = val),
                  ),
                  const SizedBox(height: 48),

                  // Create Group Button
                  CreateGroupSubmitButton(onPressed: _handleCreate),
                  const SizedBox(height: 20),
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

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: kMuted,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}
