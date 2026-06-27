import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

import 'edit_profile_constants.dart';
import 'widgets/edit_profile_app_bar.dart';
import 'widgets/profile_photo_picker.dart';
import 'widgets/edit_profile_field.dart';
import 'widgets/public_profile_toggle.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  final _controller = Get.put(UserProfileController());
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      await _controller.fetchUserProfile(docId);
      final user = _controller.rxUser.value;
      if (user != null) {
        _nameController.text = user.fullName;
        _phoneController.text = user.secondaryPhone;
        _emailController.text = user.primaryEmail;
        _dobController.text = user.dob;
        _bioController.text = user.bio;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Pick image error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to pick image")),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name is required")),
      );
      return;
    }

    final user = _controller.rxUser.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not found")),
      );
      return;
    }

    final updatedUser = user.copyWith(
      fullName: _nameController.text.trim(),
      secondaryPhone: _phoneController.text.trim(),
      secondaryEmail: _emailController.text.trim(),
      dob: _dobController.text.trim(),
      bio: _bioController.text.trim(),
    );

    final success = await _controller.updateUserProfile(
      updatedUser: updatedUser,
      imageFile: _imageFile,
    );

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kEditProfileBg,
      appBar: EditProfileAppBar(onSave: _saveProfile),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Profile Photo section
            ProfilePhotoPicker(
              imageFile: _imageFile,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 32),

            EditProfileField(
              label: 'FULL NAME',
              hint: 'Alex Morgan',
              icon: Icons.person,
              controller: _nameController,
            ),
            const SizedBox(height: 20),

            EditProfileField(
              label: 'EMAIL ADDRESS',
              hint: 'alex.morgan@example.com',
              icon: Icons.email,
              controller: _emailController,
            ),
            const SizedBox(height: 20),

            EditProfileField(
              label: 'PHONE NUMBER',
              hint: '+1 (555) 000-1234',
              icon: Icons.phone,
              controller: _phoneController,
            ),
            const SizedBox(height: 20),

            EditProfileField(
              label: 'DATE OF BIRTH',
              hint: 'mm/dd/yyyy',
              icon: Icons.calendar_today,
              controller: _dobController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: kEditProfileGreen,
                          onPrimary: Colors.black,
                          surface: Color(0xFF282828),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  final month = date.month.toString().padLeft(2, '0');
                  final day = date.day.toString().padLeft(2, '0');
                  final year = date.year.toString();
                  _dobController.text = '$month/$day/$year';
                }
              },
            ),
            const SizedBox(height: 20),

            EditProfileField(
              label: 'BIO',
              hint: 'Tell us about your favorite sports,\nteams, or what you\'re looking for...',
              icon: Icons.description,
              controller: _bioController,
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Public Profile Toggle
            const PublicProfileToggle(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
