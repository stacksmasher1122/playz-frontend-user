import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/model/user_profile_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';

import 'widgets/profile_photo_picker.dart';
import 'widgets/profile_setup_field.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProfileSetupScreen extends StatefulWidget {
  final List<String> selectedSports;
  ProfileSetupScreen({super.key, required this.selectedSports});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  static const kMuted = Color(0xFFA7A7A7);
  static const kSpotifyGreen = Color(0xFF22C55E);
  static const kCard = Color(0xFF282828);

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  final _controller = Get.put(UserProfileController());

  bool _isEmailBound = false;
  bool _isPhoneBound = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      await _controller.fetchUserProfile(docId);
      final user = _controller.rxUser.value;
      if (user != null && mounted) {
        _nameController.text = user.fullName;
        _emailController.text = user.primaryEmail;
        _phoneController.text = user.primaryPhone;
      }
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && mounted) {
      setState(() {
        if (currentUser.email != null && currentUser.email!.isNotEmpty) {
          _emailController.text = currentUser.email!;
          _isEmailBound = true;
        }
        if (currentUser.phoneNumber != null &&
            currentUser.phoneNumber!.isNotEmpty) {
          _phoneController.text = currentUser.phoneNumber!;
          _isPhoneBound = true;
        }
      });
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
          SnackBar(content: Text("Failed to pick image")),
        );
      }
    }
  }

  Future<void> _completeSetup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name is required")),
      );
      return;
    }

    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final String docId = email.isNotEmpty ? email : phone;

    if (docId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An email or phone number is required.")),
      );
      return;
    }

    final newUser = UserProfileModel(
      docId: docId,
      fullName: _nameController.text.trim(),
      primaryEmail: email,
      secondaryEmail: email,
      primaryPhone: phone,
      secondaryPhone: phone,
      bio: _bioController.text.trim(),
      dob: _dobController.text.trim(),
      favoriteSports: widget.selectedSports,
      isPublicProfile: _controller.rxUser.value?.isPublicProfile ?? true,
    );

    final success = await _controller.updateUserProfile(
      updatedUser: newUser,
      imageFile: _imageFile,
    );

    if (success) {
      await UserPreferences.saveFavoriteSports(widget.selectedSports);
      await UserPreferences.setTrainer(false);
      await UserPreferences.setProfileComplete(true);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => UserAppNavShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'STEP 2 OF 2',
              style: TextStyle(
                color: kMuted,
                fontSize: ResponsiveHelper.sp(11),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: ResponsiveHelper.h(3), width: ResponsiveHelper.w(30), color: kSpotifyGreen),
                SizedBox(width: 4),
                Container(height: ResponsiveHelper.h(3), width: ResponsiveHelper.w(30), color: kSpotifyGreen),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Complete your profile',
              style: GoogleFonts.inter(
                fontSize: ResponsiveHelper.sp(28),
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tell us a bit about yourself to get started.',
              style: GoogleFonts.inter(fontSize: ResponsiveHelper.sp(15), color: Colors.white70),
            ),
            SizedBox(height: 32),
            ProfilePhotoPicker(
              imageFile: _imageFile,
              onPickImage: _pickImage,
            ),
            SizedBox(height: 32),
            ProfileSetupField(
              label: 'FULL NAME',
              hint: 'Alex Morgan',
              icon: Icons.person,
              controller: _nameController,
            ),
            SizedBox(height: 20),
            ProfileSetupField(
              label: 'PHONE NUMBER',
              hint: '+1 (555) 000-1234',
              icon: Icons.phone,
              controller: _phoneController,
              readOnly: _isPhoneBound,
            ),
            SizedBox(height: 20),
            ProfileSetupField(
              label: 'EMAIL ADDRESS',
              hint: 'alex.morgan@example.com',
              icon: Icons.email,
              controller: _emailController,
              readOnly: _isEmailBound,
            ),
            SizedBox(height: 20),
            ProfileSetupField(
              label: 'DATE OF BIRTH',
              hint: 'mm/dd/yyyy',
              icon: Icons.calendar_today,
              controller: _dobController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Color(0xFF00FF7F),
                          onPrimary: Colors.black,
                          surface: kCard,
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
            SizedBox(height: 20),
            ProfileSetupField(
              label: 'BIO',
              hint: "Tell us about your favorite sports,\nteams, or what you're looking for...",
              icon: Icons.description,
              controller: _bioController,
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Public Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Allow anyone to see your stats',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Switch(
                    value: _controller.rxUser.value?.isPublicProfile ?? true,
                    onChanged: (value) {
                      final user = _controller.rxUser.value;
                      if (user != null) {
                        _controller.setUser(user.copyWith(isPublicProfile: value));
                      } else {
                        _controller.setUser(UserProfileModel(docId: 'temp', isPublicProfile: value));
                      }
                    },
                    activeThumbColor: Colors.black,
                    activeTrackColor: Color(0xFF00FF7F),
                    inactiveThumbColor: Colors.white54,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.h(56),
              child: ElevatedButton(
                onPressed: () => _controller.isLoading.value ? null : _completeSetup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00FF7F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(28))),
                  elevation: 0,
                ),
                child: Obx(
                  () => _controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.black)
                      : Text(
                          'Complete Setup',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(16),
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: Text(
                'By continuing, you agree to our Terms of Service',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
